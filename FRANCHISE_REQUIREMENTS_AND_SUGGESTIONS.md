# eResto Franchise Digital Menu: Complete Strategy & Screen Specifications

> **Target Role:** B2B Franchise Buyer / Multi-Unit Restaurant Owner  
> **Engineering Scope:** Flutter & Web Digital Menu Platform (`eresto_digi_menu_flutter`)  
> **Key Focus:** Multi-Outlet Menu Governance, Dayparting, Scan Analytics, Table QR Generation  
> *(Strictly excludes inventory, stock, and ERP complexity)*

---

## PART 1: The Franchise Owner Mindset (The Customer Who Buys Our Product)

A franchise owner (operating 5 to 50+ restaurant or resort locations) evaluates our digital menu software based on **Brand Protection, Centralized Speed, and Network Visibility**.

```
                           ┌───────────────────────────┐
                           │   Franchise Brand Owner   │
                           │     (The B2B Buyer)       │
                           └─────────────┬─────────────┘
                                         │
                 ┌───────────────────────┼───────────────────────┐
                 ▼                       ▼                       ▼
      ┌────────────────────┐  ┌────────────────────┐  ┌────────────────────┐
      │  Brand Governance  │  │  Central Agility   │  │ Network Visibility │
      │  • Locked HD Media │  │  • 1-Click Push    │  │ • Live Scan Velocity│
      │  • Standard Recipes│  │  • Regional Pricing│  │ • Table Adoption   │
      │  • Verified Badges │  │  • Auto Dayparting │  │ • Branch Ranking   │
      └────────────────────┘  └────────────────────┘  └────────────────────┘
```

### 1. What Problems Does the Franchise Owner Face?
1. **Uncontrolled Menu Changes by Branches:**
   If a local store manager uploads low-res photos, misspells dish names, or removes allergen badges (Veg, Jain, Halal), it damages the entire brand.
   * **Our Solution:** HQ locks the Master Catalog (Photos, Names, Descriptions, Badges). Outlets only control daily availability.
2. **Slow Seasonal Menu Rollouts:**
   Launching a festive menu (e.g., Summer Coolers or Festive Specials) across 20 outlets currently takes days of manual work.
   * **Our Solution:** 1-Click Central Push from HQ to all selected branches instantly.
3. **Multi-Tier Regional Pricing:**
   An airport or luxury resort outlet has higher pricing than a highway or small-town outlet.
   * **Our Solution:** Centralized Pricing Tiers (Metro vs. Tier-2 vs. Express) managed without duplicating menus.
4. **Physical QR Code Adoption Blind Spots:**
   Franchise owners do not know if staff at Branch X are actually putting QR stands on dining tables.
   * **Our Solution:** Scan velocity tracking, branch leaderboards, and zero-scan rush hour alerts.
5. **Instant Live Menu Verification (WYSIWYG):**
   Owners need to see exactly what a guest at Table 12 in their Goa branch sees on their phone right now.
   * **Our Solution:** Persistent interactive mobile simulator with outlet and session switchers.

---

## PART 2: UI/UX Redesign Blueprint for Your Current Screens

---

### SCREEN 1: Chain Overview (Multi-Property Dashboard)

#### Current Observations (From Screenshot 1):
* **Row Bloat:** Each property row expands vertically because all sub-menus (`Dine In`, `Ird`, `Cat2`, `Cat3`...) are rendered as individual card blocks inside the table cell. For 20+ outlets, this causes massive vertical fatigue.
* **Technical Labels:** Showing raw database labels like `Cat2`, `Cat3`, `Cat4`, `Cat5`, `Cat6` instead of customer-facing concepts like *Poolside Bar*, *Lounge*, or *In-Room Dining*.
* **Missing Search & Filters:** No search bar, city/cluster filters, or sorting controls.

#### The Enterprise Redesign:

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│  eresto Chain                                                     [Search property...] [All Cities ▼] [+ Add] │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  [Total Properties: 4]     [Active Menus: 9]     [Master Dishes: 550]     [Today's Scans: 4,820 (+14%)]       │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  Property Name          Live Menus               Catalog        Today's Scans   Compliance   Status   Actions│
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  VRG Resorts            [Dine-In] [IRD] [Bar]    546 items      1,240 scans     ● 100%       [Active] [Manage]│
│  Anurag POS Resto       [Dine-In]                136 items        412 scans     ⚠️ 1 pending  [Active] [Manage]│
│  VRNT DEMO Resorts      [No live menus]            0 items          0 scans     ⚠️ 4 pending  [Inactive][Setup]│
│  Anurag Cafe Demo       [Dine-In] [Takeaway]     127 items        890 scans     ● 100%       [Active] [Manage]│
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

#### Key Improvements:
1. **1 Property = 1 Compact Row:** Clean, high-density row with status badges for active menus.
2. **Quick Search & Filter Bar:** Instant search by property name, city, and active/inactive status.
3. **Operational Compliance Indicator:** Shows brand completeness score (e.g., `● 100% Compliant` or `⚠️ 1 required pending`) to ensure brand guidelines are met before going live.
4. **Contextual Action Buttons:** Direct shortcuts to `[Manage Menu]`, `[View Analytics]`, and `[Download QR Pack]`.

---

### SCREENS 2 & 3: Single Property Drilldown & Live Simulator

#### Current Observations (From Screenshots 2 & 3):
* **Vertical Stacking Conflict:** Scans chart, Menu items list, and Profile details are stacked vertically in one long column, causing an awkward scrolling experience while the live mobile preview sits pinned on the right.
* **Isolated Mobile Preview:** The mobile simulator does not have an easy switch to change between sessions (*Breakfast*, *Lunch*, *Dinner*, *Bar*) directly on the phone bezel.

#### The Enterprise Redesign (Tabbed Left Panel + Persistent Right Simulator):

```
┌─────────────────────────────────────────────────────────────┬───────────────────────────────┐
│  All Properties / VRG Resorts                  [Active ●]   │      GUEST VIEW SIMULATOR     │
├─────────────────────────────────────────────────────────────┤  ┌─────────────────────────┐  │
│  [ Tab 1: Scans & Insights ]  [ Tab 2: Menu & Sessions ]    │  │ [ Dine In: Breakfast ▼ ]│  │
│  [ Tab 3: Pricing Tiers    ]  [ Tab 4: Table QR Codes  ]    │  │ ─────────────────────── │  │
│                                                             │  │      VRG Resorts        │  │
│  ── Active Tab: Menu & Sessions ──────────────────────────  │  │  [ Search Menu...     ] │  │
│                                                             │  │ ┌─────────────────────┐ │  │
│  Current Live Session: Breakfast (07:30 AM - 10:30 AM)      │  │ │ Hero Banner         │ │  │
│  Next Upcoming:        Lunch Buffet (12:00 PM - 03:30 PM)   │  │ └─────────────────────┘ │  │
│                                                             │  │ [Veg] [Non-Veg] [Jain]  │  │
│  Categories in this Session:                                │  │                         │  │
│  • South Indian Breakfast (14 items)  [Active ●]  [Edit]    │  │ • Puri Bhaji     ₹80    │  │
│  • Fresh Juices & Shakes   (8 items)  [Active ●]  [Edit]    │  │ • Chivas Regal   ₹725   │  │
│  • Morning Bakery          (12 items) [Active ●]  [Edit]    │  │ • Budweiser      ₹390   │  │
│                                                             │  └─────────────────────────┘  │
│  [+ Add Category to Session]     [Sync with Master Catalog] │   [Open Live URL in New Tab]  │
└─────────────────────────────────────────────────────────────┴───────────────────────────────┘
```

#### Key Improvements:
1. **Clean Tabbed Layout:** Replaces the endless vertical page with focused tabs:
   * **Tab 1: Scans & Insights:** 30-day interactive scan trend, peak rush hour heatmap, top 5 viewed items.
   * **Tab 2: Menu & Sessions:** Automated dayparting schedule (Breakfast, Lunch, Dinner) and category controls.
   * **Tab 3: Pricing Tiers & Overrides:** View current pricing tier (Metro/Regional) and outlet price adjustments.
   * **Tab 4: Table QR Generator:** Instant batch generation of Table 1–50 printable vector PDF sheets.
   * **Tab 5: Outlet Info:** Address, Google Maps link, Wi-Fi details, and WhatsApp ordering number.
2. **Interactive Phone Simulator:** Top dropdown right on the phone frame allows the owner to test how the menu looks across different sessions (e.g., switch from *Breakfast* to *Bar Menu*).

---

## PART 3: Professional Dev Team Architecture (Flutter Conversion)

To support this cleanly in `eresto_digi_menu_flutter`, we map existing single-restaurant controllers and widgets to a multi-tenant hierarchy:

```
[Brand / Franchise Account]
  ├── Brand Assets (Logo, Typography, Primary Palette, Hero Banners)
  ├── Pricing Tiers (Metro Tier, Regional Tier, Airport Tier)
  │
  ├── [Master Catalog Studio]
  │     ├── Dish Name, 4K Photography, Chef's Description
  │     ├── Dietary Badges (Veg, Non-Veg, Jain, Halal, Vegan)
  │     └── Tiered Prices (Metro: ₹380, Regional: ₹320, Airport: ₹450)
  │
  └── [Outlets / Properties]
        ├── Outlet Details (VRG Resorts, Anurag POS Resto)
        ├── Assigned Pricing Tier
        ├── Automated Daypart Sessions (Breakfast, Lunch, Dinner)
        └── Local Activation Toggle (`is_live: true/false`)
```

### Conversion Mapping in Existing Codebase:

| Existing Single-Store Component | File Path | Enterprise Franchise Transformation |
| :--- | :--- | :--- |
| **Hero Banner** | `lib/features/dashboard/presentation/widgets/dashboard_hero_card.dart` | **Franchise Aggregated Banner:** Displays chain-wide totals (Total Properties, Live Menus, Master Items, Today's Chain Scans) + outlet selector. |
| **Scan Analytics** | `lib/features/dashboard/presentation/widgets/qr_scan_analytics_card.dart` | **Multi-Unit Scan Analytics:** Switch between "All Properties" and individual outlet drilldown + peak rush hour heatmap. |
| **Active Sessions** | `lib/features/dashboard/presentation/widgets/active_session_grid.dart` | **Automated Dayparting Engine:** Auto-switches sessions based on clock time (Breakfast $\rightarrow$ Lunch $\rightarrow$ Dinner) across all branches. |
| **Item Management** | `lib/features/menu/presentation/views/manage_items_screen.dart` | **Master Catalog Studio:** Add/edit master dishes centrally, set pricing tiers, and push to outlets with 1 click. |
| **QR Code Sharing** | `lib/features/dashboard/presentation/widgets/menu_urls_bottom_sheet.dart` | **Batch Table QR Exporter:** Generates print-ready vector PDF sheets for Tables 1 to 50 with brand logos. |

---

## PART 4: Summary of Franchise Owner Capabilities (No Stock Complexity)

| Area | What the Franchise Owner Can Do |
| :--- | :--- |
| **Central Publishing** | Update a dish description or photo once $\rightarrow$ Pushes to all 20 outlets in 1 click. |
| **Regional Pricing** | Maintain different pricing for Metro vs. Highway outlets from a central tier table. |
| **Brand Protection** | Lock photos, names, and allergens so store managers cannot alter brand standards. |
| **Local Flexibility** | Branch managers can toggle dishes on/off based on daily operational availability. |
| **Dayparting** | Menus automatically switch by time of day (Breakfast, Lunch, Dinner, Late Night Bar). |
| **Table QRs** | Export batch table QR codes (Tables 1–50) formatted for physical acrylic table stands. |
| **Chain Intelligence** | Compare scans across branches, view peak rush hours, and see what guests search for. |
