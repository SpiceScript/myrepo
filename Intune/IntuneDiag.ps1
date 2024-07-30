<#
.SYNOPSIS
    Analyzes Intune Management Extension diagnostics logs and generates reports.

.DESCRIPTION
    This script merges functionalities from two provided scripts to analyze Intune Management Extension diagnostics logs and generate detailed reports.

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

    # Save analysis results
    $analysisResults | Export-Csv -Path "$OutputPath\LogAnalysisReport.csv" -NoTypeInformation
    Write-Output "Analysis report saved to $OutputPath\LogAnalysisReport.csv"
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

    # Save PolicySet analysis results
    $policySetAnalysis | Export-Csv -Path "$OutputPath\PolicySetAnalysisReport.csv" -NoTypeInformation
    Write-Output "PolicySet analysis report saved to $OutputPath\PolicySetAnalysisReport.csv"
}

# Function to extract relevant information from diagnostics logs
function Extract-InfoFromDiagnostics {
    param (
        [string]$DiagnosticsPath
    )

    $diagnosticsFiles = Get-ChildItem -Path $DiagnosticsPath -Filter '*.zip' -Recurse

    foreach ($file in $diagnosticsFiles) {
        $extractedPath = "$DiagnosticsPath\Extracted\$($file.BaseName)"
        Expand-Archive -Path $file.FullName -DestinationPath $extractedPath -Force

        $diagContent = Get-Content -Path "$extractedPath\mdm\diagnostics.txt"
        $parsedInfo = [PSCustomObject]@{
            DeviceId = ($diagContent | Select-String -Pattern 'DeviceID').Line.Split('=')[1].Trim()
            Status = ($diagContent | Select-String -Pattern 'Status').Line.Split('=')[1].Trim()
        }

        $parsedInfo | Export-Csv -Path "$DiagnosticsPath\DiagnosticsSummary.csv" -Append -NoTypeInformation
    }
}

# Main script execution
Write-Output "Starting analysis..."
Analyze-Logs -DiagnosticsPath $DiagnosticsPath -OutputPath $OutputPath
Extract-InfoFromDiagnostics -DiagnosticsPath $DiagnosticsPath

if ($PolicySetId) {
    Analyze-PolicySet -PolicySetId $PolicySetId -OutputPath $OutputPath
}

Write-Output "Analysis completed."
