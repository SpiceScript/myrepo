# Workspace Services Strategic Roadmap Hub - Project Handoff Guide

This document serves as a complete handoff guide for **GitHub Copilot** (or any other AI assistant) to take over the development and configuration of the strategic roadmap hub.

---

## 1. Project Goal & Requirements
Build a highly premium, interactive, dual-view strategic roadmap hub for the internal **Workspace Services** vertical, which covers five key service areas:
*   **DA**: Devices & Applications (Accent: Slate/Blue)
*   **CC**: Communication & Collaboration (Accent: Teal)
*   **CS**: Colleague Services (Accent: Green)
*   **AI**: AI Enablement (Accent: Purple)
*   **EST**: EST (Accent: Orange)

### Required Key Features:
1.  **Dual Views**:
    *   **Items View**: Searchable, filterable card grid showing service areas, status badges, progress bars, and metadata.
    *   **Timeline View**: An interactive quarterly swimlane Gantt chart grouped dynamically by **Service Area** or **Strategic Objective**.
2.  **Interactive Details Drawer**:
    *   Slides out from the right when a card/item is clicked.
    *   Displays full details, Jira ticket links, decimal progress (`0.0` to `1.0`), and a simulated chronological audit history log.
3.  **Dynamic Abbreviation IDs**: Auto-generated sequential IDs (e.g. `IS-WSS-DA-1`, `IS-WSS-AI-2`) upon item creation based on selected service area.
4.  **Premium Aesthetics**: Curated harmonious HSL palettes, smooth glassmorphism header, responsive design, dark/light theme toggle, and elegant micro-animations.

---

## 2. Technical Architecture & Hosting
*   **Frontend**: Plain HTML5, custom namespaced CSS (`.roadmap-checkbox-*` to avoid collision with global Power Pages Bootstrap), and native JavaScript (ES6). No third-party frameworks to maintain maximum load speeds.
*   **Backend Database**: A SharePoint List named `WorkspaceServicesRoadmap` integrated into **Microsoft Dataverse** as a **Virtual Table**.
*   **Hosting Environment**: Hosted inside a **Microsoft Power Pages** site (`https://wssroadmap.powerappsportals.com/`) running on the **Enhanced Data Model**.
*   **Data Integration Pattern**: 
    *   Server-side **Liquid Template Language** executes a `fetchxml` query at the very top of the page.
    *   This compiles Dataverse rows into a client-side JSON array assigned to `window.POWER_PAGES_LIVE_DATA`.
    *   Our JavaScript consumes this global array. If the array is empty (or permissions block it), the JS automatically falls back to **Local Mode** with mock data to prevent a broken experience.

---

## 3. Database Schema (Dataverse Virtual Table)
*   **Virtual Table System Name**: `crcce_workspaceservicesroadmap` (Note: Might be pluralized as `crcce_workspaceservicesroadmaps`).
*   **Column Mappings**:
    *   `crcce_roadmapid`: Abbreviation ID (Text, e.g. `IS-WSS-DA-1`)
    *   `crcce_title`: Item Title (Text)
    *   `crcce_description`: Description (Multiple lines of text)
    *   `crcce_servicearea`: Service Area (Text/Choice, e.g. `Devices & Applications`, `Communication & Collaboration`, `Colleague Services`, `AI Enablement`, `EST`)
    *   `crcce_objective`: Strategic Objective (Text/Choice, e.g. `Modernize Workspace`, `Seamless Collaboration`, `Maximize Productivity`, `Security & Compliance`)
    *   `crcce_buinitiative`: Business Initiative (Text)
    *   `crcce_progress`: Progress (Decimal, `0.0` to `1.0`)
    *   `crcce_status`: Status (Text/Choice, e.g. `Development`, `Rollout`, `Launched`)
    *   `crcce_startdate`: Start Date (Date/Time, formatted as `yyyy-MM-dd`)
    *   `crcce_enddate`: End Date (Date/Time, formatted as `yyyy-MM-dd`)
    *   `crcce_subcategory`: Subcategory (Text)
    *   `crcce_jiralink`: Jira Link (Text/URL)

---

## 4. Local File Structure
All core source files are maintained locally on the user's desktop at:
`C:\Users\Prasad\Desktop\sp-roadmap\`

*   `index.html`: The core modular frontend layout.
*   `styles.css`: Strict custom stylesheet using namespaced `.roadmap-checkbox-*` selectors.
*   `app.js`: Core client-side logic with load guards, views management, search, and dynamic timeline rendering.
*   `index.aspx`: Single-file unified ASPX package (built previously for SharePoint libraries, now archived).
*   `powerpages-unified.html`: **The master single-file package** designed specifically for Power Pages. It wraps the Liquid query at the top, followed by inline CSS and JS.
*   `roadmap_project_data.md`: Detailed dataset of the initial strategic objectives and roadmap items.

---

## 5. Work Completed Till Now
1.  **Fully Coded Frontend**: Built and polished all visual features (dual-view toggle, quarterly Gantt chart, filtering by status/service area, details drawer, local/live data states).
2.  **Resolved CSS Conflicts**: Fully namespaced all custom UI controls so they don't collide with the global Bootstrap files forced by Power Pages.
3.  **Deployed to Power Pages via VS Code**:
    *   Opened the site in the **Enhanced Data Model** workspace.
    *   Launched **Visual Studio Code for the Web** (`vscode.dev`) directly from the Design Studio.
    *   Pasted the entire `powerpages-unified.html` into `web-pages > Home > Home.en-US.webpage.copy.html` and saved.

---

## 6. Pending Actions & Roadmap for Copilot
The core frontend and database code are **100% complete and deployed**. To get live data displaying instead of the mock data fallback, the following steps must be completed:

### Task 1: Enable Table Permissions in Power Pages (Critical)
Because Dataverse blocks anonymous/unauthorized access to custom tables, the Liquid query returns `0` records. You must enable access:
1.  In **Power Pages Design Studio**, select the **Security** tab (shield icon) on the left-hand toolbar.
2.  Click **Table permissions** $\rightarrow$ **+ New**.
3.  Fill out the permission:
    *   **Name**: `Roadmap Read Access`
    *   **Table**: Search and select `crcce_workspaceservicesroadmap`
    *   **Access Type**: `Global access`
    *   **Permissions**: Check **Read** (also check Write/Create if planning to add/edit items from the frontend).
    *   **Roles**: Click **+ Add web roles** and check: **Anonymous Users**, **Authenticated Users**, and **Administrators**.
4.  Save the record.

### Task 2: Double-Check System Pluralization
During Virtual Table setup, Dataverse often automatically appends an **`s`** to system names.
1.  Verify the exact system name under the **Data** tab of the Design Studio.
2.  If the table is named `crcce_workspaceservicesroadmaps` (with an **`s`**), open VS Code and change line 3:
    *   `<entity name="crcce_workspaceservicesroadmaps">`
3.  Save the file.

### Task 3: Clear Server & Browser Cache
Power Pages has aggressive caching. When making changes:
1.  Always click the **Sync** button in the top-right corner of the **Design Studio** to flush the server-side cache.
2.  Perform a **Hard Reload / Force Refresh** in your browser (**`Ctrl + F5`** or `Cmd + Shift + R`) to make sure it bypasses local browser cache.

### Task 4: Connect Add/Edit Forms to Power Pages Web API (Optional Phase 2)
Currently, the "Add Item" form runs locally on the client-side. To make it write back to the Dataverse database:
1.  Enable **Create / Write / Delete** Table Permissions in the Security tab.
2.  Activate the Web API settings for the table in **Site Settings** (e.g. `webapi.crcce_workspaceservicesroadmap.enabled = true`).
3.  Update the `saveRoadmapItem` function in the JavaScript to make an asynchronous `HTTP POST` call using Power Pages' wrapper `safeAjax` method to fetch the CSRF token (`__RequestVerificationToken`).
