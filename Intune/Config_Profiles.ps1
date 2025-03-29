#Requires -Module Microsoft.Graph, ImportExcel

<#
.SYNOPSIS
Exports Intune configuration profile settings using direct API calls
#>

# Define your configuration profile IDs here
$configProfileIds = @(
    "deviceConfiguration--bitLockerEnabled",  # Replace with actual policy IDs
    "deviceConfiguration--passcodeRequired"   # from Intune portal
)

try {
    # 1. Interactive Authentication
    Write-Host "Authenticating to Microsoft Graph..." -ForegroundColor Cyan
    Connect-MgGraph -Scopes "DeviceManagementConfiguration.Read.All" -NoWelcome
    $token = (Get-MgContext).AccessToken
    $headers = @{ Authorization = "Bearer $token" }

    # 2. Process each configuration profile
    $results = foreach ($profileId in $configProfileIds) {
        Write-Host "Processing profile: $profileId" -ForegroundColor Cyan
        
        # Get settings directly using the exact API endpoint
        $settings = Invoke-RestMethod `
            -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$profileId/settings" `
            -Headers $headers `
            -Method Get

        # Get basic profile info
        $policy = Invoke-RestMethod `
            -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$profileId" `
            -Headers $headers

        # Find associated Policy Sets
        $policySets = Invoke-RestMethod `
            -Uri "https://graph.microsoft.com/beta/deviceAppManagement/policySets?`$expand=items" `
            -Headers $headers | 
            Select-Object -ExpandProperty value |
            Where-Object { $_.items.resourceId -contains $profileId }

        # Process each setting
        foreach ($setting in $settings.value) {
            $instance = $setting.settingInstance
            
            [PSCustomObject]@{
                PolicySet = $policySets.displayName -join ", "
                ProfileName = $policy.name
                Platform = $policy.platforms -join ", "
                SettingName = $instance.settingDefinitionId
                DataType = $instance.'@odata.type'.Split('.')[-1]
                Value = $instance.additionalProperties.value ?? $null
                NestedSettings = ($instance.additionalProperties | 
                    Where-Object { $_ -ne $instance.additionalProperties.value } |
                    ConvertTo-Json -Depth 5)
            }
        }
    }

    # 3. Export to Excel with exact column format
    $outputPath = "C:\ConfigSettingsExport.xlsx"
    $results | Export-Excel -Path $outputPath `
        -WorksheetName "Configuration Settings" `
        -TableName "DeviceConfigurations" `
        -AutoSize `
        -FreezeTopRow `
        -BoldTopRow `
        -ErrorAction Stop

    Write-Host "Successfully exported settings to $outputPath" -ForegroundColor Green
    if (Test-Path $outputPath) {
        Start-Process $outputPath
    }
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $errorStream = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorStream)
        $responseBody = $reader.ReadToEnd()
        Write-Host "API Error Details: $responseBody" -ForegroundColor Yellow
    }
}
finally {
    Disconnect-MgGraph -ErrorAction SilentlyContinue
}
