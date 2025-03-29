#Requires -Modules Microsoft.Graph, ImportExcel

<#
.SYNOPSIS
Exports Intune configuration profile settings using interactive authentication
#>

# Configuration - Set your profile IDs here
$profileIds = @(
    "YOUR-POLICY-ID-1",
    "YOUR-POLICY-ID-2"
)

try {
    # 1. Interactive Authentication
    Write-Host "Sign in with your Intune admin credentials..." -ForegroundColor Cyan
    Connect-MgGraph -Scopes "DeviceManagementConfiguration.Read.All" -NoWelcome
    $token = (Get-MgContext).AccessToken
    $headers = @{ Authorization = "Bearer $token" }

    # 2. Process each profile
    $results = foreach ($policyId in $profileIds) {
        try {
            Write-Host "Processing profile: $policyId" -ForegroundColor Cyan
            
            # Get policy details
            $policy = Invoke-RestMethod `
                -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$policyId" `
                -Headers $headers `
                -ErrorAction Stop

            # Get settings using the exact endpoint format you specified
            $settings = Invoke-RestMethod `
                -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$policyId/settings" `
                -Headers $headers `
                -ErrorAction Stop

            # Process settings
            foreach ($setting in $settings.value) {
                $instance = $setting.settingInstance
                
                [PSCustomObject]@{
                    ProfileName = $policy.name
                    Platform = $policy.platforms -join ", "
                    SettingName = $instance.settingDefinitionId
                    DataType = $instance.'@odata.type'.Split('.')[-1]
                    Value = $instance.additionalProperties.value ?? $null
                    NestedSettings = ($instance.additionalProperties | 
                        Where-Object { $_.Keys -ne "value" } |
                        ConvertTo-Json -Depth 5)
                }
            }
        }
        catch {
            Write-Host "Error processing $policyId : $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    # 3. Export to Excel
    $outputPath = Join-Path $env:USERPROFILE "Desktop\ConfigSettingsExport.xlsx"
    $results | Export-Excel $outputPath -WorksheetName "Settings" -AutoSize -FreezeTopRow -BoldTopRow
    Write-Host "Exported $($results.Count) settings to $outputPath" -ForegroundColor Green

    # Open the result
    if (Test-Path $outputPath) {
        Start-Process $outputPath
    }
}
catch {
    Write-Host "Critical error: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null
}
