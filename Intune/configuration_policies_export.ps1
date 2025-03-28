# This PowerShell script authenticates with Microsoft Graph, retrieves Windows 10 MDM-based configuration policies and their settings, and exports them to a JSON file.

# Check and Import Required Module
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Write-Host "Microsoft Graph module not found. Installing..."
    Install-Module Microsoft.Graph -Scope CurrentUser -Force
}
Import-Module Microsoft.Graph

# Function to authenticate using Microsoft Graph PowerShell SDK
function Get-GraphAuthToken {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$TenantId,
        
        [Parameter(Mandatory = $true)]
        [string]$ClientId,
        
        [Parameter(Mandatory = $true)]
        [string]$ClientSecret
    )
    
    # Connect to Microsoft Graph
    $Scopes = @("https://graph.microsoft.com/.default")
    $SecureSecret = ConvertTo-SecureString -String $ClientSecret -AsPlainText -Force
    
    Connect-MgGraph -TenantId $TenantId -ClientId $ClientId -ClientSecret $SecureSecret -Scopes $Scopes
    if ($global:GraphContext) {
        Write-Host "Connected to Microsoft Graph."
    } else {
        Write-Host "Failed to authenticate with Microsoft Graph." -ForegroundColor Red
        exit
    }
}

# Function to get Windows 10 MDM-based configuration policies
function Get-ConfigurationPolicies {
    Write-Host "Fetching Windows 10 configuration policies..."
    $policies = Get-MgBetaDeviceManagementConfigurationPolicy -Filter "platforms has 'windows10' and technologies has 'mdm'"
    if (-not $policies) {
        Write-Host "No Windows 10 policies found." -ForegroundColor Yellow
        exit
    }
    return $policies
}

# Function to get settings for a specific policy
function Get-PolicySettings {
    param (
        [Parameter(Mandatory = $true)]
        [string]$PolicyId
    )
    Write-Host "Fetching settings for policy: $PolicyId"
    $settings = Get-MgBetaDeviceManagementConfigurationPolicySetting -PolicyId $PolicyId
    return $settings
}

# Prompt for Export Path
$ExportPath = "SettingsCatalog_Export.json"
if (!(Test-Path $ExportPath)) {
    New-Item -ItemType File -Path $ExportPath -Force | Out-Null
}

# User Confirmation Before Execution
$Confirm = Read-Host "Do you want to proceed with exporting settings? (y/n)"
if ($Confirm -ne "y" -and $Confirm -ne "Y") {
    Write-Host "Operation canceled by user." -ForegroundColor Yellow
    exit
}

# Main execution
$TenantId = "your-tenant-id"
$ClientId = "your-client-id"
$ClientSecret = "your-client-secret"

Get-GraphAuthToken -TenantId $TenantId -ClientId $ClientId -ClientSecret $ClientSecret
$ConfigurationPolicies = Get-ConfigurationPolicies

# Loop through each policy and fetch settings
$AllSettings = @()
foreach ($policy in $ConfigurationPolicies) {
    $policyId = $policy.Id
    $settings = Get-PolicySettings -PolicyId $policyId
    $AllSettings += $settings
}

# Export settings to JSON
$AllSettings | ConvertTo-Json -Depth 3 | Out-File -FilePath $ExportPath
Write-Host "Settings catalog exported successfully to $ExportPath."
