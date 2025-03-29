<#
.SYNOPSIS
Exports device configuration profile settings from an Intune Policy Set using Microsoft Graph
#>

# Configuration
$policySetName = "Your-Policy-Set-Name"
$outputPath = "C:\Exports\PolicySettings.xlsx"

# Install required modules
if (-not (Get-Module -ListAvailable Microsoft.Graph.Beta)) {
    Install-Module Microsoft.Graph.Beta -Scope CurrentUser -Force
}
if (-not (Get-Module -ListAvailable ImportExcel)) {
    Install-Module ImportExcel -Scope CurrentUser -Force
}

Import-Module Microsoft.Graph.Beta
Import-Module ImportExcel

try {
    # Authenticate with modern method
    Write-Host "Authenticating..." -ForegroundColor Cyan
    Connect-MgGraph -Scopes "DeviceManagementConfiguration.Read.All" -NoWelcome
    $accessToken = (Get-MgContext).AccessToken
    $headers = @{ Authorization = "Bearer $accessToken" }

    # Get Policy Set using correct endpoint
    Write-Host "Retrieving Policy Set..." -ForegroundColor Cyan
    $policySet = Invoke-RestMethod `
        -Uri "https://graph.microsoft.com/beta/deviceAppManagement/policySets?`$filter=displayName eq '$policySetName'&`$expand=items" `
        -Headers $headers

    if (-not $policySet.value) {
        throw "Policy Set '$policySetName' not found!"
    }

    # Get configuration policies from Policy Set
    $configPolicies = $policySet.value.items | Where-Object {
        $_.resourceType -eq "Microsoft.Management.Services.Api.DeviceConfiguration_ConfigurationPolicy"
    }

    if (-not $configPolicies) {
        throw "No device configuration profiles found in the Policy Set"
    }

    # Process each configuration policy
    $results = foreach ($policyItem in $configPolicies) {
        try {
            $policyId = $policyItem.resourceId
            
            # Get policy details
            $policy = Invoke-RestMethod `
                -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$policyId" `
                -Headers $headers

            # Get policy settings
            $settings = Invoke-RestMethod `
                -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$policyId/settings" `
                -Headers $headers

            # Parse settings
            foreach ($setting in $settings.value) {
                [PSCustomObject]@{
                    PolicySetName = $policySet.value.displayName
                    ProfileName = $policy.name
                    Platform = $policy.platforms -join ","
                    Technology = $policy.technologies -join ","
                    SettingID = $setting.settingInstance.settingDefinitionId
                    DataType = $setting.settingInstance.'@odata.type'.Split('.')[-1]
                    SimpleValue = $setting.settingInstance.AdditionalProperties.value
                    JSONValue = $setting.settingInstance.AdditionalProperties | ConvertTo-Json -Depth 5
                }
            }
        }
        catch {
            Write-Host "Error processing policy $policyId : $_" -ForegroundColor Red
        }
    }

    # Export results
    if ($results) {
        $results | Export-Excel $outputPath -WorksheetName "Settings" -AutoSize -FreezeTopRow
        Write-Host "Exported $($results.Count) settings to $outputPath" -ForegroundColor Green
    }
    else {
        Write-Host "No settings found to export" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
}
finally {
    Disconnect-MgGraph -ErrorAction SilentlyContinue
}
