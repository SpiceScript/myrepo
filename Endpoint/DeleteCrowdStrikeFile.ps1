# Prompt for BitLocker recovery key
$recoveryKey = Read-Host "Enter the BitLocker recovery key"

# Unlock the BitLocker drive
Write-Host "Attempting to unlock BitLocker drive C:..."
try {
    $unlockCommand = "manage-bde -unlock C: -RecoveryPassword $recoveryKey"
    Invoke-Expression $unlockCommand

    # Define the file path
    $filePath = "C:\Windows\System32\drivers\CrowdStrike\C-00000291*.sys"

    # Get the files that match the pattern
    $files = Get-ChildItem -Path $filePath -ErrorAction SilentlyContinue

    # Check if any files were found
    if ($files) {
        # Display the list of files to be deleted
        Write-Host "The following files will be deleted:"
        $files | ForEach-Object { Write-Host $_.FullName }

        # Remove the files
        $files | Remove-Item -Force

        Write-Host "Files deleted successfully."
    } else {
        Write-Host "No files found matching the pattern."
    }
} catch {
    Write-Host "An error occurred while unlocking the BitLocker drive or deleting files: $_"
}
