# Walkthrough: Workspace Services Roadmap & Strategy Hub

This document provides a guide to previewing the generated roadmap locally on your laptop, followed by step-by-step instructions to deploy it to your production **SharePoint Online** environment.

---

## 1. Files Generated

The following files have been generated in your workspace directory:
*   📁 **Folder**: `C:\Users\Prasad\ .gemini\antigravity\scratch\sp-roadmap\`
    *   📄 [index.html](file:///C:/Users/Prasad/.gemini/antigravity/scratch/sp-roadmap/index.html): Layout structures, search widgets, filters, details drawer, and add item modal.
    *   📄 [styles.css](file:///C:/Users/Prasad/.gemini/antigravity/scratch/sp-roadmap/styles.css): Premium UI styling, light/dark themes, Gantt timeline layouts, and service line colors.
    *   📄 [app.js](file:///C:/Users/Prasad/.gemini/antigravity/scratch/sp-roadmap/app.js): Dynamic mock database, OData API integration service, filtering controllers, and version diff generators.

---

## 2. How to Preview Locally Right Now

You do not need SharePoint or any servers to test this code.
1. Open your file explorer and navigate to `C:\Users\Prasad\.gemini\antigravity\scratch\sp-roadmap\`.
2. **Double-click on `index.html`** (or right-click $\rightarrow$ *Open with* and choose **Google Chrome** or **Microsoft Edge**).
3. **Interactive Features to Try**:
   *   **Toggle Tabs**: Switch between **Items (List)** and **Timeline View**.
   *   **Gantt Groupings**: In the Timeline View, click the radio button to toggle between **Group Swimlanes By: Service Area** or **Strategic Objective**.
   *   **Search**: Type `Copilot` or `Windows` in the search bar.
   *   **Checklist Filters**: Toggle checkboxes in the sidebar (e.g., check `AI Enablement` to view only AI deliverables).
   *   **Detail Drawer**: Click on any card (in List view) or horizontal bar (in Timeline view) to slide open the detail drawer. Read the **Change History Timeline** illustrating dates shifting and progress updates.
   *   **Add Mock Deliverables**: Click the **Add Item** button at the top-right, fill out the form, and save. The app will immediately generate a custom Roadmap ID (e.g. `IS-WSS-AI-3`) and insert it into both views dynamically.
   *   **Dark Mode**: Click the Sun/Moon icon in the top-right corner to toggle between a clean Light Mode and a premium Slate Dark Mode.

---

## 3. Production Deployment to SharePoint

Follow these 3 simple phases to move the local code into your SharePoint workspace.

### Phase 1: Create the SharePoint List Backend

1. Navigate to your corporate SharePoint site where you want the roadmap database to reside.
2. Click **New** $\rightarrow$ **List** $\rightarrow$ Select **Blank List**. Name it: `WorkspaceServicesRoadmap`.
3. Create the following columns in the list:

| Column Display Name | Type | Notes / Configuration |
| :--- | :--- | :--- |
| **Title** | Single line of text | *(Created by default, rename/keep as Title)* |
| **Description** | Multiple lines of text | Rich text or Plain text |
| **ServiceArea** | Choice | Add options: `Devices and Applications`, `Communication and Collaboration`, `Colleague Services`, `AI Enablement`, `EST` |
| **Objective** | Single line of text | Title of strategic objective |
| **BUInitiative** | Single line of text | Title of the parent initiative |
| **Progress** | Number | Set decimal places to `2` (Min value: `0.0`, Max value: `1.0`) |
| **Status** | Choice | Add options: `In Development`, `Rolling Out`, `Launched` |
| **StartDate** | Date and Time | Date Only format |
| **EndDate** | Date and Time | Date Only format |
| **SubCategory** | Single line of text | Owner or lead name |
| **RoadmapID** | Single line of text | *(Leave empty on manual entry, filled automatically)* |
| **JiraLink** | Single line of text / Hyperlink | URL to the related Jira issue |

> [!IMPORTANT]
> **Enable Versioning**:
> Go to **List Settings** $\rightarrow$ **Versioning settings** $\rightarrow$ Ensure *"Create a version each time you edit an item in this list"* is set to **Yes**. This is required to power the Change History Timeline in the UI drawer.

---

### Phase 2: Upload and Embed the Frontend

1. **Upload Files to SharePoint**:
   * Navigate to your SharePoint site's **Site Assets** document library (or create a standard Document Library folder named `Roadmap`).
   * Upload `index.html`, `styles.css`, and `app.js` into this folder. Keep them in the same directory level.
2. **Get the URL of index.html**:
   * Click the three dots next to the uploaded `index.html` $\rightarrow$ Click **Details** or **Copy link**.
   * Copy the direct URL. It should look like: `https://yourdomain.sharepoint.com/sites/WorkspaceServices/SiteAssets/Roadmap/index.html`.
3. **Embed the Roadmap on a Modern SharePoint Page**:
   * Create a new modern page in SharePoint.
   * Add a new section (Single Column layout is recommended for full screen width).
   * Hover inside the section and click the `+` to add a new web part $\rightarrow$ Select **Embed**.
   * Paste an iframe snippet into the embed code box, using the URL you copied:
     ```html
     <iframe src="https://yourdomain.sharepoint.com/sites/WorkspaceServices/SiteAssets/Roadmap/index.html" width="100%" height="800px" style="border: 0; border-radius: 8px;"></iframe>
     ```
   * Save and **Publish** the page.

*Note: The frontend code automatically detects it is inside SharePoint, disables the local mock data, and connects directly to the SharePoint list.*

---

### Phase 3: Setup Power Automate flow for RoadmapID generation

To automate the Roadmap IDs (e.g. `IS-WSS-DA-5`), set up a simple automated cloud flow in Power Automate:

1. **Trigger**: *When an item is created* (point it to your site and the `WorkspaceServicesRoadmap` list).
2. **Action: Get Items (OData filter)**:
   * Filter query: `ServiceArea eq '@{triggerOutputs()?['body/ServiceArea/Value']}'`
   * This retrieves all existing items under that specific service area.
3. **Action: Compose (Increment Count)**:
   * Expression to get the next counter index: `add(length(outputs('Get_items')?['body/value']), 1)`
4. **Action: Compose (Abbreviation map)**:
   * Use an expression or conditional block to determine the abbreviation (e.g., if AI Enablement $\rightarrow$ `AI`, if EST $\rightarrow$ `EST`).
5. **Action: Update Item**:
   * Reference the ID from the Trigger step.
   * Set `RoadmapID` column value to: `IS-WSS-[Abbrev]-[ComposeIncrementCount]`.
