<#
.SYNOPSIS
This script retrieves the BitLocker key escrow status for Windows devices within a specified Azure AD group. 
It checks if devices in the group have their BitLocker recovery keys stored in Azure AD and generates a report.

.DESCRIPTION
The script performs the following steps:
1. Authenticates to Microsoft Graph using a tenant ID, client ID, and client secret.
2. Retrieves all devices that belong to a specified Azure AD group.
3. Fetches BitLocker recovery keys from Azure AD.
4. Matches each device's ID against the list of BitLocker recovery keys to determine escrow status.

.PARAMETERS
- tenantId: The Azure Active Directory tenant ID.
- clientId: The application (client) ID registered in Azure AD.
- clientSecret: The application secret used for authentication.
- groupId: The ID of the Azure AD group containing the devices.

.EXAMPLE
Get-BitlockerEscrowStatusForAADGroup -tenantId "<Your Tenant ID>" -clientId "<Your Client ID>" -clientSecret "<Your Client Secret>" -groupId "<Azure AD Group ID>"
#>

# Function to get all pages of results from the Graph API
function Get-MgGraphAllPages {
    param (
        [Parameter(Mandatory = $true)]
        [string]$NextLink
    )

    $results = @()

    do {
        # Make the API call and get the response
        $response = Invoke-RestMethod -Uri $NextLink -Headers @{Authorization = "Bearer $global:token"} -Method Get
        $results += $response.value
        $NextLink = $response.'@odata.nextLink'
    } while ($NextLink)

    return $results
}

# Function to authenticate to Microsoft Graph and get an authentication token
function Get-AuthToken {
    param (
        [string]$tenantId,
        [string]$clientId,
        [string]$clientSecret
    )

    # Request body for the token request
    $body = @{
        grant_type    = "client_credentials"
        client_id     = $clientId
        client_secret = $clientSecret
        scope         = "https://graph.microsoft.com/.default"
    }

    # Get the authentication token
    $response = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -Method Post -Body $body -ContentType "application/x-www-form-urlencoded"
    $global:token = $response.access_token
}

# Function to get devices within a specified Azure AD group
function Get-DevicesInAADGroup {
    param (
        [string]$groupId
    )

    # API endpoint for retrieving group members (devices)
    $groupMembersUri = "https://graph.microsoft.com/v1.0/groups/$groupId/members?$filter=startswith(deviceId, '')"
    $groupMembers = Get-MgGraphAllPages -NextLink $groupMembersUri

    # Filter devices to only include Windows devices and relevant properties
    return $groupMembers | Where-Object { $_.operatingSystem -eq 'Windows' } | Select-Object deviceId, displayName
}

# Function to get BitLocker escrow status for Azure AD devices
function Get-BitlockerEscrowStatusForAADGroup {
    param (
        [string]$tenantId,
        [string]$clientId,
        [string]$clientSecret,
        [string]$groupId
    )

    # Get the authentication token
    Get-AuthToken -tenantId $tenantId -clientId $clientId -clientSecret $clientSecret

    # Get all devices in the specified Azure AD group
    $aadDevices = Get-DevicesInAADGroup -groupId $groupId

    # Get all BitLocker recovery keys
    $recoveryKeysUri = "https://graph.microsoft.com/beta/informationProtection/bitlocker/recoveryKeys?$select=createdDateTime,deviceId"
    $recoveryKeys = Get-MgGraphAllPages -NextLink $recoveryKeysUri

    # Generate report: Check each device for valid BitLocker keys in Azure AD
    $aadDevices | Select-Object displayName, deviceId, @{
        Name = 'ValidRecoveryBitlockerKeyInAzure'
        Expression = {
            $deviceId = $_.deviceId
            $validRecoveryKey = $recoveryKeys | Where-Object { $_.deviceId -eq $deviceId }
            if ($validRecoveryKey) { $true } else { $false }
        }
    }
}

# Main script execution
$tenantId = "<Your Tenant ID>"
$clientId = "<Your Client ID>"
$clientSecret = "<Your Client Secret>"
$groupId = "<Azure AD Group ID>"

# Run the main function to get the BitLocker escrow status for the specified group
Get-BitlockerEscrowStatusForAADGroup -tenantId $tenantId -clientId $clientId -clientSecret $clientSecret -groupId $groupId
