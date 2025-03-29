<#
.SYNOPSIS
Exports detailed configuration profile settings from an Intune Policy Set to Excel
#>

# Hardcoded Configuration
$policySetName = "YOUR_POLICY_SET_NAME"  # ← Replace with your policy set name
$outputPath = "C:\IntuneExports\PolicySettings.xlsx"  # ← Replace with your output path

# Check for required modules
if (-not (Get-Module -ListAvailable Microsoft.Graph.Beta)) {
    Write-Host "Installing Microsoft Graph Beta module..." -ForegroundColor Cyan
    Install-Module Microsoft.Graph.Beta -Scope CurrentUser -Force -AllowClobber
}

if (-not (Get-Module -ListAvailable ImportExcel)) {
    Write-Host "Installing ImportExcel module..." -ForegroundColor Cyan
    Install-Module ImportExcel -Scope CurrentUser -Force
}

Import-Module Microsoft.Graph.Beta
Import-Module ImportExcel

# Main script
try {
    # Authenticate to Microsoft Graph
    Write-Host "Starting authentication process..." -ForegroundColor Cyan
    Connect-MgGraph -Scopes "DeviceManagementConfiguration.Read.All" -NoWelcome -ErrorAction Stop
    $accessToken = (Get-MgContext).AccessToken
    $headers = @{ Authorization = "Bearer $accessToken" }
    Write-Host "Successfully authenticated!" -ForegroundColor Green

    # Retrieve Policy Set
    Write-Host "`nProcessing Policy Set: $policySetName" -ForegroundColor Cyan
    $policySet = Invoke-RestMethod `
        -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicySets?`$filter=displayName eq '$policySetName'" `
        -Headers $headers `
        -ErrorAction Stop

    if (-not $policySet.value) {
        throw "Policy Set '$policySetName' not found! Please verify the name."
    }

    $policySetId = $policySet.value[0].id
    Write-Host "Found Policy Set ID: $policySetId" -ForegroundColor Green

    # Retrieve Assignments
    Write-Host "Retrieving assignments..." -ForegroundColor Cyan
    $assignments = Invoke-RestMethod `
        -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicySets/$policySetId/assignments" `
        -Headers $headers `
        -ErrorAction Stop

    $profileIds = $assignments.value.target.configurationPolicyIds
    if (-not $profileIds) {
        throw "No configuration profiles found in the Policy Set"
    }
    Write-Host "Found $($profileIds.Count) configuration profiles" -ForegroundColor Green

    # Process Profiles
    $results = @()
    $totalProfiles = $profileIds.Count
    $current = 1

    foreach ($profileId in $profileIds) {
        try {
            Write-Progress -Activity "Processing Profiles" -Status "$current/$totalProfiles" -PercentComplete ($current/$totalProfiles*100)
            Write-Host "`nProcessing profile $current/$totalProfiles (ID: $profileId)" -ForegroundColor Cyan

            # Get Profile Metadata
            $profile = Invoke-RestMethod `
                -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$profileId" `
                -Headers $headers `
                -ErrorAction Stop

            # Get Profile Settings
            $settings = Invoke-RestMethod `
                -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$profileId/settings?`$expand=settingInstance" `
                -Headers $headers `
                -ErrorAction Stop

            # Parse Settings
            foreach ($setting in $settings.value) {
                $instance = $setting.settingInstance
                $results += [PSCustomObject]@{
                    PolicySetName   = $policySet.value[0].displayName
                    ProfileName     = $profile.name
                    ProfileID       = $profile.id
                    Platform        = $profile.platforms -join ", "
                    Technology      = $profile.technologies -join ", "
                    SettingID       = $instance.settingDefinitionId
                    DataType        = $instance.'@odata.type'.Split('.')[-1]
                    SimpleValue     = $instance.AdditionalProperties.value
                    ComplexValue    = ($instance.AdditionalProperties | ConvertTo-Json -Depth 5)
                    LastModified    = $profile.lastModifiedDateTime
                    Created         = $profile.createdDateTime
                }
            }
            $current++
        }
        catch {
            Write-Host "Error processing profile $profileId : $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    # Export to Excel
    if ($results) {
        Write-Host "`nExporting $($results.Count) settings to $outputPath" -ForegroundColor Cyan
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
}
catch {
    Write-Host "`nFatal Error: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    # Cleanup
    Write-Host "`nDisconnecting from Microsoft Graph..." -ForegroundColor Cyan
    Disconnect-MgGraph -ErrorAction SilentlyContinue
    Write-Host "Script execution completed" -ForegroundColor Cyan
}
