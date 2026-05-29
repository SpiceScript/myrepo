/**
 * Workspace Services Roadmap & Strategy Hub
 * Core Application Logic & Data Service Wrapper
 */

// ==========================================================================
// 1. Initial Mock Database
// ==========================================================================
let ROADMAP_ITEMS = [
    {
        Id: 1,
        RoadmapID: "IS-WSS-DA-1",
        Title: "Windows 11 Enterprise Standard Rollout",
        Description: "Upgrade and deploy Windows 11 Enterprise standard client image across all global corporate endpoints, improving security configurations and boot times.",
        ServiceArea: "Devices and Applications",
        Objective: "Establish modern, secure, and performant client computing platforms",
        BUInitiative: "Global Workspace Modernization 2026",
        Progress: 0.65,
        Status: "Rolling Out",
        StartDate: "2026-07-01",
        EndDate: "2026-11-15",
        SubCategory: "Omar",
        IsMilestone: false,
        JiraLink: "https://jira.workspace-services.net/browse/DEX-411",
        VersionHistory: [
            { version: 3, date: "2026-05-28", author: "John Doe", change: "Updated Progress from <span class='history-diff-highlight'>0.50</span> to <span class='history-diff-highlight'>0.65</span>" },
            { version: 2, date: "2026-05-15", author: "Alice Smith", change: "Shifted End Date from Q3 (<span class='history-diff-highlight'>2026-09-30</span>) to Q4 (<span class='history-diff-highlight'>2026-11-15</span>) due to hardware supply chain delays." },
            { version: 1, date: "2026-04-10", author: "John Doe", change: "Changed Status from 'In Development' to <span class='history-diff-highlight'>'Rolling Out'</span> after pilot group clearance." }
        ]
    },
    {
        Id: 2,
        RoadmapID: "IS-WSS-DA-2",
        Title: "Automated Self-Service Software provisioning portal",
        Description: "Deploy automated SCCM/Intune packaging pipelines to allow corporate users to download approved software without raising manual IT tickets.",
        ServiceArea: "Devices and Applications",
        Objective: "Empower employee autonomy through self-service tooling",
        BUInitiative: "Digital Employee Experience (DEX) Transformation",
        Progress: 0.30,
        Status: "In Development",
        StartDate: "2026-10-01",
        EndDate: "2027-02-15",
        SubCategory: "Jamie",
        IsMilestone: false,
        JiraLink: "https://jira.workspace-services.net/browse/DEX-412",
        VersionHistory: [
            { version: 2, date: "2026-05-20", author: "Jamie Vance", change: "Updated Progress from <span class='history-diff-highlight'>0.15</span> to <span class='history-diff-highlight'>0.30</span>" },
            { version: 1, date: "2026-05-01", author: "Omar K.", change: "Initial deliverable added to the roadmap." }
        ]
    },
    {
        Id: 3,
        RoadmapID: "IS-WSS-CC-1",
        Title: "Teams Voice Phone Integration & Desk Phone Retirement",
        Description: "Migrate legacy physical VoIP PBX desk phones to MS Teams Voice Softphones, deploying SIP gateways for critical lines and training users.",
        ServiceArea: "Communication and Collaboration",
        Objective: "Retire legacy physical communication infrastructure",
        BUInitiative: "Global Workspace Modernization 2026",
        Progress: 0.80,
        Status: "Rolling Out",
        StartDate: "2026-07-01",
        EndDate: "2026-12-31",
        SubCategory: "Farah",
        IsMilestone: false,
        JiraLink: "https://jira.workspace-services.net/browse/DEX-520",
        VersionHistory: [
            { version: 2, date: "2026-05-25", author: "Farah Shah", change: "Updated Progress from <span class='history-diff-highlight'>0.70</span> to <span class='history-diff-highlight'>0.80</span>" },
            { version: 1, date: "2026-04-01", author: "Farah Shah", change: "Status updated to 'Rolling Out' on commencement of region phase 2." }
        ]
    },
    {
        Id: 4,
        RoadmapID: "IS-WSS-CC-2",
        Title: "Outlook Copilot Templates & Adoption Wave",
        Description: "Integrate custom organizational prompt templates into Microsoft Outlook, enabling quick standard drafting and automated meeting followups.",
        ServiceArea: "Communication and Collaboration",
        Objective: "Boost workspace communication speeds via AI integrations",
        BUInitiative: "Enterprise AI Enablement Plan",
        Progress: 1.00,
        Status: "Launched",
        StartDate: "2026-04-01",
        EndDate: "2026-07-15",
        SubCategory: "Omar",
        IsMilestone: false,
        JiraLink: "https://jira.workspace-services.net/browse/AI-901",
        VersionHistory: [
            { version: 3, date: "2026-05-29", author: "Omar K.", change: "Marked progress as <span class='history-diff-highlight'>1.00 (Completed)</span> and status as <span class='history-diff-highlight'>Launched</span>" },
            { version: 2, date: "2026-05-10", author: "Farah Shah", change: "Updated Progress from <span class='history-diff-highlight'>0.85</span> to <span class='history-diff-highlight'>0.95</span>" },
            { version: 1, date: "2026-04-15", author: "Omar K.", change: "Deliverable approved and initial development started." }
        ]
    },
    {
        Id: 5,
        RoadmapID: "IS-WSS-CS-1",
        Title: "Next-Gen Colleague Support Ticket Portal",
        Description: "Consolidate separate corporate helpdesks (IT, HR, Facilities) into a single virtual support hub with automated intelligent dispatch routing.",
        ServiceArea: "Colleague Services",
        Objective: "Consolidate corporate request queues to reduce SLA friction",
        BUInitiative: "Digital Employee Experience (DEX) Transformation",
        Progress: 0.45,
        Status: "In Development",
        StartDate: "2026-08-15",
        EndDate: "2026-12-15",
        SubCategory: "Maria",
        IsMilestone: false,
        JiraLink: "https://jira.workspace-services.net/browse/DEX-304",
        VersionHistory: [
            { version: 2, date: "2026-05-22", author: "Maria Lopez", change: "Updated Progress from <span class='history-diff-highlight'>0.35</span> to <span class='history-diff-highlight'>0.45</span>" },
            { version: 1, date: "2026-05-05", author: "Alex Mercer", change: "Initial mock design draft added." }
        ]
    },
    {
        Id: 6,
        RoadmapID: "IS-WSS-AI-1",
        Title: "M365 Copilot Enterprise Adoption & Enablement",
        Description: "Deploy standard M365 Copilot licensing to 10,000 corporate users, establishing internal learning paths, feedback forums, and compliance baselines.",
        ServiceArea: "AI Enablement",
        Objective: "Accelerate user productivity via generative AI integrations",
        BUInitiative: "Enterprise AI Enablement Plan",
        Progress: 1.00,
        Status: "Launched",
        StartDate: "2026-05-01",
        EndDate: "2026-08-30",
        SubCategory: "Alex",
        IsMilestone: false,
        JiraLink: "https://jira.workspace-services.net/browse/AI-101",
        VersionHistory: [
            { version: 2, date: "2026-05-28", author: "Alex Mercer", change: "Marked as <span class='history-diff-highlight'>1.0 (Launched)</span> after successful pilot validation." },
            { version: 1, date: "2026-05-01", author: "John Doe", change: "Initial launch rollout." }
        ]
    },
    {
        Id: 7,
        RoadmapID: "IS-WSS-AI-2",
        Title: "Custom AI Dev Coding Assistants (GitHub Copilot Teams)",
        Description: "Provide secure coding assistant licenses to all engineering groups with configured enterprise security guardrails and intellectual property filters.",
        ServiceArea: "AI Enablement",
        Objective: "Improve software build times and coding compliance",
        BUInitiative: "Enterprise AI Enablement Plan",
        Progress: 0.20,
        Status: "In Development",
        StartDate: "2026-11-01",
        EndDate: "2027-03-31",
        SubCategory: "Omar",
        IsMilestone: false,
        JiraLink: "",
        VersionHistory: [
            { version: 1, date: "2026-05-18", author: "Alex Mercer", change: "Approved design specification and allocated licensing budgets." }
        ]
    },
    {
        Id: 8,
        RoadmapID: "IS-WSS-EST-1",
        Title: "Intelligent Network Edge SD-WAN Routing",
        Description: "Implement secure software-defined routing protocols across external regional sites, routing cloud traffic directly and bypassing central hubs.",
        ServiceArea: "EST",
        Objective: "Optimize and secure enterprise cloud network traffic",
        BUInitiative: "Security and Cloud Infrastructure Base",
        Progress: 0.15,
        Status: "In Development",
        StartDate: "2026-10-15",
        EndDate: "2027-04-30",
        SubCategory: "Carly",
        IsMilestone: false,
        JiraLink: "https://jira.workspace-services.net/browse/EST-22",
        VersionHistory: [
            { version: 1, date: "2026-05-20", author: "Carly Vance", change: "Deliverable registered for the FY27 network consolidation project." }
        ]
    }
];

// Service Area Abbreviations for Dynamic ID generation
const SERVICE_ABBREVIATIONS = {
    "Devices and Applications": "DA",
    "Communication and Collaboration": "CC",
    "Colleague Services": "CS",
    "AI Enablement": "AI",
    "EST": "EST"
};

// ==========================================================================
// 2. Global State Variables
// ==========================================================================
let currentView = 'list';
let timelineGroup = 'service';
let activeFilters = {
    service: [],
    initiative: [],
    status: []
};
let searchTerm = '';

// Define Timeline Range: 1 Full Year (4 Quarters)
// Q3 2026, Q4 2026, Q1 2027, Q2 2027
const TIMELINE_START = new Date("2026-07-01");
const TIMELINE_END = new Date("2027-06-30");
const TOTAL_TIMELINE_DAYS = (TIMELINE_END - TIMELINE_START) / (1000 * 60 * 60 * 24);

// ==========================================================================
// 3. Environment Detection & Data Service
// ==========================================================================
const isSharePoint = typeof _spPageContextInfo !== 'undefined' || window.location.href.indexOf('/sites/') > -1;

function fetchRoadmapData() {
    return new Promise((resolve, reject) => {
        // A. Check if running inside Microsoft Power Pages with Liquid data bridge active
        if (window.POWER_PAGES_LIVE_DATA && window.POWER_PAGES_LIVE_DATA.length > 0) {
            console.log("Running in POWER PAGES MODE. Live SharePoint data loaded successfully via Liquid bridge.");
            resolve(window.POWER_PAGES_LIVE_DATA);
            return;
        }

        // B. Check if running inside SharePoint Online
        if (!isSharePoint) {
            console.log("Running in LOCAL MODE. Fetching mock records...");
            resolve(ROADMAP_ITEMS);
            return;
        }

        console.log("Running in SHAREPOINT MODE. Querying SharePoint REST API...");
        const siteUrl = _spPageContextInfo.webAbsoluteUrl;
        // Query details and version history triggers
        const endPoint = `${siteUrl}/_api/web/lists/getbytitle('WorkspaceServicesRoadmap')/items?$select=Id,Title,Description,ServiceArea,Objective,BUInitiative,Progress,Status,StartDate,EndDate,RoadmapID,SubCategory,JiraLink`;
        
        fetch(endPoint, {
            headers: {
                "Accept": "application/json; odata=verbose"
            }
        })
        .then(response => response.json())
        .then(data => {
            const rawItems = data.d.results;
            const mappedItems = rawItems.map(item => ({
                Id: item.Id,
                RoadmapID: item.RoadmapID || `IS-WSS-UNASSIGNED-${item.Id}`,
                Title: item.Title,
                Description: item.Description || "",
                ServiceArea: item.ServiceArea || "EST",
                Objective: item.Objective || "Uncategorized Objective",
                BUInitiative: item.BUInitiative || "Uncategorized Initiative",
                Progress: parseFloat(item.Progress) || 0.0,
                Status: item.Status || "In Development",
                StartDate: item.StartDate ? item.StartDate.split('T')[0] : "2026-07-01",
                EndDate: item.EndDate ? item.EndDate.split('T')[0] : "2026-10-31",
                SubCategory: item.SubCategory || "Unassigned",
                IsMilestone: false,
                JiraLink: item.JiraLink || "",
                VersionHistory: [] // Handled via click query
            }));
            resolve(mappedItems);
        })
        .catch(err => {
            console.error("SharePoint REST API query failed, falling back to mock data:", err);
            resolve(ROADMAP_ITEMS);
        });
    });
}

// Fetch version details dynamically on card expansion
function fetchItemHistory(item) {
    return new Promise((resolve) => {
        if (!isSharePoint) {
            resolve(item.VersionHistory || []);
            return;
        }

        const siteUrl = _spPageContextInfo.webAbsoluteUrl;
        const endPoint = `${siteUrl}/_api/web/lists/getbytitle('WorkspaceServicesRoadmap')/items(${item.Id})/versions`;

        fetch(endPoint, {
            headers: {
                "Accept": "application/json; odata=verbose"
            }
        })
        .then(response => response.json())
        .then(data => {
            const versions = data.d.results;
            if (!versions || versions.length === 0) {
                resolve([]);
                return;
            }

            // Diffs fields between adjacent records to create dynamic human-readable logs
            const historyLogs = [];
            for (let i = 0; i < Math.min(versions.length, 10); i++) {
                const currentVer = versions[i];
                const nextVer = versions[i + 1]; // Older version is at higher index

                let changes = [];
                if (nextVer) {
                    if (currentVer.Title !== nextVer.Title) changes.push(`Renamed title`);
                    if (currentVer.Progress !== nextVer.Progress) {
                        changes.push(`Updated Progress from <span class='history-diff-highlight'>${parseFloat(nextVer.Progress || 0.0).toFixed(2)}</span> to <span class='history-diff-highlight'>${parseFloat(currentVer.Progress || 0.0).toFixed(2)}</span>`);
                    }
                    if (currentVer.Status !== nextVer.Status) {
                        changes.push(`Changed Status from '${nextVer.Status}' to <span class='history-diff-highlight'>'${currentVer.Status}'</span>`);
                    }
                    if (currentVer.StartDate !== nextVer.StartDate || currentVer.EndDate !== nextVer.EndDate) {
                        changes.push(`Shifted timeline dates`);
                    }
                } else {
                    changes.push(`Initial deliverable registered in roadmap.`);
                }

                if (changes.length > 0) {
                    const modDate = new Date(currentVer.Created).toLocaleDateString();
                    historyLogs.push({
                        version: currentVer.VersionLabel,
                        date: modDate,
                        author: currentVer.Editor.LookupValue || "System User",
                        change: changes.join(", ")
                    });
                }
            }
            resolve(historyLogs);
        })
        .catch(err => {
            console.error("Failed to query SharePoint item version log:", err);
            resolve(item.VersionHistory || []);
        });
    });
}

// Post New Item (Add form logic)
function saveRoadmapItem(newItem) {
    return new Promise((resolve, reject) => {
        // Dynamic ID generator inside Local / Power Pages Mode
        const dbSource = (window.POWER_PAGES_LIVE_DATA && window.POWER_PAGES_LIVE_DATA.length > 0) ? window.POWER_PAGES_LIVE_DATA : ROADMAP_ITEMS;
        const categoryItems = dbSource.filter(item => item.ServiceArea === newItem.ServiceArea);
        const count = categoryItems.length + 1;
        const abbrev = SERVICE_ABBREVIATIONS[newItem.ServiceArea] || "WSS";
        newItem.RoadmapID = `IS-WSS-${abbrev}-${count}`;
        newItem.Id = dbSource.length + 1;
        newItem.VersionHistory = [
            { version: 1, date: new Date().toISOString().split('T')[0], author: "Local User", change: "Initial deliverable added to roadmap." }
        ];

        if (window.POWER_PAGES_LIVE_DATA && window.POWER_PAGES_LIVE_DATA.length > 0) {
            window.POWER_PAGES_LIVE_DATA.push(newItem);
            console.log("Saved in Power Pages (Local Memory):", newItem);
            resolve(newItem);
            return;
        }

        if (!isSharePoint) {
            ROADMAP_ITEMS.push(newItem);
            console.log("Saved locally:", newItem);
            resolve(newItem);
            return;
        }

        // SharePoint OData post payload
        const siteUrl = _spPageContextInfo.webAbsoluteUrl;
        const endPoint = `${siteUrl}/_api/web/lists/getbytitle('WorkspaceServicesRoadmap')/items`;

        // Retrieve form digest for security
        fetch(`${siteUrl}/_api/contextinfo`, {
            method: "POST",
            headers: { "Accept": "application/json; odata=verbose" }
        })
        .then(res => res.json())
        .then(contextData => {
            const formDigestValue = contextData.d.GetContextWebInformation.FormDigestValue;
            
            return fetch(endPoint, {
                method: "POST",
                body: JSON.stringify({
                    __metadata: { type: "SP.Data.WorkspaceServicesRoadmapListItem" },
                    Title: newItem.Title,
                    Description: newItem.Description,
                    ServiceArea: newItem.ServiceArea,
                    Objective: newItem.Objective,
                    BUInitiative: newItem.BUInitiative,
                    Progress: newItem.Progress.toString(),
                    Status: newItem.Status,
                    StartDate: newItem.StartDate + "T08:00:00Z",
                    EndDate: newItem.EndDate + "T17:00:00Z",
                    SubCategory: newItem.SubCategory,
                    RoadmapID: newItem.RoadmapID, // The Power Automate flow can overwrite this in SharePoint, or we set it directly.
                    JiraLink: newItem.JiraLink
                }),
                headers: {
                    "Accept": "application/json; odata=verbose",
                    "Content-Type": "application/json; odata=verbose",
                    "X-RequestDigest": formDigestValue
                }
            });
        })
        .then(res => res.json())
        .then(data => {
            console.log("Saved successfully to SharePoint list:", data);
            resolve(data.d);
        })
        .catch(err => {
            console.error("SharePoint POST operation failed:", err);
            // Fallback to local save to prevent crash
            ROADMAP_ITEMS.push(newItem);
            resolve(newItem);
        });
    });
}

// ==========================================================================
// 4. Core Render Functions
// ==========================================================================

// Get Filtered Deliverables
function getFilteredItems() {
    return ROADMAP_ITEMS.filter(item => {
        // Keyword Search Matching
        const query = searchTerm.toLowerCase();
        const matchesSearch = !query || 
            item.RoadmapID.toLowerCase().includes(query) ||
            item.Title.toLowerCase().includes(query) ||
            item.Description.toLowerCase().includes(query) ||
            item.Objective.toLowerCase().includes(query) ||
            item.BUInitiative.toLowerCase().includes(query);

        // Sidebar Multi-Select Checklist Filter Matching
        const matchesService = activeFilters.service.length === 0 || 
            activeFilters.service.includes(item.ServiceArea);
            
        const matchesInitiative = activeFilters.initiative.length === 0 || 
            activeFilters.initiative.includes(item.BUInitiative);
            
        const matchesStatus = activeFilters.status.length === 0 || 
            activeFilters.status.includes(item.Status);

        return matchesSearch && matchesService && matchesInitiative && matchesStatus;
    });
}

// Render Header Stats Counter
function renderStats(visibleCount) {
    document.getElementById("visible-count").innerText = visibleCount;
    document.getElementById("total-count").innerText = ROADMAP_ITEMS.length;
}

// Renders M365 List View Grid
function renderListView() {
    const listContainer = document.getElementById("roadmap-cards-grid");
    listContainer.innerHTML = "";
    
    const items = getFilteredItems();
    renderStats(items.length);

    if (items.length === 0) {
        listContainer.innerHTML = `
            <div class="empty-state">
                <h3>No deliverables match your filter selections.</h3>
                <p>Try searching for other terms or resetting filters in the sidebar.</p>
            </div>
        `;
        return;
    }

    items.forEach(item => {
        const card = document.createElement("div");
        card.className = "roadmap-card";
        
        // Define Custom CSS Variables based on service area
        const colorVar = `--accent-${getAbbreviationLower(item.ServiceArea)}`;
        const bgVar = `--accent-${getAbbreviationLower(item.ServiceArea)}-bg`;
        card.style.setProperty("--service-color", `var(${colorVar})`);
        card.style.setProperty("--service-bg-color", `var(${bgVar})`);

        const progressPercent = Math.min(Math.max(item.Progress * 100, 0), 100);

        let jiraBadgeHTML = "";
        if (item.JiraLink) {
            jiraBadgeHTML = `
                <a href="${item.JiraLink}" target="_blank" class="card-jira-badge" title="Open Jira Ticket" onclick="event.stopPropagation();">
                    <svg viewBox="0 0 24 24" width="12" height="12"><path fill="currentColor" d="M11.57 2.15a.5.5 0 00-.73 0L2.14 11a.5.5 0 000 .72l3.41 3.41a.5.5 0 00.73 0l8.71-8.72a.5.5 0 000-.73zM17.58 8.16a.5.5 0 00-.73 0l-3.41 3.41a.5.5 0 000 .72l8.72 8.72a.5.5 0 00.72 0l3.42-3.42a.5.5 0 000-.72zM5.56 8.16a.5.5 0 00-.72 0L1.42 11.58a.5.5 0 000 .72l8.72 8.72a.5.5 0 00.73 0l3.41-3.41a.5.5 0 000-.73zM11.57 14.17a.5.5 0 00-.73 0l-3.41 3.41a.5.5 0 000 .72l8.72 8.72a.5.5 0 00.72 0l3.42-3.42a.5.5 0 000-.72z"/></svg>
                    <span>${getJiraKey(item.JiraLink)}</span>
                </a>
            `;
        }

        card.innerHTML = `
            <div class="card-strategy-path">
                <span class="strategy-initiative">📌 ${item.BUInitiative}</span>
                <span class="strategy-objective">🎯 ${item.Objective}</span>
            </div>
            <div class="card-header-info">
                <span class="card-id">${item.RoadmapID}</span>
                <div style="display: flex; gap: 0.5rem; align-items: center;">
                    ${jiraBadgeHTML}
                    <span class="card-status-badge ${getStatusBadgeClass(item.Status)}">${item.Status}</span>
                </div>
            </div>
            <h3>${item.Title}</h3>
            <p class="card-description">${item.Description}</p>
            
            <div class="card-progress-section">
                <div class="progress-header-info">
                    <span class="progress-label">Progress Scale</span>
                    <span class="progress-value">${item.Progress.toFixed(2)} (${Math.round(progressPercent)}%)</span>
                </div>
                <div class="progress-bar-track">
                    <div class="progress-bar-fill" style="width: ${progressPercent}%;"></div>
                </div>
            </div>

            <div class="card-footer-meta">
                <div class="meta-dates">
                    <span><span class="meta-date-label">Start:</span> ${formatQuarter(item.StartDate)}</span>
                    <span><span class="meta-date-label">Target:</span> ${formatQuarter(item.EndDate)}</span>
                </div>
                <span class="meta-service-tag">${item.ServiceArea}</span>
            </div>
        `;

        card.addEventListener("click", () => openDetailDrawer(item));
        listContainer.appendChild(card);
    });
}

// Renders the Timeline Board (Quarterly Swimlanes)
function renderTimelineView() {
    const board = document.getElementById("timeline-board");
    board.innerHTML = "";

    const items = getFilteredItems();
    renderStats(items.length);

    // 1. Render Quarters Grid Columns Header
    const headerRow = document.createElement("div");
    headerRow.className = "timeline-quarters-header";
    headerRow.innerHTML = `
        <div class="quarter-column-title">Swimlanes</div>
        <div class="quarter-column-title">Q3 2026</div>
        <div class="quarter-column-title">Q4 2026</div>
        <div class="quarter-column-title">Q1 2027</div>
        <div class="quarter-column-title">Q2 2027</div>
    `;
    board.appendChild(headerRow);

    // 2. Group and Render Swimlanes
    let groupedData = {};

    if (timelineGroup === 'service') {
        // Group by Service Area (e.g. AI Enablement), then by Owner (SubCategory)
        items.forEach(item => {
            if (!groupedData[item.ServiceArea]) {
                groupedData[item.ServiceArea] = {};
            }
            const subKey = item.SubCategory || "General";
            if (!groupedData[item.ServiceArea][subKey]) {
                groupedData[item.ServiceArea][subKey] = [];
            }
            groupedData[item.ServiceArea][subKey].push(item);
        });
        
        // Render rows
        for (const [service, subGroups] of Object.entries(groupedData)) {
            const groupWrapper = document.createElement("div");
            groupWrapper.className = "swimlane-row-group";
            
            // Header Row of the Service Group
            const groupHeader = document.createElement("div");
            groupHeader.className = "swimlane-group-header";
            groupHeader.innerText = service;
            groupWrapper.appendChild(groupHeader);

            // Sub-rows representing team owners
            for (const [owner, deliverables] of Object.entries(subGroups)) {
                const subRow = createTimelineRow(owner, deliverables, service);
                groupWrapper.appendChild(subRow);
            }
            board.appendChild(groupWrapper);
        }
    } else {
        // Group by Strategic Objective, then by Service Area
        items.forEach(item => {
            if (!groupedData[item.Objective]) {
                groupedData[item.Objective] = {};
            }
            const subKey = item.ServiceArea || "General";
            if (!groupedData[item.Objective][subKey]) {
                groupedData[item.Objective][subKey] = [];
            }
            groupedData[item.Objective][subKey].push(item);
        });

        // Render rows
        for (const [objective, subGroups] of Object.entries(groupedData)) {
            const groupWrapper = document.createElement("div");
            groupWrapper.className = "swimlane-row-group";
            
            const groupHeader = document.createElement("div");
            groupHeader.className = "swimlane-group-header";
            groupHeader.innerText = `🎯 Objective: ${objective}`;
            groupWrapper.appendChild(groupHeader);

            for (const [service, deliverables] of Object.entries(subGroups)) {
                const subRow = createTimelineRow(service, deliverables, service);
                groupWrapper.appendChild(subRow);
            }
            board.appendChild(groupWrapper);
        }
    }
}

// Create timeline rows and absolutely position horizontal bars
function createTimelineRow(label, deliverables, serviceLine) {
    const row = document.createElement("div");
    row.className = "swimlane-sub-row";

    const labelDiv = document.createElement("div");
    labelDiv.className = "swimlane-row-label";
    labelDiv.innerText = label;
    row.appendChild(labelDiv);

    const plotArea = document.createElement("div");
    plotArea.className = "swimlane-plot-area";

    deliverables.forEach(item => {
        const startDate = new Date(item.StartDate);
        const endDate = new Date(item.EndDate);

        // Clamp dates to timeline view boundaries
        const barStart = startDate < TIMELINE_START ? TIMELINE_START : startDate;
        const barEnd = endDate > TIMELINE_END ? TIMELINE_END : endDate;

        if (barEnd > barStart) {
            const leftPct = getTimelineOffsetPercent(barStart);
            const widthPct = getTimelineDurationPercent(barStart, barEnd);

            const bar = document.createElement("div");
            bar.className = "timeline-bar";
            
            const colorVar = `--accent-${getAbbreviationLower(serviceLine)}`;
            const bgVar = `--accent-${getAbbreviationLower(serviceLine)}-bg`;
            bar.style.setProperty("--service-color", `var(${colorVar})`);
            bar.style.setProperty("--service-bg-color", `var(${bgVar})`);
            
            bar.style.left = `${leftPct}%`;
            bar.style.width = `${widthPct}%`;

            const progressPercent = Math.min(Math.max(item.Progress * 100, 0), 100);

            bar.innerHTML = `
                <div class="timeline-bar-progress-tint" style="width: ${progressPercent}%;"></div>
                <span class="timeline-bar-title" title="${item.Title}">${item.Title}</span>
            `;

            bar.addEventListener("click", () => openDetailDrawer(item));
            plotArea.appendChild(bar);
        }
    });

    row.appendChild(plotArea);
    return row;
}

// ==========================================================================
// 5. Drawer, Modals & UI Actions
// ==========================================================================

// Opens right slide-out details panel and loads change logs
function openDetailDrawer(item) {
    const drawer = document.getElementById("details-drawer");
    const overlay = document.getElementById("drawer-overlay");
    const detailBody = document.getElementById("drawer-detail-body");

    const colorVar = `--accent-${getAbbreviationLower(item.ServiceArea)}`;
    const bgVar = `--accent-${getAbbreviationLower(item.ServiceArea)}-bg`;

    detailBody.innerHTML = `
        <div class="drawer-header">
            <div class="drawer-meta-line">
                <span class="card-id" style="background-color: var(${bgVar}); color: var(${colorVar});">${item.RoadmapID}</span>
                <span class="card-status-badge ${getStatusBadgeClass(item.Status)}">${item.Status}</span>
            </div>
            <h2>${item.Title}</h2>
        </div>

        <div class="detail-section">
            <h4>Strategic Alignment</h4>
            <div class="detail-hierarchy-box" style="--service-color: var(${colorVar});">
                <div class="hierarchy-item">
                    <span class="hierarchy-label">Enterprise / BU Initiative</span>
                    <div class="hierarchy-value">${item.BUInitiative}</div>
                </div>
                <div class="hierarchy-item" style="margin-top:0.6rem;">
                    <span class="hierarchy-label">Strategic Objective</span>
                    <div class="hierarchy-value">${item.Objective}</div>
                </div>
            </div>
        </div>

        <div class="detail-section">
            <h4>Description</h4>
            <p>${item.Description || "No description details provided."}</p>
        </div>

        <div class="detail-section">
            <h4>Timeline Details</h4>
            <p><strong>Start Date:</strong> ${item.StartDate} (${formatQuarter(item.StartDate)})</p>
            <p><strong>Target Finish Date:</strong> ${item.EndDate} (${formatQuarter(item.EndDate)})</p>
        </div>

        <div class="detail-section">
            <h4>Progress Indicator</h4>
            <div class="card-progress-section" style="--service-color: var(${colorVar});">
                <div class="progress-header-info">
                    <span class="progress-label">Progress: <strong>${item.Progress.toFixed(2)}</strong></span>
                    <span class="progress-value">${Math.round(item.Progress * 100)}% Complete</span>
                </div>
                <div class="progress-bar-track">
                    <div class="progress-bar-fill" style="width: ${item.Progress * 100}%;"></div>
                </div>
            </div>
        </div>

        <div class="detail-section">
            <h4>Deliverable Meta</h4>
            <p><strong>Service Area:</strong> ${item.ServiceArea}</p>
            <p><strong>Assigned Owner:</strong> ${item.SubCategory}</p>
            <p style="margin-top: 0.5rem;">
                <strong>Jira Ticket:</strong> 
                ${item.JiraLink ? `<a href="${item.JiraLink}" target="_blank" class="drawer-jira-link" onclick="event.stopPropagation();"><svg viewBox="0 0 24 24" width="12" height="12" style="margin-bottom:-1px; margin-right:4px;"><path fill="currentColor" d="M11.57 2.15a.5.5 0 00-.73 0L2.14 11a.5.5 0 000 .72l3.41 3.41a.5.5 0 00.73 0l8.71-8.72a.5.5 0 000-.73zM17.58 8.16a.5.5 0 00-.73 0l-3.41 3.41a.5.5 0 000 .72l8.72 8.72a.5.5 0 00.72 0l3.42-3.42a.5.5 0 000-.72zM5.56 8.16a.5.5 0 00-.72 0L1.42 11.58a.5.5 0 000 .72l8.72 8.72a.5.5 0 00.73 0l3.41-3.41a.5.5 0 000-.73zM11.57 14.17a.5.5 0 00-.73 0l-3.41 3.41a.5.5 0 000 .72l8.72 8.72a.5.5 0 00.72 0l3.42-3.42a.5.5 0 000-.72z"/></svg>${getJiraKey(item.JiraLink)}</a>` : '<span style="color:var(--text-tertiary);">None linked</span>'}
            </p>
        </div>

        <div class="detail-section">
            <h4>Change History Timeline (REST API logs)</h4>
            <div class="history-timeline" id="history-timeline-box">
                <p style="color:var(--text-tertiary); font-size:0.8rem;">Loading version logs...</p>
            </div>
        </div>
    `;

    drawer.classList.add("active");
    overlay.classList.add("active");

    // Dynamic OData query version history diffs
    fetchItemHistory(item).then(historyLogs => {
        const timelineBox = document.getElementById("history-timeline-box");
        if (historyLogs.length === 0) {
            timelineBox.innerHTML = "<p style='color:var(--text-tertiary); font-size:0.85rem;'>No modification logs recorded for this item.</p>";
            return;
        }

        timelineBox.innerHTML = "";
        historyLogs.forEach((log, index) => {
            const logItem = document.createElement("div");
            logItem.className = "history-timeline-item";
            logItem.innerHTML = `
                <div class="history-bullet ${index === 0 ? 'active-bullet' : ''}"></div>
                <div class="history-item-meta">
                    Version ${log.version} &bull; ${log.date} by <span>${log.author}</span>
                </div>
                <div class="history-item-change-desc">${log.change}</div>
            `;
            timelineBox.appendChild(logItem);
        });
    });
}

function closeDrawer() {
    document.getElementById("details-drawer").classList.remove("active");
    document.getElementById("drawer-overlay").classList.remove("active");
}

// Sidebar Filter Generation
function buildFilterPanels() {
    const serviceFilterBox = document.getElementById("filter-service");
    const initiativeFilterBox = document.getElementById("filter-initiative");
    const statusFilterBox = document.getElementById("filter-status");

    // Gather unique elements
    const services = ["Devices and Applications", "Communication and Collaboration", "Colleague Services", "AI Enablement", "EST"];
    
    const initiatives = [...new Set(ROADMAP_ITEMS.map(item => item.BUInitiative))];
    const statuses = ["In Development", "Rolling Out", "Launched"];

    // Render Service checkbox checklist
    serviceFilterBox.innerHTML = "";
    services.forEach((s, idx) => {
        const label = document.createElement("label");
        label.className = "roadmap-checkbox-container";
        label.innerHTML = `
            <input type="checkbox" name="service-filter" value="${s}">
            <span class="roadmap-checkbox-box"></span>
            <span class="roadmap-checkbox-label">${s}</span>
        `;
        label.querySelector("input").addEventListener("change", (e) => {
            if (e.target.checked) activeFilters.service.push(s);
            else activeFilters.service = activeFilters.service.filter(item => item !== s);
            renderViews();
        });
        serviceFilterBox.appendChild(label);
    });

    // Render Initiatives checkbox checklist
    initiativeFilterBox.innerHTML = "";
    initiatives.forEach((i, idx) => {
        const label = document.createElement("label");
        label.className = "roadmap-checkbox-container";
        label.innerHTML = `
            <input type="checkbox" name="initiative-filter" value="${i}">
            <span class="roadmap-checkbox-box"></span>
            <span class="roadmap-checkbox-label">${i}</span>
        `;
        label.querySelector("input").addEventListener("change", (e) => {
            if (e.target.checked) activeFilters.initiative.push(i);
            else activeFilters.initiative = activeFilters.initiative.filter(item => item !== i);
            renderViews();
        });
        initiativeFilterBox.appendChild(label);
    });

    // Render Status checkbox checklist
    statusFilterBox.innerHTML = "";
    statuses.forEach((st, idx) => {
        const label = document.createElement("label");
        label.className = "roadmap-checkbox-container";
        label.innerHTML = `
            <input type="checkbox" name="status-filter" value="${st}">
            <span class="roadmap-checkbox-box"></span>
            <span class="roadmap-checkbox-label">${st}</span>
        `;
        label.querySelector("input").addEventListener("change", (e) => {
            if (e.target.checked) activeFilters.status.push(st);
            else activeFilters.status = activeFilters.status.filter(item => item !== st);
            renderViews();
        });
        statusFilterBox.appendChild(label);
    });
}

// Master Render switcher
function renderViews() {
    if (currentView === 'list') {
        renderListView();
    } else {
        renderTimelineView();
    }
}

// ==========================================================================
// 6. Utility Helper Functions
// ==========================================================================
function getJiraKey(url) {
    if (!url) return "Jira Ticket";
    try {
        const parts = url.trim().split('/');
        // Extract DEX-411 from https://.../DEX-411 or return a default
        const key = parts[parts.length - 1];
        return key && key.includes('-') ? key : "Jira Link";
    } catch(e) {
        return "Jira Link";
    }
}

function getAbbreviationLower(service) {
    const abbrev = SERVICE_ABBREVIATIONS[service] || "da";
    return abbrev.toLowerCase().replace('&', '');
}

function getStatusBadgeClass(status) {
    if (status === "Launched") return "status-launch";
    if (status === "Rolling Out") return "status-roll";
    return "status-dev";
}

function formatQuarter(dateString) {
    const date = new Date(dateString);
    const month = date.getMonth();
    const year = date.getFullYear();
    
    let q = "Q1";
    if (month >= 3 && month <= 5) q = "Q2";
    else if (month >= 6 && month <= 8) q = "Q3";
    else if (month >= 9 && month <= 11) q = "Q4";
    
    return `${q} ${year}`;
}

function getTimelineOffsetPercent(date) {
    const diffTime = date - TIMELINE_START;
    const diffDays = diffTime / (1000 * 60 * 60 * 24);
    const percent = (diffDays / TOTAL_TIMELINE_DAYS) * 100;
    return Math.min(Math.max(percent, 0), 100);
}

function getTimelineDurationPercent(startDate, endDate) {
    const diffTime = endDate - startDate;
    const diffDays = diffTime / (1000 * 60 * 60 * 24);
    const percent = (diffDays / TOTAL_TIMELINE_DAYS) * 100;
    return Math.min(Math.max(percent, 1), 100);
}

// ==========================================================================
// 7. Initialization & Event Listeners
// ==========================================================================
document.addEventListener("DOMContentLoaded", () => {
    // A. Query database values
    fetchRoadmapData().then(items => {
        ROADMAP_ITEMS = items;
        buildFilterPanels();
        renderViews();
    });

    // B. Setup Search bar listener
    const searchInput = document.getElementById("roadmap-search");
    searchInput.addEventListener("input", (e) => {
        searchTerm = e.target.value;
        renderViews();
    });

    // C. View Tab buttons
    const tabButtons = document.querySelectorAll(".nav-tab");
    tabButtons.forEach(btn => {
        btn.addEventListener("click", () => {
            tabButtons.forEach(b => b.classList.remove("active"));
            btn.classList.add("active");
            
            const targetView = btn.getAttribute("data-view");
            currentView = targetView;
            
            document.getElementById("list-view-container").classList.toggle("active", targetView === 'list');
            document.getElementById("timeline-view-container").classList.toggle("active", targetView === 'timeline');
            
            renderViews();
        });
    });

    // D. Timeline Grouping selector radios
    const groupRadios = document.querySelectorAll("input[name='timeline-group']");
    groupRadios.forEach(radio => {
        radio.addEventListener("change", (e) => {
            timelineGroup = e.target.value;
            renderTimelineView();
        });
    });

    // E. Details Drawer close
    document.getElementById("close-drawer").addEventListener("click", closeDrawer);
    document.getElementById("drawer-overlay").addEventListener("click", closeDrawer);

    // F. Clear filters button
    document.getElementById("clear-filters").addEventListener("click", () => {
        // Uncheck all sidebar checkboxes
        const checkboxes = document.querySelectorAll(".filter-sidebar input[type='checkbox']");
        checkboxes.forEach(cb => cb.checked = false);
        
        activeFilters = { service: [], initiative: [], status: [] };
        renderViews();
    });

    // G. Light/Dark Mode toggle
    const themeBtn = document.getElementById("theme-toggle");
    const sunIcon = themeBtn.querySelector(".sun-icon");
    const moonIcon = themeBtn.querySelector(".moon-icon");
    
    themeBtn.addEventListener("click", () => {
        document.body.classList.toggle("dark-theme");
        const isDark = document.body.classList.contains("dark-theme");
        sunIcon.style.display = isDark ? "block" : "none";
        moonIcon.style.display = isDark ? "none" : "block";
    });

    // H. Add Item Modal Controls (Demo purposes)
    const addBtn = document.getElementById("add-item-btn");
    const modalOverlay = document.getElementById("modal-overlay");
    const closeModal = document.getElementById("close-modal");
    const cancelModalBtn = document.getElementById("cancel-form-btn");
    const addForm = document.getElementById("add-roadmap-form");

    addBtn.addEventListener("click", () => {
        modalOverlay.classList.add("active");
        // Pre-fill today's dates into form inputs
        const today = new Date().toISOString().split('T')[0];
        document.getElementById("form-start").value = today;
        document.getElementById("form-end").value = today;
    });

    const hideModal = () => {
        modalOverlay.classList.remove("active");
        addForm.reset();
    };

    closeModal.addEventListener("click", hideModal);
    cancelModalBtn.addEventListener("click", hideModal);
    modalOverlay.addEventListener("click", (e) => {
        if (e.target === modalOverlay) hideModal();
    });

    addForm.addEventListener("submit", (e) => {
        e.preventDefault();
        
        const newItem = {
            Title: document.getElementById("form-title").value,
            Description: document.getElementById("form-desc").value,
            ServiceArea: document.getElementById("form-service").value,
            Objective: document.getElementById("form-objective").value,
            BUInitiative: document.getElementById("form-initiative").value,
            StartDate: document.getElementById("form-start").value,
            EndDate: document.getElementById("form-end").value,
            Progress: parseFloat(document.getElementById("form-progress").value) || 0.0,
            Status: document.getElementById("form-status").value,
            SubCategory: "Self-Created",
            IsMilestone: false,
            JiraLink: document.getElementById("form-jira").value
        };

        saveRoadmapItem(newItem).then(() => {
            hideModal();
            buildFilterPanels();
            renderViews();
        });
    });
});
