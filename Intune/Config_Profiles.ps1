# PowerShell script to fetch device configuration profiles assigned to an AD group using Microsoft Graph Beta API

# Ensure Microsoft Graph Beta Module is installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Beta)) {
    Write-Host "Installing Microsoft Graph Beta module..."
    Install-Module Microsoft.Graph.Beta -Scope CurrentUser -Force
}
Import-Module Microsoft.Graph.Beta

# Authenticate using Client Credentials flow
function Get-GraphAuthToken {
    param (
        [string]$TenantId,
        [string]$ClientId,
        [string]$ClientSecret
    )
    
    try {
        # Create PSCredential object with client secret
        $SecureClientSecret = ConvertTo-SecureString $ClientSecret -AsPlainText -Force
        $ClientSecretCredential = New-Object System.Management.Automation.PSCredential($ClientId, $SecureClientSecret)
        
        # Connect using client credentials
        Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $ClientSecretCredential
        Write-Host "Authenticated successfully with Microsoft Graph Beta."
    } catch {
        Write-Host ("Authentication failed: {0}" -f $_.Exception.Message) -ForegroundColor Red
        exit
    }
}

# Fetch assigned configuration policies for an AD group
function Get-AssignedConfigurationPolicies {
    param (
        [string]$GroupName
    )
    Write-Host "Checking assignments for group: $GroupName"
    try {
        # Get group ID
        $Group = Get-MgBetaGroup -Filter "displayName eq '$GroupName'"
        if (-not $Group) {
            Write-Host "Group '$GroupName' not found." -ForegroundColor Red
            exit
        }
        $GroupId = $Group.Id

        # Get all configuration policies with assignments
        $AllPolicies = Get-MgBetaDeviceManagementConfigurationPolicy -ExpandProperty "Assignments" -All -ErrorAction Stop
        
        # Filter policies assigned to the group
        $AssignedPolicies = $AllPolicies | Where-Object {
            $_.Assignments.Target.GroupId -contains $GroupId
        }

        if (-not $AssignedPolicies) {
            Write-Host "No configuration policies assigned to group '$GroupName'." -ForegroundColor Yellow
            return
        }

        # Output results
        $AssignedPolicies | ForEach-Object {
            Write-Host ("[+] Policy: {0} (ID: {1})" -f $_.DisplayName, $_.Id)
        }
    } catch {
        Write-Host ("Policy retrieval error: {0}" -f $_.Exception.Message) -ForegroundColor Red
    }
}

# Configuration parameters
$GroupName = "ADGROUP"
$TenantId = "your-tenant-id"
$ClientId = "your-client-id"
$ClientSecret = "your-client-secret"

# Execute
Get-GraphAuthToken -TenantId $TenantId -ClientId $ClientId -ClientSecret $ClientSecret
Get-AssignedConfigurationPolicies -GroupName $GroupName

# Clean up connection
Disconnect-MgGraph -ErrorAction SilentlyContinue
