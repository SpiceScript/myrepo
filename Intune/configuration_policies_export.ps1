# Updated PowerShell script using latest Microsoft Graph API modules with extended logging and error handling

# Ensure Microsoft Graph Module is installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Write-Host "Microsoft Graph module not found. Installing..."
    Install-Module Microsoft.Graph -Scope CurrentUser -Force
}
Import-Module Microsoft.Graph

# Authenticate using Microsoft Graph SDK
function Get-GraphAuthToken {
    param (
        [string]$TenantId,
        [string]$ClientId,
        [string]$ClientSecret
    )
    
    $Scopes = @("DeviceManagementConfiguration.Read.All", "Group.Read.All")
    try {
        Connect-MgGraph -TenantId $TenantId -ClientId $ClientId -ClientSecret $ClientSecret -Scopes $Scopes
        Write-Host "Successfully authenticated with Microsoft Graph."
    } catch {
        Write-Host "Failed to authenticate with Microsoft Graph: $_" -ForegroundColor Red
        exit
    }
}

# Fetch assigned configuration profiles for a specific AD group
function Get-AssignedConfigurationPolicies {
    param (
        [string]$GroupName
    )
    Write-Host "Fetching assigned configuration policies for AD group: $GroupName"
    $Group = Get-MgGroup -Filter "displayName eq '$GroupName'"
    if (-not $Group) {
        Write-Host "AD Group not found." -ForegroundColor Red
        exit
    }
    $GroupId = $Group.Id
    $policies = Get-MgDeviceManagementConfigurationPolicy | Where-Object { $_.Assignments -match $GroupId }
    return $policies
}

# Retrieve settings from a given policy
function Get-PolicySettings {
    param (
        [string]$PolicyId
    )
    Write-Host "Fetching settings for policy ID: $PolicyId"
    try {
        $settings = Get-MgDeviceManagementConfigurationSetting -DeviceManagementConfigurationPolicyId $PolicyId
        return $settings
    } catch {
        Write-Host "Error fetching settings for policy $PolicyId: $_" -ForegroundColor Red
        return $null
    }
}

# Export settings to Excel with enhanced formatting
function Export-ToExcel {
    param (
        [Array]$Data,
        [string]$FilePath
    )
    if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
        Install-Module -Name ImportExcel -Scope CurrentUser -Force
    }
    Import-Module ImportExcel
    
    if ($Data.Count -eq 0) {
        Write-Host "No data to export." -ForegroundColor Yellow
        return
    }
    
    try {
        $Data | Export-Excel -Path $FilePath -AutoSize -TableName "ConfigurationSettings" -BoldTopRow -FreezeTopRow
        Write-Host "Exported settings to $FilePath successfully."
    } catch {
        Write-Host "Failed to export to Excel: $_" -ForegroundColor Red
    }
}

# Hardcoded AD Group Name
$GroupName = "ADGROUP"
$ExportPath = "SettingsCatalog_Export.xlsx"

# Authentication Credentials
$TenantId = "your-tenant-id"
$ClientId = "your-client-id"
$ClientSecret = "your-client-secret"

# Execute script
Get-GraphAuthToken -TenantId $TenantId -ClientId $ClientId -ClientSecret $ClientSecret
$AssignedPolicies = Get-AssignedConfigurationPolicies -GroupName $GroupName

# Collect settings from each assigned policy
$AllSettings = @()
foreach ($policy in $AssignedPolicies) {
    $policyId = $policy.Id
    $settings = Get-PolicySettings -PolicyId $policyId
    if ($settings) {
        $AllSettings += $settings
    }
}

# Export settings to Excel
Export-ToExcel -Data $AllSettings -FilePath $ExportPath
