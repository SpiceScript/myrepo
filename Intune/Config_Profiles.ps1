#Requires -Module ImportExcel

<#
.SYNOPSIS
Exports specific Intune configuration profile settings to Excel
#>

# Define your profile IDs or names here
$profileIds = @(
    "00000000-0000-0000-0000-000000000001",  # Replace with actual profile IDs
    "00000000-0000-0000-0000-000000000002"
)

try {
    # 1. Interactive Authentication
    Write-Host "Authenticating to Microsoft Graph..." -ForegroundColor Cyan
    Connect-MgGraph -Scopes "DeviceManagementConfiguration.Read.All" -NoWelcome
    $token = (Get-MgContext).AccessToken
    $headers = @{ Authorization = "Bearer $token" }

    # 2. Process defined profiles
    $results = foreach ($profileId in $profileIds) {
        Write-Host "Processing profile: $profileId" -ForegroundColor Cyan
        
        # Get profile details
        $policy = Invoke-RestMethod `
            -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$profileId?`$expand=settings" `
            -Headers $headers `
            -Method Get

        # Process settings
        foreach ($setting in $policy.settings) {
            $instance = $setting.settingInstance
            $simpleValue = $instance.additionalProperties.value
            $nestedSettings = $instance.additionalProperties | 
                Where-Object { $_.Keys -notcontains "value" } |
                ConvertTo-Json -Depth 5

            [PSCustomObject]@{
                ProfileName   = $policy.name
                Platform      = $policy.platforms -join ", "
                SettingName   = $instance.settingDefinitionId
                DataType      = $instance.'@odata.type'.Split('.')[-1]
                Value         = if ($simpleValue) { $simpleValue } else { $null }
                NestedSettings = if ($nestedSettings -ne '{}') { $nestedSettings } else { $null }
            }
        }
    }

    # 3. Export to Excel
    $outputPath = "C:\Exports\ProfileSettings.xlsx"  # Hardcoded output path
    $results | Export-Excel $outputPath -WorksheetName "Settings" -AutoSize -FreezeTopRow -BoldTopRow
    Write-Host "Exported $($results.Count) settings to $outputPath" -ForegroundColor Green
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    Disconnect-MgGraph -ErrorAction SilentlyContinue
}
