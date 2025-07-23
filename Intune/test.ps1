<#
.SYNOPSIS
    Export ALL Windows-related Intune configuration & compliance profiles to JSON.

.DESCRIPTION
    • Graph PowerShell SDK v2 (app-only).
    • Handles @odata.nextLink paging for large tenants.
    • Writes one JSON file per profile, named after its Intune DisplayName.
    • Profile types covered: Settings Catalog, classic Device Config, Admin
      Templates, Device Compliance.
#>

#region ----------- CONFIG ---------------------------------------------------

$TenantId     = "YOUR_TENANT_ID"
$ClientId     = "YOUR_CLIENT_ID"
$ClientSecret = "YOUR_CLIENT_SECRET"
$ExportRoot   = "C:\IntuneExports"      # Change if desired

#endregion -------------------------------------------------------------------

#region ----------- MODULES & LOGIN -----------------------------------------

$requiredModules = @("Microsoft.Graph","Microsoft.Graph.Beta")
foreach ($m in $requiredModules) {
    if (-not (Get-Module -ListAvailable -Name $m)) {
        Install-Module $m -Scope CurrentUser -Force -AllowClobber
    }
    Import-Module $m -Force
}

# Convert secret to PSCredential for ClientSecretCredential parameter
$SecureSecret = ConvertTo-SecureString $ClientSecret -AsPlainText -Force
$AppCred      = [pscredential]::new($ClientId,$SecureSecret)

Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $AppCred

#endregion -------------------------------------------------------------------

#region ----------- HELPER FUNCTIONS ----------------------------------------

function Get-MgPaged {
    param(
        [Parameter(Mandatory)][string]$RelativeUri,
        [switch]$Beta
    )
    $root  = $Beta.IsPresent ? "https://graph.microsoft.com/beta/" : "https://graph.microsoft.com/v1.0/"
    $items = @()
    $next  = $RelativeUri
    do {
        $json = Invoke-MgGraphRequest -Method GET -Uri ($root + $next)
        $items += $json.value
        $next   = ($json.'@odata.nextLink' -replace '^https://graph.microsoft.com/(beta|v1\.0)/','')
    } while ($next)
    return $items
}

function Safe-FileName {
    param([string]$Name)
    return ($Name -replace '[\\/:*?"<>|]', '_')
}

function Export-Json {
    param(
        [Parameter(Mandatory)][object]$Object,
        [Parameter(Mandatory)][string]$Path
    )
    $dir = Split-Path $Path
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $Object | ConvertTo-Json -Depth 20 | Out-File -FilePath $Path -Encoding utf8
}

#endregion -------------------------------------------------------------------

#region ----------- SETTINGS CATALOG ----------------------------------------

$scPolicies = Get-MgPaged -RelativeUri "deviceManagement/configurationPolicies" -Beta

foreach ($p in $scPolicies | Where-Object { $_.platforms -contains "windows10" -or $_.platforms -contains "windows10X" }) {

    $settings = Get-MgPaged -RelativeUri ("deviceManagement/configurationPolicies/$($p.id)/settings?`$expand=settingDefinitions") -Beta

    $export = [pscustomobject]@{
        id           = $p.id
        name         = $p.displayName
        description  = $p.description
        platforms    = $p.platforms
        technologies = $p.technologies
        settings     = $settings
    }

    $file = Join-Path $ExportRoot "SettingsCatalog\$(Safe-FileName $($p.displayName))_$(Get-Date -Format yyyyMMddHHmmss).json"
    Export-Json -Object $export -Path $file
}

#endregion -------------------------------------------------------------------

#region ----------- CLASSIC DEVICE CONFIG -----------------------------------

$deviceConfigs = Get-MgPaged -RelativeUri "deviceManagement/deviceConfigurations" -Beta

foreach ($dc in $deviceConfigs | Where-Object { $_.platform -match "windows" }) {
    $detail = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$($dc.id)"
    $file   = Join-Path $ExportRoot "DeviceConfig\$(Safe-FileName $($dc.displayName))_$(Get-Date -Format yyyyMMddHHmmss).json"
    Export-Json -Object $detail -Path $file
}

#endregion -------------------------------------------------------------------

#region ----------- ADMIN TEMPLATES (GPO) -----------------------------------

$gpoConfigs = Get-MgPaged -RelativeUri "deviceManagement/groupPolicyConfigurations" -Beta

foreach ($gpo in $gpoConfigs | Where-Object { $_.platforms -contains "windows10" }) {
    $defs = Get-MgPaged -RelativeUri ("deviceManagement/groupPolicyConfigurations/$($gpo.id)/definitionValues?`$expand=definition") -Beta
    $export = [pscustomobject]@{
        id          = $gpo.id
        name        = $gpo.displayName
        description = $gpo.description
        definitionValues = $defs
    }
    $file = Join-Path $ExportRoot "AdminTemplates\$(Safe-FileName $($gpo.displayName))_$(Get-Date -Format yyyyMMddHHmmss).json"
    Export-Json -Object $export -Path $file
}

#endregion -------------------------------------------------------------------

#region ----------- DEVICE COMPLIANCE ---------------------------------------

$compPolicies = Get-MgPaged -RelativeUri "deviceManagement/deviceCompliancePolicies" -Beta

foreach ($cp in $compPolicies | Where-Object { $_.platform -match "windows" }) {
    $detail = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies/$($cp.id)"
    $file   = Join-Path $ExportRoot "Compliance\$(Safe-FileName $($cp.displayName))_$(Get-Date -Format yyyyMMddHHmmss).json"
    Export-Json -Object $detail -Path $file
}

#endregion -------------------------------------------------------------------

Write-Host "`nExport complete – files are in '$ExportRoot'." -ForegroundColor Green
