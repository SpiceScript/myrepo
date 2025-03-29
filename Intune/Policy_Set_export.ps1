#Requires -Modules Microsoft.Graph.Beta.DeviceManagement, ImportExcel

<#
.SYNOPSIS
Exports Intune Policy Set configuration profiles to Excel using interactive authentication
Documentation Reference: https://learn.microsoft.com/en-us/graph/api/intune-policyset-policyset-get?view=graph-rest-beta
#>

# Configuration
$policySetName = "Your-Policy-Set-Name"
$outputPath = "C:\temp\PolicySetExport.xlsx"

# Helper function for authentication
function Connect-ToGraph {
    try {
        Connect-MgGraph -Scopes "DeviceManagementConfiguration.Read.All" -NoWelcome -ErrorAction Stop
        Write-Host "Successfully authenticated with Microsoft Graph" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to authenticate: $_" -ForegroundColor Red
        exit
    }
}

# Get Policy Set using official API documentation structure
function Get-PolicySetDetails {
    param(
        [string]$policySetName
    )

    try {
        $policySet = Get-MgBetaDeviceManagementConfigurationPolicySet -Filter "displayName eq '$policySetName'" `
            -ExpandProperty "assignments" -All -ErrorAction Stop

        if (-not $policySet) {
            Write-Host "Policy Set '$policySetName' not found" -ForegroundColor Red
            exit
        }

        return $policySet
    }
    catch {
        Write-Host "Error retrieving Policy Set: $_" -ForegroundColor Red
        exit
    }
}

# Main script execution
try {
    # Step 1: Authenticate interactively
    Connect-ToGraph

    # Step 2: Get Policy Set details
    $policySet = Get-PolicySetDetails -policySetName $policySetName

    # Step 3: Extract configuration profile IDs from assignments
    $profileIds = $policySet.Assignments.Target.ConfigurationPolicyIds

    if (-not $profileIds) {
        Write-Host "No configuration profiles found in the Policy Set" -ForegroundColor Yellow
        exit
    }

    # Step 4: Retrieve detailed profile information
    $allProfiles = foreach ($id in $profileIds) {
        try {
            $profile = Get-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $id `
                -ExpandProperty "settings,technologies,platforms" -ErrorAction Stop

            [PSCustomObject]@{
                ProfileName = $profile.Name
                Platform = $profile.Platforms -join ","
                Technology = $profile.Technologies -join ","
                Created = $profile.CreatedDateTime
                LastModified = $profile.LastModifiedDateTime
                Settings = $profile.Settings | ForEach-Object {
                    [PSCustomObject]@{
                        SettingName = $_.SettingInstance.SettingDefinitionId
                        Value = $_.SettingInstance.AdditionalProperties.value ?? $_.SettingInstance.AdditionalProperties
                        DataType = $_.SettingInstance.'@odata.type'.Split('.')[-1]
                    }
                }
            }
        }
        catch {
            Write-Host "Error retrieving profile $id : $_" -ForegroundColor Yellow
        }
    }

    # Step 5: Export to Excel
    $allProfiles | Select-Object ProfileName, Platform, Technology, Created, LastModified, 
        @{Name="Settings";Expression={$_.Settings | ConvertTo-Json}} | 
        Export-Excel -Path $outputPath -WorksheetName "Configuration Profiles" -AutoSize -FreezeTopRow -BoldTopRow

    Write-Host "Successfully exported $($allProfiles.Count) profiles to $outputPath" -ForegroundColor Green
}
finally {
    # Cleanup
    Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null
}
