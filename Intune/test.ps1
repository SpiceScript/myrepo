<#
.SYNOPSIS
   Export ALL Windows-specific Intune configuration, admin-template,
   settings-catalog, and compliance profiles—including every setting
   definition—to individual JSON files.

.DESCRIPTION
   • Uses Microsoft.Graph v2 SDK (app-only).
   • Handles @odata.nextLink pagination transparently.
   • Filters to profiles where platforms array contains 'windows10' or
     'windows10X' (modify as needed).
   • Outputs: C:\IntuneExports\<ProfileType>\<ProfileName>_<Timestamp>.json
#>

#region --------------------------- CONFIG -----------------------------------

$TenantId     = 'YOUR_TENANT_ID'
$ClientId     = 'YOUR_CLIENT_ID'
$ClientSecret = 'YOUR_CLIENT_SECRET'   # store securely in production
$ExportRoot   = 'C:\IntuneExports'     # adjust path if desired

#endregion -------------------------------------------------------------------

#region ----------------------- MODULE + LOGIN -------------------------------

# Install (first run) then import latest SDKs
$required = 'Microsoft.Graph','Microsoft.Graph.Beta'
foreach ($m in $required) {
    if (-not (Get-Module -ListAvailable -Name $m)) {
        Install-Module $m -Scope CurrentUser -Force
    }
    Import-Module $m
}

# Build PSCredential for ClientSecretCredential auth
$secureSecret = ConvertTo-SecureString $ClientSecret -AsPlainText -Force
$AppCred      = [pscredential]::new($ClientId,$secureSecret)

# Connect using app-only
Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $AppCred

#endregion -------------------------------------------------------------------

#region ---------------------- HELPER: Pagination ----------------------------

function Get-MgPagedResult {
    param(
        [Parameter(Mandatory)][string]$RelativeUri,
        [switch]$Beta             # switch to call beta endpoint
    )

    $apiRoot = $Beta.IsPresent ? 'https://graph.microsoft.com/beta/' : 'https://graph.microsoft.com/v1.0/'

    $items = @()
    $next  = $RelativeUri
    do {
        $json = Invoke-MgGraphRequest -Method GET -Uri ($apiRoot + $next)
        $items += $json.value
        $next   = ($json.'@odata.nextLink' -replace '^https://graph.microsoft.com/(beta|v1\.0)/','')
    } while ($next)
    return $items
}

#endregion -------------------------------------------------------------------

#region ---------------------- EXPORT FUNCTIONS ------------------------------

function Export-Json {
    param(
        [Parameter(Mandatory)][object]$Object,
        [Parameter(Mandatory)][string]$FilePath
    )
    $dir = Split-Path $FilePath
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $Object | ConvertTo-Json -Depth 20 | Out-File -FilePath $FilePath -Encoding utf8
}

function Add-SafeName {
    param([string]$Name)
    return ($Name -replace '[\\/:*?"<>|]', '_')
}

#endregion -------------------------------------------------------------------

#region ------------------------ SETTINGS CATALOG ----------------------------

$scCatalog = Get-MgPagedResult -RelativeUri "deviceManagement/configurationPolicies" -Beta

foreach ($policy in $scCatalog | Where-Object { $_.platforms -contains 'windows10' -or $_.platforms -contains 'windows10X' }) {

    # Deep settings with definitions
    $settings = Get-MgPagedResult -RelativeUri "deviceManagement/configurationPolicies/$($policy.id)/settings?`$expand=settingDefinitions" -Beta

    $export = [PSCustomObject]@{
        id           = $policy.id
        name         = $policy.displayName
        description  = $policy.description
        platforms    = $policy.platforms
        technologies = $policy.technologies
        settings     = $settings
    }

    $safe = Add-SafeName $policy.displayName
    Export-Json -Object $export -FilePath (Join-Path $ExportRoot "SettingsCatalog\${safe}_$(Get-Date -Format yyyyMMddHHmmss).json")
}

#endregion -------------------------------------------------------------------

#region ------------------- CLASSIC DEVICE CONFIGURATIONS --------------------

$deviceConfigs = Get-MgPagedResult -RelativeUri "deviceManagement/deviceConfigurations" -Beta

foreach ($dc in $deviceConfigs | Where-Object { $_.platform -match 'windows' }) {
    $detail = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$($dc.id)"
    $safe   = Add-SafeName $dc.displayName
    Export-Json -Object $detail -FilePath (Join-Path $ExportRoot "DeviceConfiguration\${safe}_$(Get-Date -Format yyyyMMddHHmmss).json")
}

#endregion -------------------------------------------------------------------

#region --------------------- ADMIN TEMPLATES (GPO) --------------------------

$gpoProfiles = Get-MgPagedResult -RelativeUri "deviceManagement/groupPolicyConfigurations" -Beta

foreach ($gpo in $gpoProfiles | Where-Object { $_.platforms -contains 'windows10' }) {
    $defs = Get-MgPagedResult -RelativeUri "deviceManagement/groupPolicyConfigurations/$($gpo.id)/definitionValues?`$expand=definition" -Beta

    $export = @{
        id          = $gpo.id
        name        = $gpo.displayName
        description = $gpo.description
        values      = $defs
    }

    $safe = Add-SafeName $gpo.displayName
    Export-Json -Object $export -FilePath (Join-Path $ExportRoot "AdminTemplates\${safe}_$(Get-Date -Format yyyyMMddHHmmss).json")
}

#endregion -------------------------------------------------------------------

#region -------------------------- COMPLIANCE --------------------------------

$compPolicies = Get-MgPagedResult -RelativeUri "deviceManagement/deviceCompliancePolicies" -Beta

foreach ($cp in $compPolicies | Where-Object { $_.platform -match 'windows' }) {
    $detail = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies/$($cp.id)"
    $safe   = Add-SafeName $cp.displayName
    Export-Json -Object $detail -FilePath (Join-Path $ExportRoot "Compliance\${safe}_$(Get-Date -Format yyyyMMddHHmmss).json")
}

#endregion -------------------------------------------------------------------

Write-Host "`nExport complete. Files saved to $ExportRoot" -ForegroundColor Green
