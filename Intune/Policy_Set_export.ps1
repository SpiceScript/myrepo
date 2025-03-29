#Requires -Modules Microsoft.Graph.Beta, ImportExcel

# Configuration
$policySetName = "Your-Policy-Set-Name"
$outputPath = "C:\temp\PolicySetSettingsDetails.xlsx"

# Authenticate
Connect-MgGraph -Scopes "DeviceManagementConfiguration.Read.All" -NoWelcome
$headers = @{ Authorization = "Bearer $(Get-MgAccessToken)" }

# Get Policy Set
$policySet = Invoke-RestMethod `
    -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicySets?`$filter=displayName eq '$policySetName'" `
    -Headers $headers

# Get Assignments
$assignments = Invoke-RestMethod `
    -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicySets/$($policySet.value[0].id)/assignments" `
    -Headers $headers

# Process All Profiles
$results = foreach ($profileId in $assignments.value.target.configurationPolicyIds) {
    # Get Profile Metadata
    $profile = Invoke-RestMethod `
        -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$profileId" `
        -Headers $headers

    # Get Full Settings Tree
    $settings = Invoke-RestMethod `
        -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$profileId/settings?`$expand=settingInstance" `
        -Headers $headers

    # Parse Each Setting
    foreach ($setting in $settings.value) {
        $instance = $setting.settingInstance
        
        [PSCustomObject]@{
            PolicySet      = $policySet.value[0].displayName
            ProfileName    = $profile.name
            Platform       = $profile.platforms -join ","
            SettingName    = $instance.settingDefinitionId
            DataType       = $instance.'@odata.type'.Split('.')[-1]
            Value          = $instance.AdditionalProperties.value ?? $instance.AdditionalProperties
            NestedSettings = ($instance.AdditionalProperties | ConvertTo-Json -Depth 5)
        }
    }
}

# Export to Excel
$results | Export-Excel -Path $outputPath -WorksheetName "Settings Details" -AutoSize -FreezeTopRow -BoldTopRow

# Cleanup
Disconnect-MgGraph
