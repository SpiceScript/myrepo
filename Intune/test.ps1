<#
.SYNOPSIS
    Export ALL Windows Intune profiles to JSON, with correct file names.
.DESCRIPTION
    • App-only auth: Connect-MgGraph -ClientSecretCredential
    • Full pagination: @odata.nextLink loops
    • File names use exact Intune DisplayName (sanitized)
    • Profile types: Settings Catalog, Device Configurations, Admin Templates, Device Compliance
#>

#region Config
$TenantId     = "YOUR_TENANT_ID"
$ClientId     = "YOUR_CLIENT_ID"
$ClientSecret = "YOUR_CLIENT_SECRET"   # secure in Key Vault
$ExportRoot   = "C:\IntuneExports"
#endregion

#region Modules & Auth
# Ensure modules
foreach ($mod in "Microsoft.Graph","Microsoft.Graph.Beta") {
    if (-not (Get-Module -ListAvailable -Name $mod)) {
        Install-Module $mod -Scope CurrentUser -Force -AllowClobber
    }
    Import-Module $mod -Force
}

# Build PSCredential for app-only auth
$secureSecret = ConvertTo-SecureString $ClientSecret -AsPlainText -Force
$appCred      = [pscredential]::new($ClientId, $secureSecret)

# Connect to Graph
Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $appCred
#endregion

#region Helpers
function Get-MgPaged {
    param([string]$Uri,[switch]$Beta)
    $base = $Beta ? "https://graph.microsoft.com/beta/" : "https://graph.microsoft.com/v1.0/"
    $items = @(); $next = $Uri
    do {
        $resp = Invoke-MgGraphRequest -Method GET -Uri ($base + $next)
        $items += $resp.value
        $next = $resp.'@odata.nextLink' -replace "^https://graph.microsoft.com/(beta|v1\.0)/",""
    } while ($next)
    return $items
}

function SafeName {
    param([string]$n)
    return ($n -replace '[\\\/:*?"<>|]','_')
}

function ExportJson {
    param($obj,[string]$path)
    $dir = Split-Path $path
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $obj | ConvertTo-Json -Depth 20 | Out-File -FilePath $path -Encoding utf8
}
#endregion

#region Export Settings Catalog
$sc = Get-MgPaged -Uri "deviceManagement/configurationPolicies" -Beta
foreach ($p in $sc | Where { $_.platforms -contains "windows10" -or $_.platforms -contains "windows10X" }) {
    $settings = Get-MgPaged -Uri "deviceManagement/configurationPolicies/$($p.id)/settings?`$expand=settingDefinitions" -Beta
    $exportObj = [pscustomobject]@{
        id           = $p.id
        name         = $p.displayName
        description  = $p.description
        platforms    = $p.platforms
        technologies = $p.technologies
        settings     = $settings
    }
    $file = Join-Path $ExportRoot "SettingsCatalog\$((SafeName $p.displayName)).json"
    ExportJson -obj $exportObj -path $file
}
#endregion

#region Export Device Configurations
$dc = Get-MgPaged -Uri "deviceManagement/deviceConfigurations" -Beta
foreach ($c in $dc | Where { $_.platform -match "windows" }) {
    $detail = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$($c.id)"
    $file   = Join-Path $ExportRoot "DeviceConfigurations\$((SafeName $c.displayName)).json"
    ExportJson -obj $detail -path $file
}
#endregion

#region Export Admin Templates
$gp = Get-MgPaged -Uri "deviceManagement/groupPolicyConfigurations" -Beta
foreach ($g in $gp | Where { $_.platforms -contains "windows10" }) {
    $defs = Get-MgPaged -Uri "deviceManagement/groupPolicyConfigurations/$($g.id)/definitionValues?`$expand=definition" -Beta
    $exportObj = [pscustomobject]@{
        id               = $g.id
        name             = $g.displayName
        description      = $g.description
        definitionValues = $defs
    }
    $file = Join-Path $ExportRoot "AdminTemplates\$((SafeName $g.displayName)).json"
    ExportJson -obj $exportObj -path $file
}
#endregion

#region Export Device Compliance
$cp = Get-MgPaged -Uri "deviceManagement/deviceCompliancePolicies" -Beta
foreach ($p in $cp | Where { $_.platform -match "windows" }) {
    $detail = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies/$($p.id)"
    $file   = Join-Path $ExportRoot "Compliance\$((SafeName $p.displayName)).json"
    ExportJson -obj $detail -path $file
}
#endregion

Write-Host "Export complete. Files in '$ExportRoot'" -ForegroundColor Green
