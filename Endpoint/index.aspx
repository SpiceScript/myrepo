<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Workspace Services Roadmap & Strategy Hub</title>
    <!-- Modern Premium Typography -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Combined Styles -->
    <style>
        /* ==========================================================================
           Design Tokens & Themes
           ========================================================================== */
        :root {
            /* Color Palette - Light Mode */
            --bg-primary: #F8FAFC;
            --bg-secondary: #FFFFFF;
            --bg-tertiary: #F1F5F9;
            --border-color: #E2E8F0;
            --text-primary: #0F172A;
            --text-secondary: #475569;
            --text-tertiary: #94A3B8;
            
            --primary: #6366F1;
            --primary-hover: #4F46E5;
            --primary-rgb: 99, 102, 241;
            
            --border-rgb: 226, 232, 240;
            --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 20px -2px rgba(15, 23, 42, 0.05), 0 2px 6px -1px rgba(15, 23, 42, 0.03);
            --shadow-lg: 0 10px 30px -4px rgba(15, 23, 42, 0.08), 0 4px 12px -2px rgba(15, 23, 42, 0.04);
            
            /* Service Area Accent Colors */
            --accent-da: #64748B;
            --accent-da-bg: rgba(100, 116, 139, 0.08);
            --accent-cc: #0D9488;
            --accent-cc-bg: rgba(13, 148, 136, 0.08);
            --accent-cs: #16A34A;
            --accent-cs-bg: rgba(22, 163, 74, 0.08);
            --accent-ai: #8B5CF6;
            --accent-ai-bg: rgba(139, 92, 246, 0.08);
            --accent-est: #D97706;
            --accent-est-bg: rgba(217, 119, 6, 0.08);

            /* Status Badge Colors */
            --status-dev: #D97706;
            --status-dev-bg: #FEF3C7;
            --status-dev-text: #B45309;
            
            --status-roll: #2563EB;
            --status-roll-bg: #DBEAFE;
            --status-roll-text: #1D4ED8;
            
            --status-launch: #16A34A;
            --status-launch-bg: #D1FAE5;
            --status-launch-text: #065F46;

            /* Base Styling variables */
            --border-radius-sm: 6px;
            --border-radius-md: 12px;
            --border-radius-lg: 16px;
            --font-sans: 'Inter', system-ui, -apple-system, sans-serif;
            --font-header: 'Outfit', var(--font-sans);
            --transition-smooth: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .dark-theme {
            /* Color Palette - Dark Mode */
            --bg-primary: #0F172A;
            --bg-secondary: #1E293B;
            --bg-tertiary: #1E293B;
            --border-color: #334155;
            --text-primary: #F8FAFC;
            --text-secondary: #94A3B8;
            --text-tertiary: #64748B;
            
            --primary: #818CF8;
            --primary-hover: #6366F1;
            --primary-rgb: 129, 140, 248;
            
            --border-rgb: 51, 65, 85;
            --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.3);
            --shadow-md: 0 4px 20px -2px rgba(0, 0, 0, 0.3);
            --shadow-lg: 0 10px 30px -4px rgba(0, 0, 0, 0.4);
            
            /* Service Area Accent Colors - Dark Mode Adaptations */
            --accent-da: #94A3B8;
            --accent-da-bg: rgba(148, 163, 184, 0.15);
            --accent-cc: #2DD4BF;
            --accent-cc-bg: rgba(45, 212, 191, 0.15);
            --accent-cs: #4ADE80;
            --accent-cs-bg: rgba(74, 222, 128, 0.15);
            --accent-ai: #A78BFA;
            --accent-ai-bg: rgba(167, 139, 250, 0.15);
            --accent-est: #FBBF24;
            --accent-est-bg: rgba(251, 191, 36, 0.15);

            /* Status Badges - Dark Mode */
            --status-dev-bg: rgba(251, 191, 36, 0.15);
            --status-dev-text: #FBBF24;
            
            --status-roll-bg: rgba(96, 165, 250, 0.15);
            --status-roll-text: #60A5FA;
            
            --status-launch-bg: rgba(74, 222, 128, 0.15);
            --status-launch-text: #4ADE80;
        }

        /* ==========================================================================
           Global Reset & Scrollbars
           ========================================================================== */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: var(--font-sans);
            background-color: var(--bg-primary);
            color: var(--text-primary);
            line-height: 1.5;
            transition: background-color 0.3s ease, color 0.3s ease;
            overflow-x: hidden;
        }

        /* Custom Scrollbars */
        ::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }
        ::-webkit-scrollbar-track {
            background: transparent;
        }
        ::-webkit-scrollbar-thumb {
            background: var(--border-color);
            border-radius: 4px;
        }
        ::-webkit-scrollbar-thumb:hover {
            background: var(--text-tertiary);
        }

        /* ==========================================================================
           App Header Style
           ========================================================================== */
        .app-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 2rem;
            background-color: rgba(var(--border-rgb), 0.3);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--border-color);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .header-logo-section {
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }

        .app-logo {
            width: 38px;
            height: 38px;
        }

        .header-titles h1 {
            font-family: var(--font-header);
            font-size: 1.4rem;
            font-weight: 700;
            letter-spacing: -0.02em;
            background: linear-gradient(135deg, var(--primary), #8B5CF6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .header-titles p {
            font-size: 0.75rem;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-weight: 600;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .search-container {
            position: relative;
            width: 320px;
        }

        .search-icon {
            position: absolute;
            left: 0.8rem;
            top: 50%;
            transform: translateY(-50%);
            width: 18px;
            height: 18px;
            color: var(--text-tertiary);
        }

        .search-container input {
            width: 100%;
            padding: 0.6rem 1rem 0.6rem 2.4rem;
            background-color: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius-md);
            color: var(--text-primary);
            font-family: var(--font-sans);
            font-size: 0.875rem;
            transition: var(--transition-smooth);
        }

        .search-container input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(var(--primary-rgb), 0.15);
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.6rem 1.2rem;
            border-radius: var(--border-radius-md);
            font-family: var(--font-sans);
            font-size: 0.875rem;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition-smooth);
            border: 1px solid transparent;
        }

        .btn-primary {
            background-color: var(--primary);
            color: #FFFFFF;
        }

        .btn-primary:hover {
            background-color: var(--primary-hover);
            transform: translateY(-1px);
        }

        .btn-secondary {
            background-color: var(--bg-tertiary);
            color: var(--text-secondary);
            border-color: var(--border-color);
        }

        .btn-secondary:hover {
            background-color: var(--border-color);
            color: var(--text-primary);
        }

        .btn-text {
            background: transparent;
            color: var(--text-secondary);
            padding: 0.4rem 0.8rem;
        }

        .btn-text:hover {
            color: var(--primary);
            background-color: var(--bg-tertiary);
        }

        .btn-icon-only {
            width: 38px;
            height: 38px;
            padding: 0;
            justify-content: center;
            border-radius: var(--border-radius-md);
            background-color: var(--bg-secondary);
            border: 1px solid var(--border-color);
            color: var(--text-secondary);
        }

        .btn-icon-only:hover {
            color: var(--text-primary);
            border-color: var(--text-tertiary);
        }

        .btn-icon {
            width: 18px;
            height: 18px;
        }

        /* ==========================================================================
           Navigation Tabs Style
           ========================================================================== */
        .app-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 2rem;
            background-color: var(--bg-secondary);
            border-bottom: 1px solid var(--border-color);
        }

        .nav-tabs {
            display: flex;
            gap: 0.5rem;
        }

        .nav-tab {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.6rem 1.2rem;
            border: none;
            background: transparent;
            color: var(--text-secondary);
            font-family: var(--font-header);
            font-size: 0.95rem;
            font-weight: 500;
            cursor: pointer;
            position: relative;
            transition: var(--transition-smooth);
        }

        .nav-tab:hover {
            color: var(--text-primary);
        }

        .nav-tab.active {
            color: var(--primary);
            font-weight: 600;
        }

        .nav-tab.active::after {
            content: '';
            position: absolute;
            bottom: -0.5rem;
            left: 0;
            right: 0;
            height: 3px;
            background-color: var(--primary);
            border-top-left-radius: 3px;
            border-top-right-radius: 3px;
        }

        .tab-icon {
            width: 18px;
            height: 18px;
        }

        .nav-stats {
            font-size: 0.8rem;
            color: var(--text-secondary);
            font-weight: 500;
        }

        .nav-stats span {
            font-weight: 700;
            color: var(--text-primary);
        }

        /* ==========================================================================
           Main Layout & Filter Sidebar
           ========================================================================== */
        .app-main {
            display: flex;
            min-height: calc(100vh - 120px);
        }

        .filter-sidebar {
            width: 280px;
            background-color: var(--bg-secondary);
            border-right: 1px solid var(--border-color);
            padding: 1.5rem;
            flex-shrink: 0;
        }

        .sidebar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .sidebar-header h2 {
            font-family: var(--font-header);
            font-size: 1.1rem;
            font-weight: 600;
        }

        .filter-group {
            margin-bottom: 1.5rem;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 1.2rem;
        }

        .filter-group h3 {
            font-size: 0.85rem;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-weight: 600;
            margin-bottom: 0.8rem;
        }

        .filter-options {
            display: flex;
            flex-direction: column;
            gap: 0.6rem;
        }

        /* Checkbox Style customization (Namespaced to avoid Bootstrap/Power Pages collisions) */
        .roadmap-checkbox-container {
            display: flex !important;
            flex-direction: row !important;
            align-items: flex-start !important;
            justify-content: flex-start !important;
            gap: 0.6rem !important;
            font-size: 0.875rem !important;
            color: var(--text-primary) !important;
            cursor: pointer !important;
            user-select: none !important;
            position: relative !important;
            margin: 0.5rem 0 !important;
            padding: 0 !important;
            float: none !important;
            height: auto !important;
            width: 100% !important;
            text-align: left !important;
        }

        .roadmap-checkbox-container input[type="checkbox"] {
            all: unset !important;
            opacity: 0 !important;
            position: absolute !important;
            width: 0 !important;
            height: 0 !important;
            margin: 0 !important;
            padding: 0 !important;
            border: none !important;
        }

        .roadmap-checkbox-box {
            display: inline-flex !important;
            justify-content: center !important;
            align-items: center !important;
            width: 18px !important;
            height: 18px !important;
            border: 1.5px solid var(--text-tertiary) !important;
            border-radius: 4px !important;
            background-color: var(--bg-secondary) !important;
            flex-shrink: 0 !important;
            margin-top: 2px !important;
            margin-right: 8px !important;
            transition: var(--transition-smooth) !important;
            position: relative !important;
        }

        .roadmap-checkbox-container input[type="checkbox"]:checked ~ .roadmap-checkbox-box {
            background-color: var(--primary) !important;
            border-color: var(--primary) !important;
        }

        .roadmap-checkbox-box::after {
            content: '' !important;
            display: none !important;
            width: 5px !important;
            height: 10px !important;
            border: solid #FFFFFF !important;
            border-width: 0 2px 2px 0 !important;
            transform: rotate(45deg) !important;
            margin-bottom: 2px !important;
            position: absolute !important;
        }

        .roadmap-checkbox-container input[type="checkbox"]:checked ~ .roadmap-checkbox-box::after {
            display: block !important;
        }

        .roadmap-checkbox-container:hover .roadmap-checkbox-box {
            border-color: var(--primary) !important;
        }

        .roadmap-checkbox-label {
            display: inline-block !important;
            line-height: 1.3rem !important;
            font-weight: 500 !important;
            color: var(--text-primary) !important;
            text-align: left !important;
            white-space: normal !important;
            pointer-events: none !important;
        }

        /* ==========================================================================
           Content Display
           ========================================================================== */
        .content-display {
            flex-grow: 1;
            padding: 2rem;
            overflow-y: auto;
            max-height: calc(100vh - 120px);
        }

        .view-panel {
            display: none;
            animation: fadeIn 0.3s ease-in-out;
        }

        .view-panel.active {
            display: block;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(360px, 1fr));
            gap: 1.5rem;
        }

        /* ==========================================================================
           Card Styling
           ========================================================================== */
        .roadmap-card {
            background-color: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius-md);
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            position: relative;
            box-shadow: var(--shadow-sm);
            transition: var(--transition-smooth);
            cursor: pointer;
            overflow: hidden;
        }

        .roadmap-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background-color: var(--service-color, var(--primary));
        }

        .roadmap-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
            border-color: var(--service-color, var(--primary));
        }

        .card-strategy-path {
            background-color: var(--bg-tertiary);
            padding: 0.5rem 0.8rem;
            border-radius: var(--border-radius-sm);
            font-size: 0.75rem;
            margin-bottom: 0.8rem;
            display: flex;
            flex-direction: column;
            gap: 0.2rem;
            border-left: 3px solid var(--service-color, var(--primary));
        }

        .strategy-initiative {
            font-weight: 700;
            color: var(--text-primary);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .strategy-objective {
            color: var(--text-secondary);
            font-weight: 500;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .card-header-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 1rem;
            margin-bottom: 0.5rem;
        }

        .card-id {
            font-family: var(--font-header);
            font-size: 0.8rem;
            font-weight: 700;
            color: var(--service-color, var(--primary));
            background-color: var(--service-bg-color, var(--bg-tertiary));
            padding: 0.25rem 0.6rem;
            border-radius: 4px;
        }

        .card-status-badge {
            font-size: 0.75rem;
            font-weight: 600;
            padding: 0.25rem 0.6rem;
            border-radius: 20px;
            text-transform: capitalize;
        }

        .status-dev {
            background-color: var(--status-dev-bg);
            color: var(--status-dev-text);
        }
        .status-roll {
            background-color: var(--status-roll-bg);
            color: var(--status-roll-text);
        }
        .status-launch {
            background-color: var(--status-launch-bg);
            color: var(--status-launch-text);
        }

        .roadmap-card h3 {
            font-family: var(--font-header);
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.6rem;
            color: var(--text-primary);
            line-height: 1.35;
        }

        .card-description {
            font-size: 0.875rem;
            color: var(--text-secondary);
            margin-bottom: 1.2rem;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            height: 4.1rem;
        }

        .card-progress-section {
            margin-top: auto;
            margin-bottom: 1rem;
        }

        .progress-header-info {
            display: flex;
            justify-content: space-between;
            font-size: 0.8rem;
            font-weight: 600;
            margin-bottom: 0.3rem;
        }

        .progress-label {
            color: var(--text-secondary);
        }

        .progress-value {
            color: var(--text-primary);
        }

        .progress-bar-track {
            height: 8px;
            background-color: var(--bg-tertiary);
            border-radius: 4px;
            overflow: hidden;
        }

        .progress-bar-fill {
            height: 100%;
            background-color: var(--service-color, var(--primary));
            border-radius: 4px;
            transition: width 0.6s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .card-footer-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid var(--border-color);
            padding-top: 0.8rem;
            font-size: 0.75rem;
            color: var(--text-tertiary);
        }

        .meta-dates {
            display: flex;
            gap: 0.5rem;
        }

        .meta-date-label {
            font-weight: 600;
            color: var(--text-secondary);
        }

        .meta-service-tag {
            font-weight: 600;
            color: var(--service-color, var(--primary));
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        /* ==========================================================================
           Timeline Grid Styles
           ========================================================================== */
        .timeline-controls {
            background-color: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius-md);
            padding: 1rem;
            margin-bottom: 1.5rem;
        }

        .timeline-grouping {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }

        .control-label {
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--text-secondary);
        }

        .radio-btn {
            display: flex;
            align-items: center;
            gap: 0.4rem;
            font-size: 0.875rem;
            cursor: pointer;
        }

        .radio-btn input {
            accent-color: var(--primary);
        }

        .timeline-board-wrapper {
            overflow-x: auto;
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius-lg);
            background-color: var(--bg-secondary);
            box-shadow: var(--shadow-md);
        }

        .timeline-board {
            min-width: 1100px;
            position: relative;
            display: flex;
            flex-direction: column;
        }

        .timeline-quarters-header {
            display: grid;
            grid-template-columns: 280px repeat(4, 1fr);
            background-color: var(--bg-tertiary);
            border-bottom: 1px solid var(--border-color);
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .quarter-column-title {
            padding: 1rem;
            text-align: center;
            font-family: var(--font-header);
            font-weight: 700;
            font-size: 0.95rem;
            border-left: 1px solid var(--border-color);
            color: var(--text-primary);
        }

        .quarter-column-title:first-child {
            border-left: none;
            text-align: left;
            padding-left: 1.5rem;
            background-color: var(--bg-tertiary);
            position: sticky;
            left: 0;
            z-index: 11;
        }

        .swimlane-row-group {
            border-bottom: 1px solid var(--border-color);
        }

        .swimlane-group-header {
            background-color: var(--bg-tertiary);
            padding: 0.5rem 1.5rem;
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-secondary);
            border-bottom: 1px solid var(--border-color);
            position: sticky;
            left: 0;
        }

        .swimlane-sub-row {
            display: grid;
            grid-template-columns: 280px 1fr;
            border-bottom: 1px dashed var(--border-color);
            min-height: 52px;
        }

        .swimlane-sub-row:last-child {
            border-bottom: none;
        }

        .swimlane-row-label {
            padding: 0.8rem 1.5rem;
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--text-primary);
            border-right: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            background-color: var(--bg-secondary);
            position: sticky;
            left: 0;
            z-index: 8;
        }

        .swimlane-plot-area {
            position: relative;
            width: 100%;
            height: 100%;
            min-height: 48px;
            background-image: 
                linear-gradient(to right, var(--border-color) 1px, transparent 1px);
            background-size: 25% 100%;
        }

        .timeline-bar {
            position: absolute;
            top: 8px;
            height: 32px;
            border-radius: var(--border-radius-sm);
            background-color: var(--service-bg-color, var(--primary));
            border-left: 4px solid var(--service-color, var(--primary));
            box-shadow: var(--shadow-sm);
            cursor: pointer;
            overflow: hidden;
            transition: var(--transition-smooth);
            display: flex;
            align-items: center;
            padding: 0 0.8rem;
        }

        .timeline-bar:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
            filter: brightness(0.95);
            z-index: 5;
        }

        .timeline-bar-title {
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--text-primary);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            z-index: 2;
            flex-grow: 1;
        }

        .timeline-bar-progress-tint {
            position: absolute;
            top: 0;
            bottom: 0;
            left: 0;
            background-color: var(--service-color, var(--primary));
            opacity: 0.18;
            transition: width 0.6s ease;
            z-index: 1;
        }

        /* ==========================================================================
           Details Sliding Drawer & Timeline
           ========================================================================== */
        .drawer-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(15, 23, 42, 0.4);
            backdrop-filter: blur(4px);
            z-index: 199;
            opacity: 0;
            visibility: hidden;
            transition: var(--transition-smooth);
        }

        .drawer-overlay.active {
            opacity: 1;
            visibility: visible;
        }

        .details-drawer {
            position: fixed;
            top: 0;
            right: 0;
            width: 480px;
            height: 100vh;
            background-color: var(--bg-secondary);
            border-left: 1px solid var(--border-color);
            box-shadow: -10px 0 40px rgba(0, 0, 0, 0.15);
            z-index: 200;
            padding: 2rem;
            transform: translateX(100%);
            transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            overflow-y: auto;
        }

        .details-drawer.active {
            transform: translateX(0);
        }

        .close-drawer-btn {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: transparent;
            border: none;
            cursor: pointer;
            color: var(--text-tertiary);
            width: 28px;
            height: 28px;
            display: flex;
            justify-content: center;
            align-items: center;
            border-radius: 50%;
            transition: var(--transition-smooth);
        }

        .close-drawer-btn:hover {
            color: var(--text-primary);
            background-color: var(--bg-tertiary);
        }

        .drawer-header {
            margin-bottom: 1.5rem;
            margin-top: 1rem;
        }

        .drawer-meta-line {
            display: flex;
            gap: 0.8rem;
            margin-bottom: 0.8rem;
            align-items: center;
        }

        .drawer-header h2 {
            font-family: var(--font-header);
            font-size: 1.4rem;
            font-weight: 700;
            color: var(--text-primary);
            line-height: 1.3;
        }

        .detail-section {
            margin-bottom: 1.5rem;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 1.2rem;
        }

        .detail-section:last-child {
            border-bottom: none;
        }

        .detail-section h4 {
            font-size: 0.8rem;
            color: var(--text-tertiary);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .detail-section p {
            font-size: 0.925rem;
            color: var(--text-secondary);
        }

        .detail-hierarchy-box {
            background-color: var(--bg-tertiary);
            border-radius: var(--border-radius-md);
            padding: 1rem;
            border-left: 4px solid var(--service-color, var(--primary));
        }

        .hierarchy-item {
            margin-bottom: 0.8rem;
        }

        .hierarchy-item:last-child {
            margin-bottom: 0;
        }

        .hierarchy-label {
            font-size: 0.7rem;
            color: var(--text-tertiary);
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .hierarchy-value {
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--text-primary);
        }

        .history-timeline {
            position: relative;
            padding-left: 1.5rem;
            margin-top: 1rem;
        }

        .history-timeline::before {
            content: '';
            position: absolute;
            top: 5px;
            bottom: 5px;
            left: 4px;
            width: 2px;
            background-color: var(--border-color);
        }

        .history-timeline-item {
            position: relative;
            margin-bottom: 1.2rem;
        }

        .history-timeline-item:last-child {
            margin-bottom: 0;
        }

        .history-bullet {
            position: absolute;
            left: -1.5rem;
            top: 4px;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background-color: var(--border-color);
            border: 2px solid var(--bg-secondary);
        }

        .history-bullet.active-bullet {
            background-color: var(--primary);
        }

        .history-item-meta {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-tertiary);
            margin-bottom: 0.2rem;
        }

        .history-item-meta span {
            color: var(--text-primary);
        }

        .history-item-change-desc {
            font-size: 0.85rem;
            color: var(--text-secondary);
            line-height: 1.4;
        }

        .history-diff-highlight {
            background-color: var(--service-bg-color, var(--bg-tertiary));
            color: var(--service-color, var(--primary));
            padding: 0.1rem 0.3rem;
            border-radius: 3px;
            font-weight: 600;
            font-size: 0.8rem;
        }

        /* ==========================================================================
           Jira Integration Styles
           ========================================================================== */
        .card-jira-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
            font-size: 0.7rem;
            font-weight: 600;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            background-color: #DEEBFF;
            color: #0747A6;
            text-decoration: none;
            transition: var(--transition-smooth);
            border: 1px solid rgba(7, 71, 166, 0.15);
        }

        .dark-theme .card-jira-badge {
            background-color: rgba(7, 71, 166, 0.2);
            color: #4C9AFF;
            border-color: rgba(76, 154, 255, 0.3);
        }

        .card-jira-badge:hover {
            background-color: #0747A6;
            color: #FFFFFF;
            border-color: #0747A6;
        }

        .dark-theme .card-jira-badge:hover {
            background-color: #0052CC;
            color: #FFFFFF;
            border-color: #0052CC;
        }

        .card-jira-badge svg {
            width: 12px;
            height: 12px;
            fill: currentColor;
        }

        .drawer-jira-link {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            font-weight: 600;
            color: #0747A6;
            text-decoration: none;
            transition: var(--transition-smooth);
            background-color: rgba(7, 71, 166, 0.08);
            padding: 0.4rem 0.8rem;
            border-radius: var(--border-radius-sm);
            border: 1px solid rgba(7, 71, 166, 0.15);
        }

        .dark-theme .drawer-jira-link {
            color: #4C9AFF;
            background-color: rgba(76, 154, 255, 0.1);
            border-color: rgba(76, 154, 255, 0.2);
        }

        .drawer-jira-link:hover {
            background-color: #0747A6;
            color: #FFFFFF;
        }

        .dark-theme .drawer-jira-link:hover {
            background-color: #0052CC;
            color: #FFFFFF;
        }

        /* ==========================================================================
           Modals & Overlay Form layouts
           ========================================================================== */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(15, 23, 42, 0.5);
            backdrop-filter: blur(6px);
            z-index: 299;
            display: flex;
            justify-content: center;
            align-items: center;
            opacity: 0;
            visibility: hidden;
            transition: var(--transition-smooth);
        }

        .modal-overlay.active {
            opacity: 1;
            visibility: visible;
        }

        .modal-box {
            background-color: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius-lg);
            width: 100%;
            max-width: 600px;
            box-shadow: var(--shadow-lg);
            transform: scale(0.95);
            transition: var(--transition-smooth);
            overflow: hidden;
        }

        .modal-overlay.active .modal-box {
            transform: scale(1);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.2rem 1.8rem;
            background-color: var(--bg-tertiary);
            border-bottom: 1px solid var(--border-color);
        }

        .modal-header h2 {
            font-family: var(--font-header);
            font-size: 1.2rem;
            font-weight: 700;
        }

        .close-modal-btn {
            background: transparent;
            border: none;
            cursor: pointer;
            color: var(--text-tertiary);
            width: 24px;
            height: 24px;
            display: flex;
            justify-content: center;
            align-items: center;
            border-radius: 50%;
            transition: var(--transition-smooth);
        }

        .close-modal-btn:hover {
            color: var(--text-primary);
            background-color: var(--border-color);
        }

        .modal-form {
            padding: 1.8rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.4rem;
            margin-bottom: 1.2rem;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.2rem;
        }

        .form-group label {
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--text-secondary);
        }

        .form-group input, 
        .form-group select, 
        .form-group textarea {
            padding: 0.6rem 0.8rem;
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius-md);
            background-color: var(--bg-secondary);
            color: var(--text-primary);
            font-family: var(--font-sans);
            font-size: 0.875rem;
            transition: var(--transition-smooth);
        }

        .form-group input:focus, 
        .form-group select:focus, 
        .form-group textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(var(--primary-rgb), 0.15);
        }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 0.8rem;
            margin-top: 1.8rem;
            border-top: 1px solid var(--border-color);
            padding-top: 1.2rem;
        }

        /* ==========================================================================
           Responsive Adaptations
           ========================================================================== */
        @media (max-width: 992px) {
            .app-main {
                flex-direction: column;
            }
            
            .filter-sidebar {
                width: 100%;
                border-right: none;
                border-bottom: 1px solid var(--border-color);
                padding: 1rem 2rem;
            }
            
            .filter-group {
                margin-bottom: 0.8rem;
                padding-bottom: 0.8rem;
            }
            
            .search-container {
                width: 200px;
            }
        }

        @media (max-width: 600px) {
            .app-header {
                flex-direction: column;
                gap: 1rem;
                padding: 1rem;
            }
            
            .search-container {
                width: 100%;
            }
            
            .app-nav {
                flex-direction: column;
                gap: 0.5rem;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
    <!-- App Header -->
    <header class="app-header">
        <div class="header-logo-section">
            <svg class="app-logo" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 2L2 7L12 12L22 7L12 2Z" fill="url(#logo-grad)" />
                <path d="M2 17L12 22L22 17M2 12L17L22 12" stroke="url(#logo-grad)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <defs>
                    <linearGradient id="logo-grad" x1="2" y1="2" x2="22" y2="22" gradientUnits="userSpaceOnUse">
                        <stop stop-color="#8B5CF6" />
                        <stop offset="1" stop-color="#3B82F6" />
                    </linearGradient>
                </defs>
            </svg>
            <div class="header-titles">
                <h1>Workspace Services</h1>
                <p>Roadmap & Strategy Hub</p>
            </div>
        </div>
        
        <!-- Controls -->
        <div class="header-actions">
            <div class="search-container">
                <svg class="search-icon" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
                <input type="text" id="roadmap-search" placeholder="Search by Feature ID, title, or description...">
            </div>
            
            <button id="add-item-btn" class="btn btn-primary">
                <svg class="btn-icon" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                </svg>
                Add Item
            </button>

            <!-- Toggle Theme Button -->
            <button id="theme-toggle" class="btn btn-icon-only" title="Toggle Theme">
                <svg class="sun-icon" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364-6.364l-.707.707M6.343 17.657l-.707.707m12.728 0l-.707-.707M6.343 6.343l-.707-.707M12 8a4 4 0 100 8 4 4 0 000-8z" />
                </svg>
                <svg class="moon-icon" fill="none" viewBox="0 0 24 24" stroke="currentColor" style="display: none;">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
                </svg>
            </button>
        </div>
    </header>

    <!-- Navigation Tabs -->
    <nav class="app-nav">
        <div class="nav-tabs">
            <button class="nav-tab active" data-view="list">
                <svg class="tab-icon" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 10h16M4 14h16M4 18h16" />
                </svg>
                Items (List)
            </button>
            <button class="nav-tab" data-view="timeline">
                <svg class="tab-icon" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
                Timeline View
            </button>
        </div>
        <div class="nav-stats">
            Showing <span id="visible-count">0</span> of <span id="total-count">0</span> deliverables
        </div>
    </nav>

    <!-- Workspace Layout Grid -->
    <main class="app-main">
        <!-- Sidebar Filters -->
        <aside class="filter-sidebar">
            <div class="sidebar-header">
                <h2>Filters</h2>
                <button id="clear-filters" class="btn btn-text">Clear All</button>
            </div>
            
            <div class="filter-group">
                <h3>Service Area</h3>
                <div class="filter-options" id="filter-service"></div>
            </div>

            <div class="filter-group">
                <h3>Enterprise/BU Initiative</h3>
                <div class="filter-options" id="filter-initiative"></div>
            </div>

            <div class="filter-group">
                <h3>Status</h3>
                <div class="filter-options" id="filter-status"></div>
            </div>
        </aside>

        <!-- Content Area -->
        <section class="content-display">
            <!-- List Panel -->
            <div id="list-view-container" class="view-panel active">
                <div class="cards-grid" id="roadmap-cards-grid"></div>
            </div>

            <!-- Timeline Panel -->
            <div id="timeline-view-container" class="view-panel">
                <div class="timeline-controls">
                    <div class="timeline-grouping">
                        <span class="control-label">Group Swimlanes By:</span>
                        <label class="radio-btn">
                            <input type="radio" name="timeline-group" value="service" checked>
                            <span>Service Area</span>
                        </label>
                        <label class="radio-btn">
                            <input type="radio" name="timeline-group" value="objective">
                            <span>Strategic Objective</span>
                        </label>
                    </div>
                </div>

                <div class="timeline-board-wrapper">
                    <div class="timeline-board" id="timeline-board"></div>
                </div>
            </div>
        </section>
    </main>

    <!-- Details Sidebar Panel -->
    <div class="drawer-overlay" id="drawer-overlay"></div>
    <div class="details-drawer" id="details-drawer">
        <button class="close-drawer-btn" id="close-drawer">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M18 6L6 18M6 6l12 12" />
            </svg>
        </button>
        <div class="drawer-content" id="drawer-detail-body"></div>
    </div>

    <!-- Modal Form overlay -->
    <div class="modal-overlay" id="modal-overlay">
        <div class="modal-box">
            <div class="modal-header">
                <h2>Add Roadmap Item</h2>
                <button class="close-modal-btn" id="close-modal">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M18 6L6 18M6 6l12 12" />
                    </svg>
                </button>
            </div>
            <form id="add-roadmap-form" class="modal-form">
                <div class="form-group">
                    <label for="form-title">Key Result / Deliverable Title *</label>
                    <input type="text" id="form-title" required placeholder="e.g. Migrate legacy telephony to Teams voice">
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="form-service">Service Area *</label>
                        <select id="form-service" required>
                            <option value="" disabled selected>Select service line...</option>
                            <option value="Devices and Applications">Devices and Applications</option>
                            <option value="Communication and Collaboration">Communication and Collaboration</option>
                            <option value="Colleague Services">Colleague Services</option>
                            <option value="AI Enablement">AI Enablement</option>
                            <option value="EST">EST</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="form-status">Status *</label>
                        <select id="form-status" required>
                            <option value="In Development">In Development</option>
                            <option value="Rolling Out">Rolling Out</option>
                            <option value="Launched">Launched</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="form-objective">Strategic Objective *</label>
                    <input type="text" id="form-objective" required placeholder="e.g. Modernize digital workplace tools and services">
                </div>

                <div class="form-group">
                    <label for="form-initiative">Enterprise / BU Initiative *</label>
                    <input type="text" id="form-initiative" required placeholder="e.g. Digital Employee Experience (DEX) Transformation">
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="form-start">Start Date *</label>
                        <input type="date" id="form-start" required>
                    </div>
                    <div class="form-group">
                        <label for="form-end">End Date *</label>
                        <input type="date" id="form-end" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="form-progress">Progress Scale (0.0 to 1.0) *</label>
                        <input type="number" id="form-progress" min="0.0" max="1.0" step="0.05" value="0.0" required>
                    </div>
                    <div class="form-group">
                        <label for="form-jira">Jira Ticket Link (URL)</label>
                        <input type="url" id="form-jira" placeholder="e.g. https://yourcompany.atlassian.net/browse/WSS-101">
                    </div>
                </div>

                <div class="form-group">
                    <label for="form-desc">Description</label>
                    <textarea id="form-desc" rows="3" placeholder="Provide description details for this deliverable..."></textarea>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" id="cancel-form-btn">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Deliverable</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Embedded Scripts -->
    <script>
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

        const SERVICE_ABBREVIATIONS = {
            "Devices and Applications": "DA",
            "Communication and Collaboration": "CC",
            "Colleague Services": "CS",
            "AI Enablement": "AI",
            "EST": "EST"
        };

        // ==========================================================================
        // 2. Global State
        // ==========================================================================
        let currentView = 'list';
        let timelineGroup = 'service';
        let activeFilters = { service: [], initiative: [], status: [] };
        let searchTerm = '';

        const TIMELINE_START = new Date("2026-07-01");
        const TIMELINE_END = new Date("2027-06-30");
        const TOTAL_TIMELINE_DAYS = (TIMELINE_END - TIMELINE_START) / (1000 * 60 * 60 * 24);

        // ==========================================================================
        // 3. OData API Services
        // ==========================================================================
        const isSharePoint = typeof _spPageContextInfo !== 'undefined' || window.location.href.indexOf('/sites/') > -1;

        function fetchRoadmapData() {
            return new Promise((resolve) => {
                if (!isSharePoint) {
                    resolve(ROADMAP_ITEMS);
                    return;
                }
                const siteUrl = _spPageContextInfo.webAbsoluteUrl;
                const endPoint = `${siteUrl}/_api/web/lists/getbytitle('WorkspaceServicesRoadmap')/items?$select=Id,Title,Description,ServiceArea,Objective,BUInitiative,Progress,Status,StartDate,EndDate,RoadmapID,SubCategory,JiraLink`;
                
                fetch(endPoint, { headers: { "Accept": "application/json; odata=verbose" } })
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
                        VersionHistory: []
                    }));
                    resolve(mappedItems);
                })
                .catch(err => {
                    console.error("Fallback to mock data:", err);
                    resolve(ROADMAP_ITEMS);
                });
            });
        }

        function fetchItemHistory(item) {
            return new Promise((resolve) => {
                if (!isSharePoint) {
                    resolve(item.VersionHistory || []);
                    return;
                }
                const siteUrl = _spPageContextInfo.webAbsoluteUrl;
                const endPoint = `${siteUrl}/_api/web/lists/getbytitle('WorkspaceServicesRoadmap')/items(${item.Id})/versions`;

                fetch(endPoint, { headers: { "Accept": "application/json; odata=verbose" } })
                .then(response => response.json())
                .then(data => {
                    const versions = data.d.results;
                    if (!versions || versions.length === 0) {
                        resolve([]);
                        return;
                    }
                    const historyLogs = [];
                    for (let i = 0; i < Math.min(versions.length, 10); i++) {
                        const currentVer = versions[i];
                        const nextVer = versions[i + 1];
                        let changes = [];
                        if (nextVer) {
                            if (currentVer.Title !== nextVer.Title) changes.push(`Renamed title`);
                            if (currentVer.Progress !== nextVer.Progress) {
                                changes.push(`Updated Progress from <span class='history-diff-highlight'>${parseFloat(nextVer.Progress || 0.0).toFixed(2)}</span> to <span class='history-diff-highlight'>${parseFloat(currentVer.Progress || 0.0).toFixed(2)}</span>`);
                            }
                            if (currentVer.Status !== nextVer.Status) {
                                changes.push(`Changed Status to <span class='history-diff-highlight'>'${currentVer.Status}'</span>`);
                            }
                            if (currentVer.StartDate !== nextVer.StartDate || currentVer.EndDate !== nextVer.EndDate) {
                                changes.push(`Shifted timeline dates`);
                            }
                        } else {
                            changes.push(`Initial deliverable registered.`);
                        }
                        if (changes.length > 0) {
                            historyLogs.push({
                                version: currentVer.VersionLabel,
                                date: new Date(currentVer.Created).toLocaleDateString(),
                                author: currentVer.Editor.LookupValue || "System User",
                                change: changes.join(", ")
                            });
                        }
                    }
                    resolve(historyLogs);
                })
                .catch(err => {
                    resolve(item.VersionHistory || []);
                });
            });
        }

        function saveRoadmapItem(newItem) {
            return new Promise((resolve) => {
                const categoryItems = ROADMAP_ITEMS.filter(item => item.ServiceArea === newItem.ServiceArea);
                const count = categoryItems.length + 1;
                const abbrev = SERVICE_ABBREVIATIONS[newItem.ServiceArea] || "WSS";
                newItem.RoadmapID = `IS-WSS-${abbrev}-${count}`;
                newItem.Id = ROADMAP_ITEMS.length + 1;
                newItem.VersionHistory = [{ version: 1, date: new Date().toISOString().split('T')[0], author: "Local User", change: "Initial deliverable added to local roadmap." }];

                if (!isSharePoint) {
                    ROADMAP_ITEMS.push(newItem);
                    resolve(newItem);
                    return;
                }

                const siteUrl = _spPageContextInfo.webAbsoluteUrl;
                const endPoint = `${siteUrl}/_api/web/lists/getbytitle('WorkspaceServicesRoadmap')/items`;

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
                            RoadmapID: newItem.RoadmapID,
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
                    resolve(data.d);
                })
                .catch(err => {
                    ROADMAP_ITEMS.push(newItem);
                    resolve(newItem);
                });
            });
        }

        // ==========================================================================
        // 4. Rendering & Events
        // ==========================================================================
        function getFilteredItems() {
            return ROADMAP_ITEMS.filter(item => {
                const query = searchTerm.toLowerCase();
                const matchesSearch = !query || 
                    item.RoadmapID.toLowerCase().includes(query) ||
                    item.Title.toLowerCase().includes(query) ||
                    item.Description.toLowerCase().includes(query) ||
                    item.Objective.toLowerCase().includes(query) ||
                    item.BUInitiative.toLowerCase().includes(query);

                const matchesService = activeFilters.service.length === 0 || activeFilters.service.includes(item.ServiceArea);
                const matchesInitiative = activeFilters.initiative.length === 0 || activeFilters.initiative.includes(item.BUInitiative);
                const matchesStatus = activeFilters.status.length === 0 || activeFilters.status.includes(item.Status);

                return matchesSearch && matchesService && matchesInitiative && matchesStatus;
            });
        }

        function renderStats(visibleCount) {
            document.getElementById("visible-count").innerText = visibleCount;
            document.getElementById("total-count").innerText = ROADMAP_ITEMS.length;
        }

        function renderListView() {
            const listContainer = document.getElementById("roadmap-cards-grid");
            listContainer.innerHTML = "";
            const items = getFilteredItems();
            renderStats(items.length);

            if (items.length === 0) {
                listContainer.innerHTML = `
                    <div class="empty-state">
                        <h3>No deliverables match your filter selections.</h3>
                        <p>Try resetting filters in the sidebar.</p>
                    </div>
                `;
                return;
            }

            items.forEach(item => {
                const card = document.createElement("div");
                card.className = "roadmap-card";
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

        function renderTimelineView() {
            const board = document.getElementById("timeline-board");
            board.innerHTML = "";
            const items = getFilteredItems();
            renderStats(items.length);

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

            let groupedData = {};
            if (timelineGroup === 'service') {
                items.forEach(item => {
                    if (!groupedData[item.ServiceArea]) groupedData[item.ServiceArea] = {};
                    const subKey = item.SubCategory || "General";
                    if (!groupedData[item.ServiceArea][subKey]) groupedData[item.ServiceArea][subKey] = [];
                    groupedData[item.ServiceArea][subKey].push(item);
                });
                for (const [service, subGroups] of Object.entries(groupedData)) {
                    const groupWrapper = document.createElement("div");
                    groupWrapper.className = "swimlane-row-group";
                    const groupHeader = document.createElement("div");
                    groupHeader.className = "swimlane-group-header";
                    groupHeader.innerText = service;
                    groupWrapper.appendChild(groupHeader);
                    for (const [owner, deliverables] of Object.entries(subGroups)) {
                        const subRow = createTimelineRow(owner, deliverables, service);
                        groupWrapper.appendChild(subRow);
                    }
                    board.appendChild(groupWrapper);
                }
            } else {
                items.forEach(item => {
                    if (!groupedData[item.Objective]) groupedData[item.Objective] = {};
                    const subKey = item.ServiceArea || "General";
                    if (!groupedData[item.Objective][subKey]) groupedData[item.Objective][subKey] = [];
                    groupedData[item.Objective][subKey].push(item);
                });
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
                    <p>${item.Description || "No description provided."}</p>
                </div>
                <div class="detail-section">
                    <h4>Timeline</h4>
                    <p><strong>Start:</strong> ${item.StartDate} (${formatQuarter(item.StartDate)})</p>
                    <p><strong>Target:</strong> ${item.EndDate} (${formatQuarter(item.EndDate)})</p>
                </div>
                <div class="detail-section">
                    <h4>Progress Indicators</h4>
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
                    <p><strong>Owner:</strong> ${item.SubCategory}</p>
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

            fetchItemHistory(item).then(historyLogs => {
                const timelineBox = document.getElementById("history-timeline-box");
                if (historyLogs.length === 0) {
                    timelineBox.innerHTML = "<p style='color:var(--text-tertiary); font-size:0.85rem;'>No modification logs recorded.</p>";
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

        function buildFilterPanels() {
            const serviceFilterBox = document.getElementById("filter-service");
            const initiativeFilterBox = document.getElementById("filter-initiative");
            const statusFilterBox = document.getElementById("filter-status");

            const services = ["Devices and Applications", "Communication and Collaboration", "Colleague Services", "AI Enablement", "EST"];
            const initiatives = [...new Set(ROADMAP_ITEMS.map(item => item.BUInitiative))];
            const statuses = ["In Development", "Rolling Out", "Launched"];

            serviceFilterBox.innerHTML = "";
            services.forEach(s => {
                const label = document.createElement("label");
                label.className = "roadmap-checkbox-container";
                label.innerHTML = `<input type="checkbox" name="service-filter" value="${s}"><span class="roadmap-checkbox-box"></span><span class="roadmap-checkbox-label">${s}</span>`;
                label.querySelector("input").addEventListener("change", (e) => {
                    if (e.target.checked) activeFilters.service.push(s);
                    else activeFilters.service = activeFilters.service.filter(item => item !== s);
                    renderViews();
                });
                serviceFilterBox.appendChild(label);
            });

            initiativeFilterBox.innerHTML = "";
            initiatives.forEach(i => {
                const label = document.createElement("label");
                label.className = "roadmap-checkbox-container";
                label.innerHTML = `<input type="checkbox" name="initiative-filter" value="${i}"><span class="roadmap-checkbox-box"></span><span class="roadmap-checkbox-label">${i}</span>`;
                label.querySelector("input").addEventListener("change", (e) => {
                    if (e.target.checked) activeFilters.initiative.push(i);
                    else activeFilters.initiative = activeFilters.initiative.filter(item => item !== i);
                    renderViews();
                });
                initiativeFilterBox.appendChild(label);
            });

            statusFilterBox.innerHTML = "";
            statuses.forEach(st => {
                const label = document.createElement("label");
                label.className = "roadmap-checkbox-container";
                label.innerHTML = `<input type="checkbox" name="status-filter" value="${st}"><span class="roadmap-checkbox-box"></span><span class="roadmap-checkbox-label">${st}</span>`;
                label.querySelector("input").addEventListener("change", (e) => {
                    if (e.target.checked) activeFilters.status.push(st);
                    else activeFilters.status = activeFilters.status.filter(item => item !== st);
                    renderViews();
                });
                statusFilterBox.appendChild(label);
            });
        }

        function renderViews() {
            if (currentView === 'list') {
                renderListView();
            } else {
                renderTimelineView();
            }
        }

        // Helpers
        function getJiraKey(url) {
            if (!url) return "Jira Ticket";
            try {
                const parts = url.trim().split('/');
                const key = parts[parts.length - 1];
                return key && key.includes('-') ? key : "Jira Link";
            } catch(e) { return "Jira Link"; }
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

        // Startup listeners
        document.addEventListener("DOMContentLoaded", () => {
            fetchRoadmapData().then(items => {
                ROADMAP_ITEMS = items;
                buildFilterPanels();
                renderViews();
            });

            document.getElementById("roadmap-search").addEventListener("input", (e) => {
                searchTerm = e.target.value;
                renderViews();
            });

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

            document.querySelectorAll("input[name='timeline-group']").forEach(radio => {
                radio.addEventListener("change", (e) => {
                    timelineGroup = e.target.value;
                    renderTimelineView();
                });
            });

            document.getElementById("close-drawer").addEventListener("click", closeDrawer);
            document.getElementById("drawer-overlay").addEventListener("click", closeDrawer);

            document.getElementById("clear-filters").addEventListener("click", () => {
                document.querySelectorAll(".filter-sidebar input[type='checkbox']").forEach(cb => cb.checked = false);
                activeFilters = { service: [], initiative: [], status: [] };
                renderViews();
            });

            const themeBtn = document.getElementById("theme-toggle");
            const sunIcon = themeBtn.querySelector(".sun-icon");
            const moonIcon = themeBtn.querySelector(".moon-icon");
            themeBtn.addEventListener("click", () => {
                document.body.classList.toggle("dark-theme");
                const isDark = document.body.classList.contains("dark-theme");
                sunIcon.style.display = isDark ? "block" : "none";
                moonIcon.style.display = isDark ? "none" : "block";
            });

            const addBtn = document.getElementById("add-item-btn");
            const modalOverlay = document.getElementById("modal-overlay");
            const closeModal = document.getElementById("close-modal");
            const cancelModalBtn = document.getElementById("cancel-form-btn");
            const addForm = document.getElementById("add-roadmap-form");

            addBtn.addEventListener("click", () => {
                modalOverlay.classList.add("active");
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
            modalOverlay.addEventListener("click", (e) => { if (e.target === modalOverlay) hideModal(); });

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
    </script>
</body>
</html>
