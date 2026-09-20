# Project Repository

A structured collection of administration tools, endpoint scripts, cloud deployment utilities, and platform guides.

---

## Folder Structure & Overview

### 📁 [`Bitwarden-Password-Analyzer/`](./Bitwarden-Password-Analyzer/)
- **Description:** A client-side web utility to analyze, detect, and clean duplicate logins from exported Bitwarden vaults.
- **Key Files:**
  - `index.html` — The interactive tool UI and analysis engine.
  - `README.md` — Usage instructions, security notes, and steps for importing/exporting vault data.

### 📁 [`Endpoint/`](./Endpoint/)
- **Description:** Scripts and documentation for Windows endpoint administration, incident response, CIS benchmark compliance, and event log forensics.
- **Key Files:**
  - `CS_BSOD.ps1` — CrowdStrike blue screen remediation automation.
  - `EventLogAnalyser.ps1` / `EventLogAnalyser.md` — Event viewer log parsing and analysis tool.
  - `cis.py` — CIS benchmark evaluation script.
  - `Readme.md` & `walkthrough.md` — Operational documentation and setup instructions.

### 📁 [`Hostinger/`](./Hostinger/)
- **Description:** Server management guides and database migration runbooks for Hostinger infrastructure.
- **Key Files:**
  - `hostinger_db_import_guide.md` — Step-by-step database import, command line setup, and troubleshooting guide.

### 📁 [`Intune/`](./Intune/)
- **Description:** Microsoft Intune management scripts, policy exporters, diagnostic scripts, and group assignment automation.
- **Key Files:**
  - `Export_Config_Profiles.ps1` — Export device configuration profiles.
  - `GroupAssignments.ps1` / `GroupAssignments.md` — Group membership and assignment automation.
  - `GroupDetails.ps1` — Detailed Entra/Intune group audit script.
  - `IntuneDiag.ps1` — Device enrollment and policy sync diagnostics.
  - `Policy_Set_export.ps1` — Policy set backup and JSON export.
  - `RemoveTeams` — Teams app removal package script.
  - `User_Dept_MCode.txt` & `test.ps1` — Supporting data and testing utilities.

### 📁 [`WordPress/`](./WordPress/)
- **Description:** WordPress plugins, performance optimizations, theme customizations, and site configuration scripts.
