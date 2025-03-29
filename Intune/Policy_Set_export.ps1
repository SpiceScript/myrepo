<#
.SYNOPSIS
Exports device configuration profile settings from an Intune Policy Set using Microsoft Graph
Documentation: https://learn.microsoft.com/en-us/graph/api/intune-policyset-policyset-get?view=graph-rest-beta
#>

# Configuration
$policySetName = "Your-Policy-Set-Name"
$outputPath = "C:\Exports\PolicySetSettings.xlsx"

# Modules Check
if (-not (Get-Module -ListAvailable Microsoft.Graph.Beta)) {
    Install-Module Microsoft.Graph.Beta -Scope CurrentUser -Force
}
if (-not (Get-Module -ListAvailable ImportExcel)) {
    Install-Module ImportExcel -Scope CurrentUser -Force
}

Import-Module Microsoft.Graph.Beta
Import-Module ImportExcel

try {
    # Authenticate
    Connect-MgGraph -Scopes "DeviceManagementConfiguration.Read.All" -NoWelcome
    $headers = @{ Authorization = "Bearer $(Get-MgAccessToken)" }

    # Get Policy Set with expanded items
    $policySet = Invoke-RestMethod `
        -Uri "https://graph.microsoft.com/beta/deviceAppManagement/policySets?`$filter=displayName eq '$policySetName'&`$expand=items" `
        -Headers $headers

    if (-not $policySet.value) {
        throw "Policy Set '$policySetName' not found"
    }

    # Filter for Configuration Policies (Settings Catalog)
    $configItems = $policySet.value.items | Where-Object {
        $_.resourceType -eq "Microsoft.Management.Services.Api.DeviceConfiguration_ConfigurationPolicy"
    }

    if (-not $configItems) {
        throw "No device configuration profiles found in the Policy Set"
    }

    # Process Configuration Policies
    $results = foreach ($item in $configItems) {
        try {
            # Get policy details
            $policy = Invoke-RestMethod `
                -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$($item.resourceId)" `
                -Headers $headers

            # Get policy settings
            $settings = Invoke-RestMethod `
                -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$($item.resourceId)/settings" `
                -Headers $headers

            foreach ($setting in $settings.value) {
                [PSCustomObject]@{
                    PolicySetName = $policySet.value.displayName
                    ProfileName = $policy.name
                    Platform = $policy.platforms -join ","
                    Technology = $policy.technologies -join ","
                    SettingID = $setting.settingInstance.settingDefinitionId
                    DataType = $setting.settingInstance.'@odata.type'.Split('.')[-1]
                    SimpleValue = $setting.settingInstance.AdditionalProperties.value
                    JSONSettings = $setting.settingInstance.AdditionalProperties | ConvertTo-Json -Depth 5
                }
            }
        }
        catch {
            Write-Host "Error processing policy $($item.resourceId): $_" -ForegroundColor Red
        }
    }

    # Export to Excel
    $results | Export-Excel $outputPath -WorksheetName "Settings" -AutoSize -FreezeTopRow
    Write-Host "Exported $($results.Count) settings to $outputPath" -ForegroundColor Green
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
}
finally {
    Disconnect-MgGraph -ErrorAction SilentlyContinue
}
