# Navigate to the CrowdStrike drivers directory
$directoryPath = "C:\Windows\System32\drivers\CrowdStrike"

# Check if the directory exists
if (Test-Path -Path $directoryPath) {
    # Get all files matching the pattern "C-00000291*.sys"
    $files = Get-ChildItem -Path $directoryPath -Filter "C-00000291*.sys"

    # Check if any files were found
    if ($files) {
        # Delete each file
        foreach ($file in $files) {
            try {
                Remove-Item -Path $file.FullName -Force
                Write-Host "Deleted file: $($file.FullName)"
            } catch {
                Write-Host "Failed to delete file: $($file.FullName) - Error: $_"
            }
        }
    } else {
        Write-Host "No files matching the pattern 'C-00000291*.sys' were found in the directory."
    }
} else {
    Write-Host "Directory $directoryPath does not exist."
}
