#Requires -Modules Microsoft.Graph.Beta.DeviceManagement, ImportExcel

<#
.SYNOPSIS
Exports Intune configuration profiles from a Policy Set to Excel
#>

# Configuration
$tenantId = "your-tenant-id"
$clientId = "your-client-id"
$clientSecret = "your-client-secret" | ConvertTo-SecureString -AsPlainText -Force
$policySetName = "Your-Policy-Set-Name"
$outputPath = "C:\temp\PolicySetSettings.xlsx"

# Connect to Microsoft Graph
try {
    $credential = New-Object System.Management.Automation.PSCredential($clientId, $clientSecret)
    Connect-MgGraph -TenantId $tenantId -ClientSecretCredential $credential -NoWelcome
    Write-Host "Connected to Microsoft Graph" -ForegroundColor Green
}
catch {
    Write-Host "Connection failed: $_" -ForegroundColor Red
    exit
}

# Get Policy Set using correct endpoint
try {
    $policySet = Get-MgBetaDeviceManagementConfigurationPolicySet -Filter "displayName eq '$policySetName'" -ExpandProperty "assignments" -ErrorAction Stop
    
    if (-not $policySet) {
        Write-Host "Policy Set '$policySetName' not found" -ForegroundColor Red
        exit
    }
    
    # Get associated configuration profiles
    $policyItems = $policySet.Assignments.Target.AdditionalProperties.configurationPolicyIds
    
    if (-not $policyItems) {
        Write-Host "No configuration profiles found in Policy Set" -ForegroundColor Yellow
        exit
    }
}
catch {
    Write-Host "Error retrieving Policy Set: $_" -ForegroundColor Red
    exit
}

# Collect detailed profile information
$allProfiles = foreach ($policyId in $policyItems) {
    try {
        Get-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $policyId `
            -ExpandProperty "settings,technologies,platforms" -ErrorAction Stop
    }
    catch {
        Write-Host "Error retrieving policy $policyId : $_" -ForegroundColor Yellow
    }
}

# Process settings for Excel export
$reportData = foreach ($profile in $allProfiles) {
    foreach ($setting in $profile.Settings) {
        [PSCustomObject]@{
            PolicySetName = $policySetName
            ProfileName = $profile.Name
            ProfileID = $profile.Id
            Platform = $profile.Platforms -join ","
            Technology = $profile.Technologies -join ","
            SettingName = $setting.SettingInstance.SettingDefinitionId
            Value = $setting.SettingInstance.AdditionalProperties.value ?? $setting.SettingInstance.AdditionalProperties
            DataType = $setting.SettingInstance.'@odata.type'.Split('.')[-1]
            LastModified = $profile.LastModifiedDateTime
            Created = $profile.CreationDateTime
        }
    }
}

# Export to Excel
try {
    $reportData | Export-Excel -Path $outputPath `
        -WorksheetName "Settings" `
        -TableName "ConfigurationSettings" `
        -AutoSize `
        -FreezeTopRow `
        -BoldTopRow
    
    Write-Host "Exported $($reportData.Count) settings to $outputPath" -ForegroundColor Green
}
catch {
    Write-Host "Excel export failed: $_" -ForegroundColor Red
}

# Cleanup
Disconnect-MgGraph | Out-Null
