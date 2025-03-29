# Install necessary modules (if not already installed)
# Install-Module -Name ImportExcel -Force

# Import required modules
Import-Module ImportExcel

# Authenticate interactively using Connect-MSGraph
try {
    Connect-MSGraph
    Write-Host "Successfully authenticated to Microsoft Graph."
} catch {
    Write-Error "Failed to authenticate with Microsoft Graph: $_"
    Exit
}

# Base URLs for Microsoft Graph API
$policySetsUrl = "https://graph.microsoft.com/beta/deviceAppManagement/policySets"
$configPoliciesUrl = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies"

# Prompt user for the Policy Set name
$policySetName = Read-Host "Enter the name of the Policy Set to retrieve"

# Retrieve all Policy Sets and find the one matching the specified name
try {
    $policySetsResponse = Invoke-RestMethod -Uri $policySetsUrl -Method Get -Headers @{Authorization = "Bearer $($Global:MSALAccessToken)"}
    $policySet = $policySetsResponse.value | Where-Object { $_.displayName -eq $policySetName }

    if (-not $policySet) {
        Write-Error "Policy Set with name '$policySetName' not found."
        Exit
    }

    Write-Host "Successfully retrieved Policy Set: $($policySet.displayName)"
} catch {
    Write-Error "Failed to retrieve Policy Sets: $_"
    Exit
}

# Extract configuration policy IDs from the Policy Set's items
$configPolicyIds = @()
foreach ($item in $policySet.items) {
    if ($item.payloadType -eq "configurationPolicies") {
        $configPolicyIds += ($item.payloadId)
    }
}

if (-not $configPolicyIds) {
    Write-Error "No configuration policies found in the Policy Set."
    Exit
}

Write-Host "Found $($configPolicyIds.Count) configuration policies in the Policy Set."

# Retrieve details and settings for each Configuration Policy
$exportData = @()

foreach ($configPolicyId in $configPolicyIds) {
    try {
        # Get configuration policy details
        $configPolicyResponse = Invoke-RestMethod -Uri "$configPoliciesUrl/$configPolicyId" -Method Get -Headers @{Authorization = "Bearer $($Global:MSALAccessToken)"}
        
        # Get settings for this configuration policy
        $settingsResponse = Invoke-RestMethod -Uri "$configPoliciesUrl/$configPolicyId/settings" -Method Get -Headers @{Authorization = "Bearer $($Global:MSALAccessToken)"}
        
        foreach ($setting in $settingsResponse.value) {
            # Prepare data for export
            $exportObject = [PSCustomObject]@{
                PolicySet       = $policySet.displayName
                ProfileName     = $configPolicyResponse.displayName
                Platform        = $configPolicyResponse.platforms -join ", "
                SettingName     = $setting.settingDefinitionId
                DataType        = $setting["@odata.type"]
                Value           = $setting.value | Out-String
                NestedSettings  = ($setting.additionalData | ConvertTo-Json -Depth 10)
            }
            $exportData += $exportObject
        }
    } catch {
        Write-Warning "Failed to retrieve details or settings for Configuration Policy ID '$configPolicyId': $_"
    }
}

# Export data to Excel
$outputFilePath = ".\PolicySetConfigurationPolicies.xlsx"

try {
    $exportData | Export-Excel -Path $outputFilePath -AutoSize -BoldTopRow
    Write-Host "Successfully exported data to Excel file: $outputFilePath"
} catch {
    Write-Error "Failed to export data to Excel: $_"
}

Write-Host "Script execution completed."
