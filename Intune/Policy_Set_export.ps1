# Install necessary modules (if not already installed)
# Install-Module Microsoft.Graph.Intune, ImportExcel -Force

# Import required modules
Import-Module Microsoft.Graph.Intune
Import-Module ImportExcel

# 1. Authenticate interactively
try {
    Connect-MgGraph -Scopes "DeviceManagementConfiguration.Read.All","DeviceManagementApps.Read.All"
}
catch {
    Write-Host "Authentication failed. Please check your credentials and scopes."
    Exit
}

# 2. Retrieve the policy set by name
$policySetName = Read-Host "Enter the name of the Policy Set to retrieve"

try {
    $policySet = Get-MgDeviceAppManagementPolicySet | Where-Object {$_.DisplayName -eq $policySetName}

    if (!$policySet) {
        Write-Host "Policy Set with name '$policySetName' not found."
        Exit
    }

    Write-Host "Successfully retrieved policy set: $($policySet.DisplayName)"
}
catch {
    Write-Host "Error retrieving policy set: $($_.Exception.Message)"
    Exit
}

# 3. Extract configuration policy IDs from the policy set's assignments
try {
    # Retrieve Policy Set Assignments
    $policySetAssignments = Get-MgDeviceAppManagementPolicySetAssignment -PolicySetId $policySet.Id

    # Filter only the assignments that target configuration policies
    $configPolicyAssignments = $policySetAssignments | Where-Object {$_.Target -like "*deviceManagement/configurationPolicies/*"}

    # Extract the Configuration Policy IDs from the target URLs
    $configPolicyIds = $configPolicyAssignments.Target -replace '^.*?/deviceManagement/configurationPolicies/([a-f0-9-]{36}).*$', '$1' | Where-Object {$_.Length -eq 36}

    Write-Host "Found $($configPolicyIds.Count) configuration policies assigned to the policy set."
}
catch {
    Write-Host "Error extracting configuration policy IDs: $($_.Exception.Message)"
    Exit
}

# 4. Get details and settings for each configuration policy
$exportData = @()

foreach ($configPolicyId in $configPolicyIds) {
    try {
        $configPolicy = Get-MgDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $configPolicyId

        # Get Configuration Manager settings
        $settings = Get-MgDeviceManagementConfigurationPolicySetting -DeviceManagementConfigurationPolicyId $configPolicyId
        foreach ($setting in $settings) {

            $exportObject = [PSCustomObject]@{
                PolicySet          = $policySet.DisplayName
                ProfileName        = $configPolicy.DisplayName
                Platform           = $configPolicy.platform
                SettingName        = $setting.settingDefinitionId  # Or another property that holds the setting ID
                DataType           = $setting.DataType
                Value              = $setting.value
                NestedSettings     = $setting.AdditionalProperties # Capture all complex settings as JSON
            }
            $exportData += $exportObject
        }

    }
    catch {
        Write-Host "Error retrieving configuration policy details for ID '$configPolicyId': $($_.Exception.Message)"
    }
}

# 5. Export to Excel
try {
    $exportData | Export-Excel -Path ".\PolicySetConfigurationPolicies.xlsx" -AutoSize -BoldTopRow
    Write-Host "Successfully exported data to PolicySetConfigurationPolicies.xlsx"
}
catch {
    Write-Host "Error exporting to Excel: $($_.Exception.Message)"
}

Write-Host "Script completed."
