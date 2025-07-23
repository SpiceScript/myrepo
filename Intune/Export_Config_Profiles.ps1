
<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.

#>

####################################################
function Get-AuthToken {
    Write-Host "Checking for MSAL module…"
    $MsalModule = Get-Module -Name "MSAL.PS" -ListAvailable

    if (-not $MsalModule) {
        Write-Host "MSAL.PS PowerShell module not found, installing..."
        Install-Module -Name "MSAL.PS" -Scope CurrentUser -Force -AllowClobber
    }

    $clientId     = "test"
    $tenantId     = "test"
    $clientSecret = ConvertTo-SecureString "test" -AsPlainText -Force

    $authority = "https://login.microsoftonline.com/$tenantId"
    $scopes    = "https://graph.microsoft.com/.default"

    try {
        $authResult = Get-MsalToken -ClientId $clientId `
                                    -TenantId $tenantId `
                                    -ClientSecret $clientSecret `
                                    -Authority $authority `
                                    -Scopes $scopes

        if ($authResult.AccessToken) {
            $authHeader = @{
                'Content-Type'  = 'application/json'
                'Authorization' = "Bearer $($authResult.AccessToken)"
                'ExpiresOn'     = $authResult.ExpiresOn
            }

            return $authHeader
        } else {
            Write-Host "`nAuthorization Access Token is null, please check credentials..." -ForegroundColor Red
        }
    }
    catch {
        Write-Host "`nError during authentication:" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
}

####################################################

Function Get-SettingsCatalogPolicy(){

<#
.SYNOPSIS
This function is used to get Settings Catalog policies from the Graph API REST interface
.DESCRIPTION
The function connects to the Graph API Interface and gets any Settings Catalog policies
.EXAMPLE
Get-SettingsCatalogPolicy
Returns any Settings Catalog policies configured in Intune
Get-SettingsCatalogPolicy -Platform windows10
Returns any Windows 10 Settings Catalog policies configured in Intune
Get-SettingsCatalogPolicy -Platform macOS
Returns any MacOS Settings Catalog policies configured in Intune
.NOTES
NAME: Get-SettingsCatalogPolicy
#>

[cmdletbinding()]

param
(
 [parameter(Mandatory=$false)]
 [ValidateSet("windows10","macOS")]
 [ValidateNotNullOrEmpty()]
 [string]$Platform
)

$graphApiVersion = "beta"

    if($Platform){
        
        $Resource = "deviceManagement/configurationPolicies?`$filter=platforms has '$Platform' and technologies has 'mdm'"

    }

    else {

        $Resource = "deviceManagement/configurationPolicies?`$filter=technologies has 'mdm'"

    }

   try {
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
    (Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value
}
catch {
    $ex = $_.Exception

    # Try to extract the response content safely
    $responseBody = $null
    if ($ex.Response -is [System.Net.HttpWebResponse]) {
        try {
            $stream = $ex.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($stream)
            $responseBody = $reader.ReadToEnd()
        } catch {
            $responseBody = "Unable to read response stream."
        }
    } elseif ($ex.Response -and $ex.Response.Content) {
        try {
            $responseBody = $ex.Response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
        } catch {
            $responseBody = "Unable to read response content (possibly disposed)."
        }
    }

    Write-Host "Response content:`n$responseBody" -ForegroundColor Red
    Write-Error "Request to $uri failed with HTTP Status: $($ex.Response.StatusCode) $($ex.Response.ReasonPhrase)"
    break
}


}

####################################################

Function Get-SettingsCatalogPolicySettings(){

<#
.SYNOPSIS
This function is used to get Settings Catalog policy Settings from the Graph API REST interface
.DESCRIPTION
The function connects to the Graph API Interface and gets any Settings Catalog policy Settings
.EXAMPLE
Get-SettingsCatalogPolicySettings -policyid policyid
Returns any Settings Catalog policy Settings configured in Intune
.NOTES
NAME: Get-SettingsCatalogPolicySettings
#>

[cmdletbinding()]

param
(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    $policyid
)

$graphApiVersion = "beta"
$Resource = "deviceManagement/configurationPolicies('$policyid')/settings?`$expand=settingDefinitions"

    try {

        $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"

        $Response = (Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get)

        $AllResponses = $Response.value
     
        $ResponseNextLink = $Response."@odata.nextLink"

        while ($ResponseNextLink -ne $null){

            $Response = (Invoke-RestMethod -Uri $ResponseNextLink -Headers $authToken -Method Get)
            $ResponseNextLink = $Response."@odata.nextLink"
            $AllResponses += $Response.value

        }

        return $AllResponses

    }

    catch {

    $ex = $_.Exception
    $errorResponse = $ex.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($errorResponse)
    $reader.BaseStream.Position = 0
    $reader.DiscardBufferedData()
    $responseBody = $reader.ReadToEnd();
    Write-Host "Response content:`n$responseBody" -f Red
    Write-Error "Request to $Uri failed with HTTP Status $($ex.Response.StatusCode) $($ex.Response.StatusDescription)"
    write-host
    break

    }

}

####################################################

Function Export-JSONData(){

<#
.SYNOPSIS
This function is used to export JSON data returned from Graph
.DESCRIPTION
This function is used to export JSON data returned from Graph
.EXAMPLE
Export-JSONData -JSON $JSON
Export the JSON inputted on the function
.NOTES
NAME: Export-JSONData
#>

param (

$JSON,
$ExportPath

)

    try {

        if($JSON -eq "" -or $JSON -eq $null){

            write-host "No JSON specified, please specify valid JSON..." -f Red

        }

        elseif(!$ExportPath){

            write-host "No export path parameter set, please provide a path to export the file" -f Red

        }

        elseif(!(Test-Path $ExportPath)){

            write-host "$ExportPath doesn't exist, can't export JSON Data" -f Red

        }

        else {

            $JSON1 = ConvertTo-Json $JSON -Depth 20

            $JSON_Convert = $JSON1 | ConvertFrom-Json

            $displayName = $JSON_Convert.name

            # Updating display name to follow file naming conventions - https://msdn.microsoft.com/en-us/library/windows/desktop/aa365247%28v=vs.85%29.aspx
            $DisplayName = $DisplayName -replace '\<|\>|:|"|/|\\|\||\?|\*', "_"

            $FileName_JSON = "$DisplayName" + "_" + $(get-date -f dd-MM-yyyy-H-mm-ss) + ".json"

            write-host "Export Path:" "$ExportPath"

            $JSON1 | Set-Content -LiteralPath "$ExportPath\$FileName_JSON"
            write-host "JSON created in $ExportPath\$FileName_JSON..." -f cyan
            
        }

    }

    catch {

    $_.Exception

    }

}

####################################################

#region Authentication

write-host

# Checking if authToken exists before running authentication
if($global:authToken){

    # Setting DateTime to Universal time to work in all timezones
    $DateTime = (Get-Date).ToUniversalTime()

    # If the authToken exists checking when it expires
    $TokenExpires = ($authToken.ExpiresOn.datetime - $DateTime).Minutes

        if($TokenExpires -le 0){

        write-host "Authentication Token expired" $TokenExpires "minutes ago" -ForegroundColor Yellow
        write-host

            # Defining User Principal Name if not present

            if($User -eq $null -or $User -eq ""){

            $User = Read-Host -Prompt "Please specify your user principal name for Azure Authentication"
            Write-Host

            }

        $global:authToken = Get-AuthToken -User $User

        }
}

# Authentication doesn't exist, calling Get-AuthToken function

else {

    if($User -eq $null -or $User -eq ""){

    $User = Read-Host -Prompt "Please specify your user principal name for Azure Authentication"
    Write-Host

    }

# Getting the authorization token
$global:authToken = Get-AuthToken -User $User

}

#endregion

####################################################

$ExportPath = "C:\IntuneOutput"

####################################################

$Policies = Get-SettingsCatalogPolicy

if($Policies){

    foreach($policy in $Policies){

        Write-Host $policy.name -ForegroundColor Yellow

        $AllSettingsInstances = @()

        $policyid = $policy.id
        $Policy_Technologies = $policy.technologies
        $Policy_Platforms = $Policy.platforms
        $Policy_Name = $Policy.name
        $Policy_Description = $policy.description

        $PolicyBody = New-Object -TypeName PSObject

        Add-Member -InputObject $PolicyBody -MemberType 'NoteProperty' -Name 'name' -Value "$Policy_Name"
        Add-Member -InputObject $PolicyBody -MemberType 'NoteProperty' -Name 'description' -Value "$Policy_Description"
        Add-Member -InputObject $PolicyBody -MemberType 'NoteProperty' -Name 'platforms' -Value "$Policy_Platforms"
        Add-Member -InputObject $PolicyBody -MemberType 'NoteProperty' -Name 'technologies' -Value "$Policy_Technologies"
        Add-Member -InputObject $PolicyBody -MemberType 'NoteProperty' -Name 'roleScopeTagIds' -Value @("0")
        Add-Member -InputObject $PolicyBody -MemberType 'NoteProperty' -Name 'priority' -Value 1
        Add-Member -InputObject $PolicyBody -MemberType 'NoteProperty' -Name 'version' -Value 1


        # Checking if policy has a templateId associated
        if($policy.templateReference.templateId){

            Write-Host "Found template reference" -f Cyan
            $templateId = $policy.templateReference.templateId

            $PolicyTemplateReference = New-Object -TypeName PSObject

            Add-Member -InputObject $PolicyTemplateReference -MemberType 'NoteProperty' -Name 'templateId' -Value $templateId

            Add-Member -InputObject $PolicyBody -MemberType 'NoteProperty' -Name 'templateReference' -Value $PolicyTemplateReference

        }

        $SettingInstances = Get-SettingsCatalogPolicySettings -policyid $policyid

        $Instances = $SettingInstances.settingInstance

        foreach($object in $Instances){

            $Instance = New-Object -TypeName PSObject

            Add-Member -InputObject $Instance -MemberType 'NoteProperty' -Name 'settingInstance' -Value $object
            $AllSettingsInstances += $Instance

        }

        Add-Member -InputObject $PolicyBody -MemberType 'NoteProperty' -Name 'settings' -Value @($AllSettingsInstances)

        Export-JSONData -JSON $PolicyBody -ExportPath "$ExportPath"
        Write-Host

    }

}

else {

    Write-Host "No Settings Catalog policies found..." -ForegroundColor Red
    Write-Host

}
