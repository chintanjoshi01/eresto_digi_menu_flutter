# Enterprise Franchise Digital Menu: Product Blueprint & Migration Guide

> **Document Type:** Product Architecture & Engineering Strategy  
> **Target Audience:** Product Engineering Team & B2B Franchise Buyer  
> **Scope:** Multi-Unit Digital Menu Platform (Focusing on Menus, Dayparting, Pricing, QR Codes, and Chain Analytics — *Excluding Inventory/Stock Tracking*)

---

## Executive Overview

This document outlines the strategic transformation of the **eResto Digi Menu** single-restaurant Flutter application into an **Enterprise Multi-Unit Franchise Platform**. 

It balances two essential viewpoints:
1. **The B2B Franchise Owner (The Buyer):** Why they purchase our digital menu solution for their 10 to 100+ branches and what daily visibility/controls they demand.
2. **The Professional Development Team:** How we structurally evolve our existing Flutter codebase (`lib/features/`) to support multi-outlet inheritance, master menu governance, and chain-level analytics.

---

## 1. The B2B Customer Perspective: What Franchise Owners Need

When a multi-unit restaurant chain or franchise owner buys a digital menu product, they are purchasing **Brand Consistency, Rapid Menu Deployment, and Chain-Wide Visibility**.

```
                           ┌───────────────────────────┐
                           │   Franchise Brand Owner   │
                           │   (HQ Executive / CMO)    │
                           └─────────────┬─────────────┘
                                         │
                 ┌───────────────────────┼───────────────────────┐
                 ▼                       ▼                       ▼
      ┌────────────────────┐  ┌────────────────────┐  ┌────────────────────┐
      │  Brand Governance  │  │ Central Efficiency │  │ Network Visibility │
      │  • Locked HD Media │  │ • 1-Click Rollouts │  │ • Scan Analytics   │
      │  • Uniform Recipes │  │ • Pricing Tiers    │  │ • Table Adoption   │
      │  • Allergen Trust  │  │ • Dayparting Sync  │  │ • Outlet Ranking   │
      └────────────────────┘  └────────────────────┘  └────────────────────┘
```

### 1.1 Core Business Pain Points Solved
1. **Loss of Brand Integrity**:
   * *Problem:* When branch managers independently manage menus, they upload poor-quality photos, introduce spelling mistakes, or mislabel allergens (Veg, Jain, Halal, Gluten-Free).
   * *Solution:* HQ locks the Master Catalog (photos, dish descriptions, dietary badges). Outlets only control daily menu activation.
2. **Operational Delay in Menu Rollouts**:
   * *Problem:* Launching a seasonal festival menu (e.g., Summer Coolers or Diwali Special) across 25 locations takes days of repetitive manual data entry.
   * *Solution:* 1-Click Central Push. HQ publishes the menu once, and it activates across all designated outlets simultaneously.
3. **Regional Pricing Discrepancies**:
   * *Problem:* Outlets have different cost structures (e.g., an airport kiosk has higher overhead than a suburban outlet).
   * *Solution:* Central Pricing Tiers (Metro vs. Tier-2 vs. Airport) managed from one screen without cloning entire menus.
4. **Physical QR Blind Spots**:
   * *Problem:* Franchise owners rarely know whether local branch staff are actively putting QR stands on dining tables.
   * *Solution:* Real-time scan adoption metrics, zero-scan operational alerts, and batch table-wise QR code generators.
5. **Instant Live Verification (WYSIWYG)**:
   * *Problem:* The franchise owner cannot easily check what a guest in the Goa or Mumbai branch is seeing right now on their phone.
   * *Solution:* An interactive, persistent live mobile simulator built into the HQ dashboard.

---

## 2. Daily Operations & Key User Workflows

### 2.1 What the Franchise Owner Needs to See Every Morning (The HQ Dashboard)
* **Chain Footfall Velocity**: Aggregated today's scans vs. yesterday and the 7-day average across all properties.
* **Network QR Health & Anomaly Alerts**:
  * *Active Outlets*: Number of locations recording scans today.
  * *Inactive Alerts*: Flagging any outlet with 0 scans during their defined lunch or dinner rush hours.
* **Top & Bottom Outlet Leaderboard**: Instant comparison of branches by digital guest engagement.
* **Customer Search Terms**: Chain-wide log of what guests are searching for in the digital menu search bar (identifies unfulfilled demand such as *"Sugar-Free"*, *"Cold Brew"*, or *"Vegan"*).

### 2.2 What Operations the Franchise Owner Performs
* **Global Item Management**: Add a new signature dish to the Master Catalog with 4K photos and allergen tags.
* **Batch Outlet Publishing**: Choose which outlets serve the dish and apply the appropriate regional pricing tier.
* **Dayparting Configuration**: Set standardized session times (Breakfast, Lunch, High Tea, Dinner, Late Night Bar) that auto-switch by clock time at each branch.
* **Bulk Table QR Generation**: Export print-ready, branded vector PDF QR code stands for Tables 1 to 50 for any selected outlet in one click.

---

## 3. Data Architecture: Clean Multi-Tenant Model

To support multi-branch operations cleanly without introducing inventory/stock management, we use an **Inheritance-Based Catalog Architecture**:

```
[Brand / Franchise Account]
  ├── Brand Assets (Logo, Fonts, Colors, Social Links)
  ├── Pricing Tiers (Tier A: Metro, Tier B: Tier-2, Tier C: Airport)
  │
  ├── [Master Item Catalog]
  │     ├── item_id: "itm_paneer_tikka"
  │     ├── name: "Tandoori Paneer Tikka"
  │     ├── media_urls: ["https://cdn.eresto.com/..."]
  │     ├── dietary: [is_veg: true, is_jain_available: true]
  │     ├── description: "Charcoal grilled cottage cheese..."
  │     └── tier_prices: { "tier_metro": 380, "tier_regional": 320, "tier_airport": 450 }
  │
  └── [Outlets / Properties]
        ├── outlet_id: "out_vrg_resorts"
        ├── pricing_tier_id: "tier_metro"
        ├── active_sessions: [
        │     { session_id: "ses_breakfast", timing: "07:30 - 10:30", is_active: true },
        │     { session_id: "ses_dinner", timing: "19:00 - 23:30", is_active: true }
        │   ]
        └── outlet_item_overrides: {
              "itm_paneer_tikka": {
                 "is_live": true,          // Controlled by store manager
                 "custom_price_delta": 0   // Optional HQ approved adjustment
              }
            }
```

### Architectural Rules:
1. **Master Records are Immutable to Branch Staff**: Local outlet managers cannot rename dishes or change official photos.
2. **Availability is Local**: Outlets only toggle whether an item is currently served on their menu (`is_live: true/false`).
3. **No Stock Complexity**: We do not track ingredients, grams, or warehouse inventory. We strictly track **Digital Menu Visibility** and **Customer Engagement**.

---

## 4. Codebase Conversion Mapping (`eresto_digi_menu_flutter`)

Here is how our current single-restaurant Flutter features map directly to the enterprise franchise requirements:

| Existing Single-Restaurant Feature | Current Code File | Enterprise Franchise Transformation |
| :--- | :--- | :--- |
| **Dashboard Hero** | `lib/features/dashboard/presentation/widgets/dashboard_hero_card.dart` | **Franchise Aggregated Banner**: Displays chain-wide stats (Total Outlets, Live Menus, Master Items, Total Scans Today) + global outlet filter dropdown. |
| **Scan Analytics** | `lib/features/dashboard/presentation/widgets/qr_scan_analytics_card.dart` | **Multi-Unit Scan Analytics**: Allows toggling between *"All Outlets Combined"* and individual branch drill-downs, including branch leaderboard rankings and peak-hour heatmaps. |
| **Active Sessions** | `lib/features/dashboard/presentation/widgets/active_session_grid.dart` | **Automated Dayparting Engine**: Displays which sessions (Breakfast, Lunch, Dinner, IRD) are currently active across each property based on automated time schedules. |
| **Item Management** | `lib/features/menu/presentation/views/manage_items_screen.dart` | **Master Catalog Studio**: Add/edit master dishes centrally, set pricing tiers, and batch-assign dishes to specific branches with one tap. |
| **Menu View** | `lib/features/menu/presentation/views/menu_screen.dart` | **Outlet Menu Sync & Override**: View category trees per outlet with quick toggles to enable/disable items locally. |
| **QR Code Sharing** | `lib/features/dashboard/presentation/widgets/menu_urls_bottom_sheet.dart` | **Enterprise Table QR Exporter**: Generates table-wise QR codes in bulk (e.g., Tables 1–60) with print-ready vector PDF templates and dynamic redirection. |
| **Branding & Profile** | `lib/features/profile/` | **Two-Tier Brand Profile**: <br>1. *Brand Kit (HQ)*: Standard logo, typography, banner art, social links.<br>2. *Outlet Details (Branch)*: Address, Google Maps link, Wi-Fi details, local ordering WhatsApp number. |

---

## 5. UI/UX Redesign Blueprint (Based on Current Screenshots)

### 5.1 Screen 1: Chain Overview (Multi-Property Table)
* **The Current Issue:** Each property row expands vertically because all sub-menus (`Dine In`, `Ird`, `Cat2`, `Cat3`...) are rendered as individual card blocks inside the table cell. For a chain with 20+ outlets, this causes massive vertical fatigue.
* **The Redesign:**
  * **1 Property = 1 Compact Row**:
    * `Property Name & Location` (e.g., *VRG Resorts — Goa*)
    * `Menu Badges` (Clean chips: `Dine-In (Active)`, `Lounge Bar (Active)`, `In-Room Dining (Active)`)
    * `Total Items & Categories` (`546 items / 50 cats`)
    * `Today's Scans + Mini Trend` (`1,420 scans` with a 7-day green/red sparkline)
    * `Brand Compliance Indicator` (Progress badge: `100% Complete` or `⚠️ 2 fields pending`)
    * `Actions` (`[View Live Menu]`, `[Manage]`, `[QR Pack]`)
  * **Global Header Controls**: A search input by property name, a region/city filter dropdown, and a primary button `[+ Add New Property]`.

### 5.2 Screens 2 & 3: Single Property Drilldown & Live Simulator
* **The Current Issue:** The Scans chart, Menu items list, and Profile details are stacked vertically in a single scrollable column, causing an awkward scrolling experience alongside the fixed phone frame.
* **The Redesign:**
  * **Persistent Right Panel**: Keep the interactive phone simulator pinned on the right with a top dropdown inside the phone bezel to switch between menu sessions (*Dine-In*, *In-Room Dining*, *Lounge Bar*).
  * **Tabbed Left Panel**:
    * **Tab 1: Scans & Guest Insights** (Daily scan charts, peak rush hours, top 5 most viewed dishes).
    * **Tab 2: Sessions & Dayparting** (Timing schedules for Breakfast, Lunch, Dinner with auto-switch triggers).
    * **Tab 3: Menu Items & Categories** (Category tree with quick-toggle switches to turn dishes on/off).
    * **Tab 4: QR Codes & Tables** (Table QR code generator and downloadable PDF templates).
    * **Tab 5: Outlet Info** (Local address, Wi-Fi credentials, and branch phone numbers).

---

## 6. Development Phasing Roadmap

```
Phase 1: Multi-Property Navigation & Overview UI (Weeks 1 - 2)
├── Implement Chain Overview table with compact 1-row-per-outlet layout
├── Add outlet search, city filtering, and status badges
└── Introduce the Persistent Mobile Simulator on property detail view

Phase 2: Master Catalog & Multi-Tier Pricing (Weeks 3 - 4)
├── Build Brand Master Dish Studio (centralized photos, descriptions, tags)
├── Implement Pricing Tier model (Metro, Regional, Airport)
└── Add local outlet activation toggle (is_live flag)

Phase 3: Chain-Level Analytics & Batch QR Exporter (Weeks 5 - 6)
├── Aggregate chain scans, branch leaderboard, and zero-scan rush hour alerts
├── Customer search keyword logging (tracking guest search terms)
└── Batch Table QR generator with vector PDF export
```

---

*This blueprint establishes a scalable foundation for marketing eResto Digi Menu to enterprise restaurant franchises, giving brand owners total governance while keeping store-level operations fast and simple.*
