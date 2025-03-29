<#
.SYNOPSIS
Exports detailed configuration profile settings from an Intune Policy Set to Excel
#>

# Hardcoded Configuration
$policySetName = "YOUR_POLICY_SET_NAME"  # ← Replace with your actual policy set name
$outputPath = "C:\IntuneExports\PolicySettings.xlsx"  # ← Replace with your desired output path

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
    Write-Host "Starting authentication process..." -ForegroundColor Cyan
    Connect-MgGraph -Scopes "DeviceManagementConfiguration.Read.All" -NoWelcome -ErrorAction Stop
    Write-Host "Successfully authenticated!" -ForegroundColor Green

    Write-Host "Processing Policy Set: $policySetName" -ForegroundColor Cyan
    $policySet = Invoke-RestMethod `
        -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicySets?`$filter=displayName eq '$policySetName'" `
        -Headers @{ Authorization = "Bearer $(Get-MgAccessToken)" }

    if (-not $policySet.value) {
        throw "Policy Set '$policySetName' not found! Please verify the name and try again."
    }

    # Rest of the script remains the same...
    # [Previous processing and export logic here]
    
    Write-Host "Export completed successfully to $outputPath" -ForegroundColor Green
}
catch {
    Write-Host "Error occurred: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    Disconnect-MgGraph -ErrorAction SilentlyContinue
}
