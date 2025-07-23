# Install Microsoft.Graph module if missing
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Install-Module Microsoft.Graph -Scope CurrentUser -Force
}

Import-Module Microsoft.Graph

# ==== CONFIG ====
$tenantId = "<YOUR_TENANT_ID>"
$clientId = "<YOUR_CLIENT_ID>"
$clientSecret = "<YOUR_CLIENT_SECRET>"
$exportPath = "C:\IntuneExports"

if (-not (Test-Path $exportPath)) {
    New-Item -ItemType Directory -Path $exportPath | Out-Null
}

# ==== CONNECT TO GRAPH USING CLIENT CREDENTIALS ====
$scopes = @("https://graph.microsoft.com/.default")

# Connect to MS Graph with app-only
Connect-MgGraph -ClientId $clientId -TenantId $tenantId -ClientSecret $clientSecret -Scopes $scopes

# Set API version for Intune
Select-MgProfile -Name "beta"


# ==== FUNCTIONS ====

function Get-AllSettingsCatalogPolicies {
    $policies = @()
    $uri = "deviceManagement/configurationPolicies?`$filter=technologies%20ne%20null" # you can tighten filter if needed
    do {
        $page = Invoke-MgGraphRequest -Method GET -Uri $uri
        $policies += $page.value
        $uri = $page.'@odata.nextLink'
        if ($uri) {
            # Strip root URL, only relative path from nextLink, because Invoke-MgGraphRequest needs relative
            $uri = $uri -replace "https://graph.microsoft.com/beta/", ""
        }
    } while ($uri)

    # Filter to only Settings Catalog policies with technology 'mdm' explicitly if needed
    return $policies | Where-Object { $_.technologies -contains 'mdm' }
}

function Get-PolicySettings {
    param([string]$policyId)
    $settings = @()
    $uri = "deviceManagement/configurationPolicies/$policyId/settings?`$expand=settingDefinitions"
    do {
        $page = Invoke-MgGraphRequest -Method GET -Uri $uri
        $settings += $page.value
        $uri = $page.'@odata.nextLink'
        if ($uri) {
            $uri = $uri -replace "https://graph.microsoft.com/beta/", ""
        }
    } while ($uri)
    return $settings
}

# ==== EXPORT ALL POLICIES ====

$policies = Get-AllSettingsCatalogPolicies

foreach ($policy in $policies) {

    $settings = Get-PolicySettings -policyId $policy.id

    $exportObject = [PSCustomObject]@{
        id           = $policy.id
        name         = $policy.displayName
        description  = $policy.description
        platforms    = $policy.platforms
        technologies = $policy.technologies
        settings     = $settings
    }

    $safeName = ($policy.displayName -replace '[\\\/:*?"<>|]', '_')

    $filePath = Join-Path $exportPath "$safeName" + "_" + (Get-Date -Format "yyyyMMddHHmmss") + ".json"

    $exportObject | ConvertTo-Json -Depth 15 | Out-File -FilePath $filePath -Encoding utf8

    Write-Host "Exported policy '$($policy.displayName)' to $filePath"
}

# Disconnect from Graph session after completing export
Disconnect-MgGraph
