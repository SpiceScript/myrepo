# Install dependent modules if missing
if (-not (Get-Module -ListAvailable -Name MSAL.PS)) {
    Install-Module -Name MSAL.PS -Scope CurrentUser -Force -AllowClobber
}

# ==== CONFIG VARIABLES ====
$clientId = "<YOUR-ENRA-APP-CLIENT-ID>"
$tenantId = "<YOUR-TENANT-ID>"
$authority = "https://login.microsoftonline.com/$tenantId"
$scopes = "https://graph.microsoft.com/.default"
$exportPath = "C:\IntuneExports"

if (!(Test-Path $exportPath)) {
    New-Item -ItemType Directory -Path $exportPath | Out-Null
}

# ==== AUTHENTICATION ====
$authResult = Get-MsalToken -ClientId $clientId -TenantId $tenantId -Authority $authority -Scopes $scopes -Interactive
$authHeader = @{
    "Authorization" = "Bearer $($authResult.AccessToken)"
    "Content-Type"  = "application/json"
}

# ==== FUNCTIONS ====
function Get-AllSettingsCatalogPolicies {
    $uri = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies?`$filter=technologies has 'mdm'"
    $allPolicies = @()
    do {
        $response = Invoke-RestMethod -Uri $uri -Headers $authHeader -Method Get
        $allPolicies += $response.value
        $uri = if ($response.'@odata.nextLink') { $response.'@odata.nextLink' } else { $null }
    } while ($uri)
    return $allPolicies
}

function Get-PolicySettings {
    param([string]$policyId)
    $uri = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies('$policyId')/settings?`$expand=settingDefinitions"
    $allSettings = @()
    do {
        $response = Invoke-RestMethod -Uri $uri -Headers $authHeader -Method Get
        $allSettings += $response.value
        $uri = if ($response.'@odata.nextLink') { $response.'@odata.nextLink' } else { $null }
    } while ($uri)
    return $allSettings
}

# ==== MAIN EXPORT LOOP ====
$policies = Get-AllSettingsCatalogPolicies
foreach ($policy in $policies) {
    $settings = Get-PolicySettings -policyId $policy.id
    $output = @{
        name         = $policy.displayName
        description  = $policy.description
        id           = $policy.id
        platforms    = $policy.platforms
        technologies = $policy.technologies
        settings     = $settings
    }
    $safeName = ($policy.displayName -replace '[\\\/:*?"<>|]', '_')
    $fileName = "$exportPath\$safeName" + "_" + (Get-Date -Format 'yyyyMMddHHmmss') + ".json"
    $output | ConvertTo-Json -Depth 10 | Set-Content -Path $fileName -Encoding utf8
    Write-Host "Exported: $fileName"
}
