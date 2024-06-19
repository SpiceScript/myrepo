# Import required modules
Import-Module Microsoft.Graph -Force

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "DeviceManagementConfiguration.Read.All"

# Which AAD group do we want to check against
$groupName = "All-Windows"

# Fetch the group by name
$group = Get-MgGroup -Filter "displayName eq '$groupName'"

# Check if the group is found
if ($null -eq $group) {
    Write-Host "Group '$groupName' not found." -ForegroundColor Red
    exit
}

Write-Host "AAD Group Name: $($group.DisplayName)" -ForegroundColor Green

# Fetch assigned apps
$assignedApps = Get-MgDeviceAppManagementMobileApps -Filter "isAssigned eq true" -ExpandProperty assignments
$appsInGroup = $assignedApps | Where-Object { $_.Assignments | Where-Object { $_.Target.GroupId -eq $group.Id } }

Write-Host "Number of Apps found: $($appsInGroup.Count)" -ForegroundColor Cyan
foreach ($app in $appsInGroup) {
    Write-Host $app.DisplayName -ForegroundColor Yellow
}

# Fetch device compliance policies
$deviceCompliancePolicies = Get-MgDeviceManagementDeviceCompliancePolicies -ExpandProperty assignments
$compliancePoliciesInGroup = $deviceCompliancePolicies | Where-Object { $_.Assignments | Where-Object { $_.Target.GroupId -eq $group.Id } }

Write-Host "Number of Device Compliance policies found: $($compliancePoliciesInGroup.Count)" -ForegroundColor Cyan
foreach ($policy in $compliancePoliciesInGroup) {
    Write-Host $policy.DisplayName -ForegroundColor Yellow
}

# Fetch device configuration policies
$deviceConfigurations = Get-MgDeviceManagementDeviceConfigurations -ExpandProperty assignments
$configurationsInGroup = $deviceConfigurations | Where-Object { $_.Assignments | Where-Object { $_.Target.GroupId -eq $group.Id } }

Write-Host "Number of Device Configurations found: $($configurationsInGroup.Count)" -ForegroundColor Cyan
foreach ($config in $configurationsInGroup) {
    Write-Host $config.DisplayName -ForegroundColor Yellow
}

# Fetch device configuration PowerShell scripts
$deviceManagementScripts = Get-MgDeviceManagementScript -ExpandProperty assignments
$scriptsInGroup = $deviceManagementScripts | Where-Object { $_.Assignments | Where-Object { $_.Target.GroupId -eq $group.Id } }

Write-Host "Number of Device Configuration PowerShell Scripts found: $($scriptsInGroup.Count)" -ForegroundColor Cyan
foreach ($script in $scriptsInGroup) {
    Write-Host $script.DisplayName -ForegroundColor Yellow
}

# Fetch administrative templates
$administrativeTemplates = Get-MgDeviceManagementGroupPolicyConfiguration -ExpandProperty assignments
$templatesInGroup = $administrativeTemplates | Where-Object { $_.Assignments | Where-Object { $_.Target.GroupId -eq $group.Id } }

Write-Host "Number of Device Administrative Templates found: $($templatesInGroup.Count)" -ForegroundColor Cyan
foreach ($template in $templatesInGroup) {
    Write-Host $template.DisplayName -ForegroundColor Yellow
}
