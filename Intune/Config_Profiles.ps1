#Requires -Modules Microsoft.Graph, ImportExcel

<#
.SYNOPSIS
Exports Intune configuration profile settings with proper authentication handling
#>

# Configuration - Replace with your policy IDs
$profileIds = @(
    "deviceConfiguration--bitLockerEnabled",
    "deviceConfiguration--passcodeRequired"
)

function Get-ValidAuthToken {
    # Ensure fresh authentication context
    try {
        $context = Get-MgContext
        if (-not $context -or $context.Scopes -notcontains "DeviceManagementConfiguration.Read.All") {
            Connect-MgGraph -Scopes "DeviceManagementConfiguration.Read.All" -NoWelcome
        }
        return (Get-MgContext).AccessToken
    }
    catch {
        throw "Authentication failed: $_"
    }
}

try {
    # 1. Initialize authentication
    Write-Host "Starting authentication..." -ForegroundColor Cyan
    $token = Get-ValidAuthToken
    $headers = @{
        Authorization = "Bearer $token"
        ContentType = "application/json"
    }

    # 2. Process profiles with token refresh
    $results = foreach ($policyId in $profileIds) {
        try {
            Write-Host "Processing: $policyId" -ForegroundColor Cyan
            
            # Refresh token if needed
            if ((Get-Date) -gt (Get-MgContext).TokenExpiration) {
                $token = Get-ValidAuthToken
                $headers.Authorization = "Bearer $token"
            }

            # Get policy details
            $policy = Invoke-RestMethod `
                -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$policyId" `
                -Headers $headers `
                -Method Get

            # Get settings
            $settings = Invoke-RestMethod `
                -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$policyId/settings" `
                -Headers $headers `
                -Method Get

            foreach ($setting in $settings.value) {
                $instance = $setting.settingInstance
                $simpleValue = $instance.additionalProperties.value
                
                [PSCustomObject]@{
                    ProfileName = $policy.name
                    Platform = $policy.platforms -join ", "
                    SettingName = $instance.settingDefinitionId
                    DataType = $instance.'@odata.type'.Split('.')[-1]
                    Value = if ($simpleValue) { $simpleValue } else { $null }
                    NestedSettings = ($instance.additionalProperties | 
                        Where-Object { $_ -ne $simpleValue } |
                        ConvertTo-Json -Depth 5)
                }
            }
        }
        catch {
            Write-Host "Error processing $policyId : $($_.Exception.Message)" -ForegroundColor Red
            if ($_.Exception.Response) {
                $errorStream = $_.Exception.Response.GetResponseStream()
                $reader = New-Object System.IO.StreamReader($errorStream)
                $responseBody = $reader.ReadToEnd()
                Write-Host "API Response: $responseBody" -ForegroundColor Yellow
            }
        }
    }

    # 3. Export results
    $outputPath = Join-Path $env:USERPROFILE "Desktop\ConfigSettings_$(Get-Date -Format 'yyyyMMdd-HHmmss').xlsx"
    $results | Export-Excel $outputPath -WorksheetName "Settings" -AutoSize -FreezeTopRow -BoldTopRow
    Write-Host "Successfully exported to $outputPath" -ForegroundColor Green

    # Open the file
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
