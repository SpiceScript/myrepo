# Updated PowerShell script using Microsoft Graph module

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
    Connect-MgGraph -TenantId $TenantId -ClientId $ClientId -ClientSecret $ClientSecret -Scopes $Scopes
    
    if ($global:GraphContext) {
        Write-Host "Connected to Microsoft Graph."
    } else {
        Write-Host "Failed to authenticate with Microsoft Graph." -ForegroundColor Red
        exit
    }
}

# Function to get assigned configuration profiles for an AD group
function Get-AssignedConfigurationPolicies {
    param (
        [Parameter(Mandatory = $true)]
        [string]$GroupName
    )
    Write-Host "Fetching assigned configuration policies for AD group: $GroupName"
    $Group = Get-MgGroup -Filter "displayName eq '$GroupName'"
    if (-not $Group) {
        Write-Host "AD Group not found." -ForegroundColor Red
        exit
    }
    $GroupId = $Group.Id
    $policies = Get-MgBetaDeviceManagementConfigurationPolicyAssignment | Where-Object { $_.Target.GroupId -eq $GroupId }
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

# Export settings to Excel
function Export-ToExcel {
    param (
        [Parameter(Mandatory = $true)]
        [Array]$Data,
        
        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )
    if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
        Install-Module -Name ImportExcel -Scope CurrentUser -Force
    }
    Import-Module ImportExcel
    $Data | Export-Excel -Path $FilePath -AutoSize -TableName "ConfigurationSettings"
    Write-Host "Settings exported successfully to $FilePath"
}

# Hardcoded AD Group Name
$GroupName = "ADGROUP"
$ExportPath = "SettingsCatalog_Export.xlsx"

# Main execution
$TenantId = "your-tenant-id"
$ClientId = "your-client-id"
$ClientSecret = "your-client-secret"

Get-GraphAuthToken -TenantId $TenantId -ClientId $ClientId -ClientSecret $ClientSecret
$AssignedPolicies = Get-AssignedConfigurationPolicies -GroupName $GroupName

# Loop through each assigned policy and fetch settings
$AllSettings = @()
foreach ($policy in $AssignedPolicies) {
    $policyId = $policy.Id
    $settings = Get-PolicySettings -PolicyId $policyId
    $AllSettings += $settings
}

# Export settings to Excel
Export-ToExcel -Data $AllSettings -FilePath $ExportPath
