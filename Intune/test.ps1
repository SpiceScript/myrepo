<#
.SYNOPSIS
    Export all Windows Intune configuration & compliance profiles to JSON.

.DESCRIPTION
    • Uses Microsoft.Graph PowerShell SDK v2 (app-only, no interactive login).
    • Queries four endpoints for complete coverage.
    • Handles @odata.nextLink pagination.
    • Names each .json file exactly as the Intune DisplayName (sanitized).
    • Requires Application permission DeviceManagementConfiguration.Read.All.
#>

#region Configuration
$TenantId     = "YOUR_TENANT_ID"         # e.g., "abcd1234-...."
$ClientId     = "YOUR_CLIENT_ID"         # from your App registration
$ClientSecret = "YOUR_CLIENT_SECRET"     # secure storage recommended
$ExportRoot   = "C:\IntuneExports"       # adjust as needed
#endregion

#region Authentication
# Assumes Microsoft.Graph and Microsoft.Graph.Beta modules are already installed.
$secureSecret = ConvertTo-SecureString $ClientSecret -AsPlainText -Force
$appCred      = [pscredential]::new($ClientId, $secureSecret)
Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $appCred
#endregion

#region Helper Functions
function Get-MgPaged {
    param(
        [Parameter(Mandatory)][string]$RelativeUri
    )
    $baseUrl = "https://graph.microsoft.com/beta/"
    $items   = @()
    $next    = $RelativeUri
    do {
        $response = Invoke-MgGraphRequest -Method GET -Uri ($baseUrl + $next)
        $items   += $response.value
        $next     = $response.'@odata.nextLink' -replace '^https://graph.microsoft.com/beta/',''
    } while ($next)
    return $items
}

function SafeName {
    param([string]$Name)
    return ($Name -replace '[\\\/:*?"<>|]','_')
}

function ExportJson {
    param(
        [Parameter(Mandatory)][object]$Object,
        [Parameter(Mandatory)][string]$Path
    )
    $folder = Split-Path $Path
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
    }
    $Object | ConvertTo-Json -Depth 20 | Out-File -FilePath $Path -Encoding utf8
}
#endregion

#region Export: Settings Catalog
$scPolicies = Get-MgPaged -RelativeUri "deviceManagement/configurationPolicies"
foreach ($p in $scPolicies | Where-Object { $_.platforms -contains "windows10" -or $_.platforms -contains "windows10X" }) {
    Write-Host "Exporting Settings Catalog: $($p.displayName)"
    $settings = Get-MgPaged -RelativeUri "deviceManagement/configurationPolicies/$($p.id)/settings?`$expand=settingDefinitions"
    $exportObj = [PSCustomObject]@{
        id           = $p.id
        name         = $p.displayName
        description  = $p.description
        platforms    = $p.platforms
        technologies = $p.technologies
        settings     = $settings
    }
    $file = Join-Path $ExportRoot "SettingsCatalog\$((SafeName $p.displayName)).json"
    ExportJson -Object $exportObj -Path $file
}
#endregion

#region Export: Device Configurations
$deviceConfigs = Get-MgPaged -RelativeUri "deviceManagement/deviceConfigurations"
foreach ($cfg in $deviceConfigs | Where-Object { $_.platform -match "windows" }) {
    Write-Host "Exporting Device Configuration: $($cfg.displayName)"
    $detail = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$($cfg.id)"
    $file   = Join-Path $ExportRoot "DeviceConfigurations\$((SafeName $cfg.displayName)).json"
    ExportJson -Object $detail -Path $file
}
#endregion

#region Export: Administrative Templates (GPO)
$gpoConfigs = Get-MgPaged -RelativeUri "deviceManagement/groupPolicyConfigurations"
foreach ($gpo in $gpoConfigs | Where-Object { $_.platforms -contains "windows10" }) {
    Write-Host "Exporting Admin Template: $($gpo.displayName)"
    $defs = Get-MgPaged -RelativeUri "deviceManagement/groupPolicyConfigurations/$($gpo.id)/definitionValues?`$expand=definition"
    $exportObj = [PSCustomObject]@{
        id               = $gpo.id
        name             = $gpo.displayName
        description      = $gpo.description
        definitionValues = $defs
    }
    $file = Join-Path $ExportRoot "AdminTemplates\$((SafeName $gpo.displayName)).json"
    ExportJson -Object $exportObj -Path $file
}
#endregion

#region Export: Device Compliance
$compPolicies = Get-MgPaged -RelativeUri "deviceManagement/deviceCompliancePolicies"
foreach ($cp in $compPolicies | Where-Object { $_.platform -match "windows" }) {
    Write-Host "Exporting Compliance Policy: $($cp.displayName)"
    $detail = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies/$($cp.id)"
    $file   = Join-Path $ExportRoot "Compliance\$((SafeName $cp.displayName)).json"
    ExportJson -Object $detail -Path $file
}
#endregion

Write-Host "`nExport complete. JSON files are located under $ExportRoot" -ForegroundColor Green
