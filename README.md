# Bitwarden Password Analyzer

## Overview
This tool is a web-based **Bitwarden Password Analyzer** that helps users identify and remove duplicate logins from their **Bitwarden vault export**. It is built using **HTML and JavaScript**, eliminating the need for external dependencies or backend processing.

## Features
- **Find duplicate logins** based on **domain, username, and password**.
- **Keep different usernames** even if the domain and password match.
- **Interactive UI** to review and delete duplicate entries.
- **Download updated JSON export** after removing duplicates.
- **Statistics tracking** (total entries, duplicates found, deleted entries, and remaining entries).

## How to Use
### **Step 1: Export Your Bitwarden Vault**
1. Log in to your Bitwarden account.
2. Navigate to **Tools → Export Vault**.
3. Select the **.json file format** (DO NOT use the encrypted export).
4. Save the exported JSON file to your computer.

### **Step 2: Open and Analyze Data**
1. **Download** the `index.html` file.
2. Open it in your **preferred web browser**.
3. Click **"Choose File"** and select your Bitwarden JSON export.
4. The tool will process and display your stored logins.

### **Step 3: Remove Duplicate Entries**
1. Click **"Delete Duplicates"** to remove duplicate entries while keeping unique usernames.
2. Review your entries using the interactive UI.

### **Step 4: Download Updated Export**
1. Click **"Download Updated Export"** to save a cleaned version of your vault.
2. The JSON file will be saved locally with duplicates removed.

### **Step 5: Import Cleaned Vault into Bitwarden**
1. **Delete your existing vault** (if necessary) under **Settings → My Account → Empty Vault** (be cautious, this action is irreversible!).
2. Navigate to **Tools → Import Data → Bitwarden (JSON)**.
3. Upload your cleaned JSON file.

## Important Notes
- **Security Reminder:** JSON export files contain **unencrypted passwords**. Always handle them carefully and **delete them securely** after use.
- **Backup Your Vault:** Before making changes, ensure you have at least one **backup copy** of your vault.
- **Repeatable Process:** You can **re-upload** your updated JSON export to remove additional duplicates.

## Running the Tool via GitHub Pages
Alternatively, you can run the hosted version of this tool:
1. Export your Bitwarden vault as JSON (Step 1 above).
2. Open **[GitHub Pages Hosted Version](https:///)**.
3. Follow **Steps 3-5** as described above.

## Disclaimer
This tool is an **offline utility** that does not transmit data. However, always review scripts and files before use, as you are handling sensitive data. **Use at your own risk.**

