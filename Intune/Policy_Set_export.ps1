#Requires -Modules Microsoft.Graph.Beta.DeviceManagement, ImportExcel

<#
.SYNOPSIS
Exports Intune device configuration profiles from a policy set to Excel

.NOTES
1. Requires Microsoft.Graph.Beta.DeviceManagement module
2. Requires ImportExcel module for Excel export (Install-Module ImportExcel)
3. Azure AD App needs DeviceManagementConfiguration.Read.All permissions
#>

# Initialize connection parameters
$tenantId = "your-tenant-id"
$clientId = "your-client-id"
$clientSecret = "your-client-secret" | ConvertTo-SecureString -AsPlainText -Force
$policySetName = "Your-Policy-Set-Name"
$outputPath = "C:\temp\ConfigurationProfiles.xlsx"

# Authenticate to Microsoft Graph
try {
    $credential = New-Object System.Management.Automation.PSCredential($clientId, $clientSecret)
    Connect-MgGraph -TenantId $tenantId -ClientSecretCredential $credential -NoWelcome
    Write-Host "Successfully connected to Microsoft Graph" -ForegroundColor Green
}
catch {
    Write-Host "Connection failed: $_" -ForegroundColor Red
    exit
}

# Retrieve policy set and associated configuration profiles
try {
    # Get the policy set
    $policySet = Get-MgBetaDeviceManagementPolicySet -Filter "displayName eq '$policySetName'" -ExpandProperty "items"
    
    if (-not $policySet) {
        Write-Host "Policy set '$policySetName' not found" -ForegroundColor Red
        exit
    }

    # Get all configuration profile IDs from the policy set
    $profileIds = $policySet.Items | Where-Object {
        $_.ResourceType -eq "Microsoft.Management.Services.Api.DeviceConfiguration_ConfigurationPolicy"
    } | Select-Object -ExpandProperty ResourceId

    if (-not $profileIds) {
        Write-Host "No configuration profiles found in the policy set" -ForegroundColor Yellow
        exit
    }

    # Retrieve details for all configuration profiles
    $allProfiles = foreach ($id in $profileIds) {
        Get-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $id -ExpandProperty "Settings"
    }
}
catch {
    Write-Host "Error retrieving data: $_" -ForegroundColor Red
    exit
}

# Process profiles and extract settings
$reportData = foreach ($profile in $allProfiles) {
    $settings = $profile.Settings | ForEach-Object {
        [PSCustomObject]@{
            ProfileName    = $profile.Name
            SettingName   = $_.SettingInstance.SettingDefinitionId
            Value         = if ($_.SettingInstance.AdditionalProperties.value) {
                                $_.SettingInstance.AdditionalProperties.value
                            } else {
                                $_.SettingInstance.AdditionalProperties | ConvertTo-Json -Depth 5
                            }
            DataType      = $_.SettingInstance.'@odata.type'.Split('.')[-1]
            PolicySet     = $policySetName
            LastModified  = $profile.LastModifiedDateTime
            Platform      = $profile.Platforms
            Technologies  = $profile.Technologies -join ","
        }
    }
    
    if (-not $settings) {
        [PSCustomObject]@{
            ProfileName    = $profile.Name
            SettingName   = "No settings configured"
            Value         = $null
            DataType      = $null
            PolicySet     = $policySetName
            LastModified  = $profile.LastModifiedDateTime
            Platform      = $profile.Platforms
            Technologies  = $profile.Technologies -join ","
        }
    }
    else {
        $settings
    }
}

# Export to Excel
try {
    $reportData | Export-Excel -Path $outputPath -WorksheetName "Configuration Settings" -AutoSize -FreezeTopRow -BoldTopRow -TableName "ConfigurationSettings"
    Write-Host "Successfully exported $($reportData.Count) settings to $outputPath" -ForegroundColor Green
}
catch {
    Write-Host "Error exporting to Excel: $_" -ForegroundColor Red
}

# Disconnect from Graph
Disconnect-MgGraph | Out-Null
