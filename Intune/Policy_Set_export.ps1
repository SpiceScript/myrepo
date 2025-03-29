<#
.SYNOPSIS
Exports all device configuration profile settings from an Intune Policy Set to Excel
#>

# Configuration
$policySetName = "Your-Policy-Set-Name"
$outputPath = "C:\IntuneExports\PolicySettings.xlsx"
$tenantId = "yourtenant.onmicrosoft.com"  # Mandatory: Replace with your tenant ID

# Modules Check
if (-not (Get-Module -ListAvailable Microsoft.Graph.Beta)) {
    Install-Module Microsoft.Graph.Beta -Scope CurrentUser -Force -AllowClobber
}
if (-not (Get-Module -ListAvailable ImportExcel)) {
    Install-Module ImportExcel -Scope CurrentUser -Force
}

Import-Module Microsoft.Graph.Beta
Import-Module ImportExcel

try {
    #region Authentication
    Write-Host "Authenticating to Microsoft Graph..." -ForegroundColor Cyan
    Connect-MgGraph -TenantId $tenantId `
                    -Scopes "DeviceManagementConfiguration.Read.All" `
                    -NoWelcome `
                    -ErrorAction Stop

    # Get fresh access token using Microsoft's recommended method
    $authProvider = [Microsoft.Graph.Authentication.AuthProvider]::new()
    $accessToken = $authProvider.GetAccessTokenAsync((Get-MgContext)).Result
    $headers = @{
        Authorization = "Bearer $accessToken"
        ConsistencyLevel = "eventual"
    }
    Write-Host "Authentication successful!" -ForegroundColor Green
    #endregion

    #region Policy Set Retrieval
    Write-Host "Retrieving Policy Set: $policySetName" -ForegroundColor Cyan
    $encodedName = [System.Web.HttpUtility]::UrlEncode($policySetName)
    $policySet = Invoke-RestMethod `
        -Uri "https://graph.microsoft.com/beta/deviceAppManagement/policySets?`$filter=displayName eq '$encodedName'&`$expand=items" `
        -Headers $headers `
        -ErrorAction Stop

    if (-not $policySet.value) {
        throw "Policy Set '$policySetName' not found!"
    }
    #endregion

    #region Configuration Policies Processing
    $configPolicies = $policySet.value.items | Where-Object {
        $_.resourceType -eq "Microsoft.Management.Services.Api.DeviceConfiguration_ConfigurationPolicy"
    }

    if (-not $configPolicies) {
        throw "No device configuration profiles found in the Policy Set"
    }

    $results = foreach ($policyItem in $configPolicies) {
        try {
            $policyId = $policyItem.resourceId
            Write-Host "Processing policy: $policyId" -ForegroundColor Cyan

            # Get policy details
            $policy = Invoke-RestMethod `
                -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$policyId" `
                -Headers $headers `
                -ErrorAction Stop

            # Get policy settings
            $settings = Invoke-RestMethod `
                -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$policyId/settings" `
                -Headers $headers `
                -ErrorAction Stop

            # Parse settings
            foreach ($setting in $settings.value) {
                [PSCustomObject]@{
                    PolicySetName = $policySet.value.displayName
                    ProfileName = $policy.name
                    ProfileID = $policy.id
                    Platform = $policy.platforms -join ", "
                    Technology = $policy.technologies -join ", "
                    SettingID = $setting.settingInstance.settingDefinitionId
                    DataType = $setting.settingInstance.'@odata.type'.Split('.')[-1]
                    SimpleValue = $setting.settingInstance.AdditionalProperties.value
                    JSONValue = $setting.settingInstance.AdditionalProperties | ConvertTo-Json -Depth 6
                    LastModified = $policy.lastModifiedDateTime
                    Created = $policy.createdDateTime
                }
            }
        }
        catch {
            Write-Host "Error processing policy $policyId : $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    #endregion

    #region Excel Export
    if ($results) {
        Write-Host "Exporting $($results.Count) settings to $outputPath" -ForegroundColor Cyan
        $results | Export-Excel `
            -Path $outputPath `
            -WorksheetName "Settings" `
            -TableName "IntuneSettings" `
            -AutoSize `
            -FreezeTopRow `
            -BoldTopRow `
            -ErrorAction Stop

        Write-Host "Export completed successfully!" -ForegroundColor Green
        if (Test-Path $outputPath) {
            Start-Process $outputPath
        }
    }
    else {
        Write-Host "No settings found to export" -ForegroundColor Yellow
    }
    #endregion
}
catch {
    Write-Host "Critical Error: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $errorStream = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorStream)
        $responseBody = $reader.ReadToEnd()
        Write-Host "API Response: $responseBody" -ForegroundColor Yellow
    }
}
finally {
    Write-Host "Disconnecting from Microsoft Graph..." -ForegroundColor Cyan
    Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null
}
