<#
.SYNOPSIS
Exports Intune Policy Set configuration details using interactive authentication
#>

# Install required modules if missing
if (-not (Get-Module -ListAvailable Microsoft.Graph.Beta)) {
    Install-Module Microsoft.Graph.Beta -Scope CurrentUser -Force
}
if (-not (Get-Module -ListAvailable ImportExcel)) {
    Install-Module ImportExcel -Scope CurrentUser -Force
}

Import-Module Microsoft.Graph.Beta
Import-Module ImportExcel

try {
    # Interactive authentication
    Write-Host "Sign in with your Intune admin credentials..." -ForegroundColor Cyan
    Connect-MgGraph -Scopes "DeviceManagementConfiguration.Read.All" -NoWelcome

    # Get Policy Set details
    $policySetName = Read-Host "Enter Policy Set name"
    $policySet = Get-MgBetaDeviceAppManagementPolicySet -Filter "displayName eq '$policySetName'" -ExpandProperty "items"

    if (-not $policySet) {
        throw "Policy Set '$policySetName' not found"
    }

    # Process configuration policies
    $results = foreach ($item in $policySet.Items) {
        if ($item.ResourceType -eq "Microsoft.Management.Services.Api.DeviceConfiguration_ConfigurationPolicy") {
            $policy = Get-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $item.ResourceId -ExpandProperty "settings"
            
            foreach ($setting in $policy.Settings) {
                [PSCustomObject]@{
                    PolicySetName = $policySet.DisplayName
                    ProfileName = $policy.Name
                    Platform = $policy.Platforms -join ","
                    Technology = $policy.Technologies -join ","
                    SettingID = $setting.SettingInstance.SettingDefinitionId
                    DataType = $setting.SettingInstance.AdditionalProperties.'@odata.type'.Split('.')[-1]
                    SimpleValue = $setting.SettingInstance.AdditionalProperties.value
                    JSONValue = $setting.SettingInstance.AdditionalProperties | ConvertTo-Json -Depth 5
                }
            }
        }
    }

    # Export to Excel
    $outputPath = Read-Host "Enter output file path (e.g., C:\temp\PolicySettings.xlsx)"
    $results | Export-Excel $outputPath -WorksheetName "Settings" -AutoSize -FreezeTopRow -BoldTopRow
    Write-Host "Exported $($results.Count) settings to $outputPath" -ForegroundColor Green
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    Disconnect-MgGraph -ErrorAction SilentlyContinue
}
