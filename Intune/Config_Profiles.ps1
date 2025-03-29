# PowerShell script to fetch all device configuration profiles assigned to an AD group using Microsoft Graph Beta API

# Ensure Microsoft Graph Beta Module is installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Beta)) {
    Write-Host "Microsoft Graph Beta module not found. Installing..."
    Install-Module Microsoft.Graph.Beta -Scope CurrentUser -Force
}
Import-Module Microsoft.Graph.Beta

# Authenticate using Microsoft Graph Beta SDK
function Get-GraphAuthToken {
    param (
        [string]$TenantId,
        [string]$ClientId,
        [string]$ClientSecret
    )
    
    $Scopes = @("DeviceManagementConfiguration.Read.All", "Group.Read.All")
    try {
        Connect-MgGraph -TenantId $TenantId -ClientId $ClientId -ClientSecret $ClientSecret -Scopes $Scopes
        Write-Host "Successfully authenticated with Microsoft Graph Beta."
    } catch {
        Write-Host "Failed to authenticate with Microsoft Graph Beta: $_" -ForegroundColor Red
        exit
    }
}

# Fetch assigned configuration profiles for a specific AD group
function Get-AssignedConfigurationPolicies {
    param (
        [string]$GroupName
    )
    Write-Host "Fetching assigned configuration policies for AD group: $GroupName"
    $Group = Get-MgBetaGroup -Filter "displayName eq '$GroupName'"
    if (-not $Group) {
        Write-Host "AD Group not found." -ForegroundColor Red
        exit
    }
    $GroupId = $Group.Id
    $policies = Get-MgBetaDeviceManagementConfigurationPolicy | Where-Object { $_.Assignments -match $GroupId }
    
    foreach ($policy in $policies) {
        Write-Host "Policy Name: $($policy.DisplayName), Policy ID: $($policy.Id)"
    }
}

# Hardcoded AD Group Name
$GroupName = "ADGROUP"

# Authentication Credentials
$TenantId = "your-tenant-id"
$ClientId = "your-client-id"
$ClientSecret = "your-client-secret"

# Execute script
Get-GraphAuthToken -TenantId $TenantId -ClientId $ClientId -ClientSecret $ClientSecret
Get-AssignedConfigurationPolicies -GroupName $GroupName
