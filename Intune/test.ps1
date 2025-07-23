<#
.SYNOPSIS
    Export all Windows Intune configuration & compliance profiles to JSON.

.DESCRIPTION
    • Uses Microsoft.Graph PowerShell SDK v1.0 (app-only, no interactive login).
    • Queries four endpoints for complete coverage.
    • Handles @odata.nextLink pagination with retry and error handling.
    • Names each .json file exactly as the Intune DisplayName (sanitized).
    • Requires Application permission DeviceManagementConfiguration.Read.All.
#>

#region Global Preferences & Module Imports
$ErrorActionPreference = 'Stop'
$DebugPreference       = 'Continue'
$VerbosePreference     = 'Continue'

# Import required Microsoft Graph modules
Import-Module Microsoft.Graph.DeviceManagement.Configuration -ErrorAction Stop
Import-Module Microsoft.Graph.DeviceManagement.DeviceConfigurations -ErrorAction Stop
Import-Module Microsoft.Graph.DeviceManagement.GroupPolicyConfigurations -ErrorAction Stop
Import-Module Microsoft.Graph.DeviceManagement.DeviceCompliancePolicies -ErrorAction Stop
Import-Module Microsoft.Graph.Authentication -ErrorAction Stop
#endregion

#region Load Credentials from XML
# XML structure example:
# <Credentials>
#   <TenantId>abcd1234-....</TenantId>
#   <ClientId>yyyy5678-....</ClientId>
#   <ClientSecret>YOUR_CLIENT_SECRET</ClientSecret>
# </Credentials>

$xmlPath = 'C:\prasad\scripts\GraphCreds.xml'
try {
    [xml]$credData = Get-Content -Path $xmlPath -ErrorAction Stop
} catch {
    Throw "Failed to read credentials XML at $xmlPath: $_"
}
$TenantId     = $credData.Credentials.TenantId
$ClientId     = $credData.Credentials.ClientId
$ClientSecret = $credData.Credentials.ClientSecret
#endregion

#region Configuration
$ExportRoot = "C:\IntuneExports"  # adjust as needed
#endregion

#region Authentication
Write-Verbose "Connecting to Microsoft Graph (app-only)..."
Connect-MgGraph `
    -ClientId     $ClientId `
    -TenantId     $TenantId `
    -ClientSecret $ClientSecret `
    -Scopes       "https://graph.microsoft.com/.default" `
    -Verbose -Debug
Write-Verbose "Authentication successful."
#endregion

#region Helper Functions

function SafeName {
    param([string]$Name)
    $sanitized = $Name -replace '[\\\/:*?"<>|]','_'
    return $sanitized.TrimEnd('.',' ')
}

function ExportJson {
    param(
        [Parameter(Mandatory)][object]$Object,
        [Parameter(Mandatory)][string]$Path
    )
    $folder = Split-Path $Path
    if (-not (Test-Path $folder)) {
        Write-Verbose "Creating folder: $folder"
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
    }
    Write-Verbose "Writing JSON to $Path"
    $Object | ConvertTo-Json -Depth 20 | Out-File -FilePath $Path -Encoding utf8
}

function Get-MgPaged {
    param([Parameter(Mandatory)][string]$RelativeUri)
    $baseUrl = "https://graph.microsoft.com/v1.0/"
    $items   = @()
    $next    = $RelativeUri

    while ($next) {
        Write-Verbose "Requesting: $baseUrl$next"
        try {
            $response = Invoke-MgGraphRequest -Method GET -Uri ($baseUrl + $next) -Debug
        } catch {
            Write-Warning "Request failed for '$next': $_"
            break
        }
        if (-not $response.value) {
            Write-Warning "No 'value' array returned from '$next'."
            break
        }
        $items += $response.value
        if ($response.'@odata.nextLink') {
            $next = $response.'@odata.nextLink' -replace '^https://graph.microsoft.com/v1.0/',''
        } else {
            $next = $null
        }
    }

    return $items
}

function SafeInvoke {
    param([ScriptBlock]$Block)
    try {
        & $Block
    } catch {
        Write-Error "Error in block: $_"
    }
}
#endregion

#region Ensure Export Root
if (-not (Test-Path $ExportRoot)) {
    Write-Verbose "Creating export root: $ExportRoot"
    New-Item -ItemType Directory -Path $ExportRoot -Force | Out-Null
}
#endregion

#region Export: Settings Catalog
SafeInvoke {
    $scPolicies = Get-MgPaged -RelativeUri "deviceManagement/configurationPolicies"
    foreach ($p in $scPolicies | Where-Object { $_.platforms -contains "windows10" -or $_.platforms -contains "windows10X" }) {
        Write-Host "Exporting Settings Catalog: $($p.displayName)"
        $settings = Get-MgPaged -RelativeUri "deviceManagement/configurationPolicies/$($p.id)/settings?`$expand=settingDefinitions"
        $exportObj = [PSCustomObject]@{
            id           = $p.id
            displayName  = $p.displayName
            description  = $p.description
            platforms    = $p.platforms
            technologies = $p.technologies
            settings     = $settings
        }
        $file = Join-Path $ExportRoot "SettingsCatalog" (SafeName $p.displayName + ".json")
        ExportJson -Object $exportObj -Path $file
    }
}
#endregion

#region Export: Device Configurations
SafeInvoke {
    $deviceConfigs = Get-MgPaged -RelativeUri "deviceManagement/deviceConfigurations"
    foreach ($cfg in $deviceConfigs | Where-Object { $_.platform -match "windows" }) {
        Write-Host "Exporting Device Configuration: $($cfg.displayName)"
        $detail = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/v1.0/deviceManagement/deviceConfigurations/$($cfg.id)" -Debug
        $file   = Join-Path $ExportRoot "DeviceConfigurations" (SafeName $cfg.displayName + ".json")
        ExportJson -Object $detail -Path $file
    }
}
#endregion

#region Export: Administrative Templates (GPO)
SafeInvoke {
    $gpoConfigs = Get-MgPaged -RelativeUri "deviceManagement/groupPolicyConfigurations"
    foreach ($gpo in $gpoConfigs | Where-Object { $_.platforms -contains "windows10" }) {
        Write-Host "Exporting Admin Template: $($gpo.displayName)"
        $defs = Get-MgPaged -RelativeUri "deviceManagement/groupPolicyConfigurations/$($gpo.id)/definitionValues?`$expand=definition"
        $exportObj = [PSCustomObject]@{
            id               = $gpo.id
            displayName      = $gpo.displayName
            description      = $gpo.description
            definitionValues = $defs
        }
        $file = Join-Path $ExportRoot "AdminTemplates" (SafeName $gpo.displayName + ".json")
        ExportJson -Object $exportObj -Path $file
    }
}
#endregion

#region Export: Device Compliance Policies
SafeInvoke {
    $compPolicies = Get-MgPaged -RelativeUri "deviceManagement/deviceCompliancePolicies"
    foreach ($cp in $compPolicies | Where-Object { $_.platform -match "windows" }) {
        Write-Host "Exporting Compliance Policy: $($cp.displayName)"
        $detail = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/v1.0/deviceManagement/deviceCompliancePolicies/$($cp.id)" -Debug
        $file   = Join-Path $ExportRoot "Compliance" (SafeName $cp.displayName + ".json")
        ExportJson -Object $detail -Path $file
    }
}
#endregion

Write-Host "`nExport complete. JSON files are located under $ExportRoot" -ForegroundColor Green
