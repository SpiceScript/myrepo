# PowerShell script to fetch all device configuration profiles assigned to an AD group using Microsoft Graph Beta API

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
    
    $Scopes = @("https://graph.microsoft.com/.default")
    try {
        $SecureClientSecret = ConvertTo-SecureString $ClientSecret -AsPlainText -Force
        $ClientSecretCredential = [System.Management.Automation.PSCredential]::new($ClientId, $SecureClientSecret)
        
        Connect-MgGraph -TenantId $TenantId -ClientId $ClientId -Credential $ClientSecretCredential -Scopes $Scopes
        Write-Host "Successfully authenticated with Microsoft Graph Beta."
    } catch {
        Write-Host ("Failed to authenticate with Microsoft Graph Beta: {0}" -f $_.Exception.Message) -ForegroundColor Red
        exit
    }
}

# Fetch assigned configuration profiles for a specific AD group
function Get-AssignedConfigurationPolicies {
    param (
        [string]$GroupName
    )
    Write-Host "Fetching assigned configuration policies for AD group: $GroupName"
    try {
        $Group = Get-MgBetaGroup -Filter "displayName eq '$GroupName'"
        if (-not $Group) {
            Write-Host "AD Group not found." -ForegroundColor Red
            exit
        }
        $GroupId = $Group.Id
        $policies = Get-MgBetaDeviceManagementConfigurationPolicy | Where-Object { $_.Assignments -match $GroupId }
        
        foreach ($policy in $policies) {
            Write-Host ("Policy Name: {0}, Policy ID: {1}" -f $policy.DisplayName, $policy.Id)
        }
    } catch {
        Write-Host ("Error fetching policies: {0}" -f $_.Exception.Message) -ForegroundColor Red
    }
}

# Hardcoded AD Group Name
$GroupName = "ADGROUP"

# Authentication Credentials
$TenantId = "35345wsdfs5345wersdsff"
$ClientId = "35345wsdfs5345wersdsffw4345345"
$ClientSecret = "35345wsdfs5345wersdsff3wefsdfw334"

# Execute script
Get-GraphAuthToken -TenantId $TenantId -ClientId $ClientId -ClientSecret $ClientSecret
Get-AssignedConfigurationPolicies -GroupName $GroupName
