### README.md

```markdown
# Event Log Report Generator

This PowerShell script parses multiple `.evtx` event log files and generates an HTML report highlighting critical, warning, and error records within a specified date range. The most frequent issue is highlighted in red in the report.

## Prerequisites

1. **PowerShell 7.x or later**: Ensure you have the latest version of PowerShell.
2. **Windows.Forms Assembly**: This script uses Windows Forms for date and folder selection dialogs.

## How to Use

### Save the Script

1. Copy the provided script and save it as a `.ps1` file. For example, `EventLogReportGenerator.ps1`.

### Open PowerShell

1. Run PowerShell with administrative privileges.

### Run the Script

1. Execute the script by typing:
   ```powershell
   .\EventLogReportGenerator.ps1
   ```

### Date Selection

1. The script will prompt you with a calendar dialog to select the **start date** for the event log analysis.
2. After selecting the start date, you will be prompted to select the **end date**.

### Folder Selection

1. You will be prompted to select the folder containing the `.evtx` files to be analyzed.
2. You will also be prompted to select the folder where the generated HTML report will be saved.

### Report Generation

1. The script processes all `.evtx` files in the selected folder and filters the events based on the selected date range.
2. An HTML report is generated, highlighting the most frequent issue in red.
3. The report is saved in the specified output folder with a filename that includes the current date and time (e.g., `event_report_20230618_123456.html`).

### Example Execution

```powershell
.\EventLogReportGenerator.ps1
```

- Select the start and end dates for the log analysis.
- Choose the folder containing the `.evtx` files.
- Choose the folder where the HTML report will be saved.
- The script will generate an HTML report and save it in the specified output folder.

## Notes

- Ensure that you have the necessary permissions to read the `.evtx` files and write to the output folder.
- The script requires the `System.Windows.Forms` assembly to be available for the date and folder selection dialogs.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
```

Place this content in a file named `README.md` in the root directory of your GitHub repository. This will provide users with clear instructions on how to use the script.
