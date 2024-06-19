Add-Type -AssemblyName System.Windows.Forms

function Get-DateFromCalendar($title) {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = $title
    $form.Width = 250
    $form.Height = 300
    $form.StartPosition = "CenterScreen"

    $calendar = New-Object System.Windows.Forms.MonthCalendar
    $calendar.MaxSelectionCount = 1
    $calendar.Dock = "Fill"
    
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Dock = "Bottom"
    $okButton.Add_Click({
        $form.Tag = $calendar.SelectionStart
        $form.Close()
    })

    $form.Controls.Add($calendar)
    $form.Controls.Add($okButton)

    $form.ShowDialog() | Out-Null
    return $form.Tag
}

function Get-FolderPath($description) {
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = $description
    $folderBrowser.ShowNewFolderButton = $true

    $result = $folderBrowser.ShowDialog()
    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        return $folderBrowser.SelectedPath
    } else {
        Write-Host "Folder selection canceled. Exiting."
        exit
    }
}

$startDate = Get-DateFromCalendar "Select Start Date"
$endDate = Get-DateFromCalendar "Select End Date"

if ($startDate -eq $null -or $endDate -eq $null) {
    Write-Host "No dates selected. Exiting."
    exit
}

# Get the directory containing the .evtx files
$directory = Get-FolderPath "Select the folder containing the .evtx files"

# Get the output folder to save the HTML report
$outputFolder = Get-FolderPath "Select the folder to save the HTML report"

# Define the output HTML file with the current date and time
$outputFile = Join-Path -Path $outputFolder -ChildPath "event_report_$(Get-Date -Format 'yyyyMMdd_HHmmss').html"

# Initialize an array to hold the filtered events
$events = @()

# Function to parse and filter .evtx files
function Parse-EvtxFile {
    param (
        [string]$filePath
    )
    
    Write-Host "Processing file: $filePath"
    
    # Get events from the .evtx file
    $eventLogs = Get-WinEvent -Path $filePath -ErrorAction SilentlyContinue
    
    # Filter events for critical, warning, and error levels within the specified date range
    $filteredEvents = $eventLogs | Where-Object { 
        $_.LevelDisplayName -in 'Critical', 'Error', 'Warning' -and
        $_.TimeCreated -ge $startDate -and
        $_.TimeCreated -le $endDate
    } | Select-Object TimeCreated, LevelDisplayName, ProviderName, Id, Message
    
    # Add the filtered events to the global events array
    $global:events += $filteredEvents
}

# Parse all .evtx files in the specified directory
Get-ChildItem -Path $directory -Filter *.evtx | ForEach-Object {
    Parse-EvtxFile -filePath $_.FullName
}

# Identify the most probable issue (event with the highest count)
$mostFrequentEventId = $events | Group-Object -Property Id | Sort-Object -Property Count -Descending | Select-Object -First 1 | Select-Object -ExpandProperty Name

# Convert the events array to HTML
$htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Log Report</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
        }
        th {
            background-color: #f4f4f4;
        }
        .highlight {
            background-color: red;
            color: white;
        }
    </style>
</head>
<body>
    <h1>Event Log Report</h1>
    <h2>Logs from $startDate to $endDate</h2>
    <table>
        <thead>
            <tr>
                <th>Time Created</th>
                <th>Level</th>
                <th>Source</th>
                <th>Event ID</th>
                <th>Message</th>
            </tr>
        </thead>
        <tbody>
"@

# Add each event as a table row
$events | ForEach-Object {
    $rowClass = ""
    if ($_.Id -eq $mostFrequentEventId) {
        $rowClass = "class='highlight'"
    }
    $htmlContent += "<tr $rowClass>"
    $htmlContent += "<td>$($_.TimeCreated)</td>"
    $htmlContent += "<td>$($_.LevelDisplayName)</td>"
    $htmlContent += "<td>$($_.ProviderName)</td>"
    $htmlContent += "<td>$($_.Id)</td>"
    $htmlContent += "<td>$($_.Message)</td>"
    $htmlContent += "</tr>"
}

$htmlContent += @"
        </tbody>
    </table>
</body>
</html>
"@

# Output the HTML content to the specified file
Set-Content -Path $outputFile -Value $htmlContent

Write-Host "HTML report generated: $outputFile"
