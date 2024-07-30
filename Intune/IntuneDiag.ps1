<#
.SYNOPSIS
    Analyzes Intune Management Extension diagnostics logs and generates reports.

.DESCRIPTION
    This script merges functionalities from two provided scripts to analyze Intune Management Extension diagnostics logs and generate detailed HTML reports.

.PARAMETER DiagnosticsPath
    The path to the folder containing the diagnostics logs.

.PARAMETER OutputPath
    The path to save the generated reports.

.PARAMETER PolicySetId
    The ID of the PolicySet to analyze.

.EXAMPLE
    .\Analyze-IntuneDiagnostics.ps1 -DiagnosticsPath "C:\Diagnostics" -OutputPath "C:\Reports" -PolicySetId "PolicySetId"

.NOTES
    Requires Microsoft.Graph.Intune PowerShell module.
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$DiagnosticsPath,

    [Parameter(Mandatory = $true)]
    [string]$OutputPath,

    [Parameter(Mandatory = $false)]
    [string]$PolicySetId
)

# Import necessary modules
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Intune)) {
    Install-Module -Name Microsoft.Graph.Intune -Force -Scope CurrentUser
}
Import-Module Microsoft.Graph.Intune

# Function to analyze diagnostics logs
function Analyze-Logs {
    param (
        [string]$DiagnosticsPath,
        [string]$OutputPath
    )

    # Collect logs
    Write-Output "Collecting logs from $DiagnosticsPath..."
    $logs = Get-ChildItem -Path $DiagnosticsPath -Recurse -Filter *.log

    # Analyze logs
    Write-Output "Analyzing logs..."
    $analysisResults = foreach ($log in $logs) {
        $content = Get-Content -Path $log.FullName
        $errors = Select-String -Pattern "error" -InputObject $content
        [PSCustomObject]@{
            LogFile = $log.FullName
            ErrorCount = $errors.Count
            Errors = $errors.Line
        }
    }

    # Generate HTML report
    $html = @"
<!DOCTYPE html>
<html>
<head>
    <title>Log Analysis Report</title>
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid black; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h2>Log Analysis Report</h2>
    <table>
        <tr>
            <th>Log File</th>
            <th>Error Count</th>
            <th>Errors</th>
        </tr>
"@
    foreach ($result in $analysisResults) {
        $html += "<tr><td>$($result.LogFile)</td><td>$($result.ErrorCount)</td><td>$($result.Errors -join '<br>')</td></tr>"
    }
    $html += @"
    </table>
</body>
</html>
"@
    $html | Out-File -FilePath "$OutputPath\LogAnalysisReport.html"
    Write-Output "Analysis report saved to $OutputPath\LogAnalysisReport.html"
}

# Function to analyze Intune PolicySet
function Analyze-PolicySet {
    param (
        [string]$PolicySetId,
        [string]$OutputPath
    )

    # Fetch PolicySet
    Write-Output "Fetching PolicySet with ID $PolicySetId..."
    $policySet = Get-MgDeviceManagementPolicySet -PolicySetId $PolicySetId

    # Analyze PolicySet
    Write-Output "Analyzing PolicySet..."
    $policySetAnalysis = [PSCustomObject]@{
        PolicySetName = $policySet.DisplayName
        PolicyCount = $policySet.Policies.Count
        Policies = $policySet.Policies | Select-Object -Property DisplayName, Id
    }

    # Generate HTML report
    $html = @"
<!DOCTYPE html>
<html>
<head>
    <title>PolicySet Analysis Report</title>
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid black; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h2>PolicySet Analysis Report</h2>
    <p><strong>PolicySet Name:</strong> $($policySetAnalysis.PolicySetName)</p>
    <p><strong>Policy Count:</strong> $($policySetAnalysis.PolicyCount)</p>
    <table>
        <tr>
            <th>Policy Name</th>
            <th>Policy ID</th>
        </tr>
"@
    foreach ($policy in $policySetAnalysis.Policies) {
        $html += "<tr><td>$($policy.DisplayName)</td><td>$($policy.Id)</td></tr>"
    }
    $html += @"
    </table>
</body>
</html>
"@
    $html | Out-File -FilePath "$OutputPath\PolicySetAnalysisReport.html"
    Write-Output "PolicySet analysis report saved to $OutputPath\PolicySetAnalysisReport.html"
}

# Function to extract relevant information from diagnostics logs
function Extract-InfoFromDiagnostics {
    param (
        [string]$DiagnosticsPath,
        [string]$OutputPath
    )

    $diagnosticsFiles = Get-ChildItem -Path $DiagnosticsPath -Filter '*.zip' -Recurse

    $html = @"
<!DOCTYPE html>
<html>
<head>
    <title>Diagnostics Summary</title>
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid black; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h2>Diagnostics Summary</h2>
    <table>
        <tr>
            <th>Device ID</th>
            <th>Status</th>
        </tr>
"@
    foreach ($file in $diagnosticsFiles) {
        $extractedPath = "$DiagnosticsPath\Extracted\$($file.BaseName)"
        Expand-Archive -Path $file.FullName -DestinationPath $extractedPath -Force

        $diagContent = Get-Content -Path "$extractedPath\mdm\diagnostics.txt"
        $parsedInfo = [PSCustomObject]@{
            DeviceId = ($diagContent | Select-String -Pattern 'DeviceID').Line.Split('=')[1].Trim()
            Status = ($diagContent | Select-String -Pattern 'Status').Line.Split('=')[1].Trim()
        }

        $html += "<tr><td>$($parsedInfo.DeviceId)</td><td>$($parsedInfo.Status)</td></tr>"
    }
    $html += @"
    </table>
</body>
</html>
"@
    $html | Out-File -FilePath "$OutputPath\DiagnosticsSummary.html"
    Write-Output "Diagnostics summary saved to $OutputPath\DiagnosticsSummary.html"
}

# Main script execution
Write-Output "Starting analysis..."
Analyze-Logs -DiagnosticsPath $DiagnosticsPath -OutputPath $OutputPath
Extract-InfoFromDiagnostics -DiagnosticsPath $DiagnosticsPath -OutputPath $OutputPath

if ($PolicySetId) {
    Analyze-PolicySet -PolicySetId $PolicySetId -OutputPath $OutputPath
}

Write-Output "Analysis completed."
