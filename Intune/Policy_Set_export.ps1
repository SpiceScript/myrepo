#Requires -Modules Microsoft.Graph.Beta, ImportExcel

<#
.SYNOPSIS
Exports Intune Configuration Profiles from Policy Sets to Excel
#>

# Configuration
$tenantId = "your-tenant-id"
$clientId = "your-client-id"
$clientSecret = "your-client-secret"
$policySetName = "Your-Policy-Set-Name"
$outputPath = "C:\temp\PolicySetExport.xlsx"

# Initialize Connection
$body = @{
    client_id = $clientId
    client_secret = $clientSecret
    scope = "https://graph.microsoft.com/.default"
    grant_type = "client_credentials"
}

$tokenRequest = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -Method POST -Body $body
$headers = @{Authorization = "Bearer $($tokenRequest.access_token)"}

# Get Policy Set using direct API call
$policySet = Invoke-RestMethod -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicySets?`$filter=displayName eq '$policySetName'" -Headers $headers

if (-not $policySet.value) {
    Write-Host "Policy Set not found!" -ForegroundColor Red
    exit
}

$policySetId = $policySet.value[0].id

# Get Policy Set assignments
$assignments = Invoke-RestMethod -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicySets/$policySetId/assignments" -Headers $headers

# Extract configuration profile IDs
$profileIds = $assignments.value.target.configurationPolicyIds

if (-not $profileIds) {
    Write-Host "No configuration profiles found in the Policy Set" -ForegroundColor Yellow
    exit
}

# Collect profile details
$allProfiles = foreach ($id in $profileIds) {
    $profile = Invoke-RestMethod -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$id" -Headers $headers
    $settings = Invoke-RestMethod -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$id/settings" -Headers $headers
    
    [PSCustomObject]@{
        ProfileName = $profile.name
        Description = $profile.description
        Platform = $profile.platforms -join ","
        Technology = $profile.technologies -join ","
        Created = $profile.createdDateTime
        LastModified = $profile.lastModifiedDateTime
        SettingsCount = $settings.value.Count
        Settings = $settings.value | ConvertTo-Json -Depth 5
    }
}

# Export to Excel
$allProfiles | Export-Excel -Path $outputPath -WorksheetName "Configuration Profiles" -AutoSize -TableName "IntuneSettings" -FreezeTopRow

Write-Host "Exported $($allProfiles.Count) profiles to $outputPath" -ForegroundColor Green
