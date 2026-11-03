# eResto DigiMenu (`eresto_menu`)

**Enterprise Digital Restaurant Menu Management, Analytics, Session Scheduling, QR Studio & Vector PDF Publishing Suite**  
Built with Flutter, GetX, and Isar NoSQL Offline Caching, powered by the **eResto Plus V6 Digital Menu Platform (`/api/v6`)**.

---

## Overview

**eResto DigiMenu** empowers restaurants and multi-outlet franchises to manage live digital menus, dish availability, pricing & portions, dietary/allergen tags, time-based menu sessions, dynamic themes, table QR codes, and print-ready vector PDF menus in real time.

| Property | Value |
| :--- | :--- |
| **Package Name** | `eresto_menu` (`in.eresto.digimenu`) |
| **Current Version** | `1.1.7+16` |
| **API Platform** | eResto Plus V6 Digital Menu API (`/api/v6`) |
| **State Management** | GetX (`get: ^4.6.6`) + Clean Architecture (Data / Domain / Presentation) |
| **Local Database** | Isar NoSQL (`isar: ^3.1.0`) with Android 15+ **16 KB Memory Page Size (`0x4000`)** native binaries |
| **Supported Platforms** | Android (API 24+, 16 KB page-aligned), iOS, Web, Desktop |

---

## Core Modules & Enterprise Features

### 1. Authentication & V6 Master Data Sync (`lib/features/auth`)
- **V6 Authentication** (`POST /api/v6/login`) with AES/SHA encryption helpers, device metadata, and session persistence via `StorageService`.
- **Master Sync Engine** (`GET /api/v6/get_login_sync_data`): Synchronizes kitchen categories, sales categories, dietary tags, tax groups, and outlet profile (`resto_info`) on login.
- **Custom Canvas Micro-Animations**: `BrandProgressIndicator` custom painter and responsive login layout for phones and tablets.

### 2. Real-Time Scan Analytics & Dashboard (`lib/features/dashboard`)
- **Live Dashboard Metrics** (`GET /api/v6/get_dashboard_data`): Total Menu Scans, Active Dishes, Active Templates, and Live Sessions.
- **Interactive Scan Trend Charts**: Powered by `fl_chart` with dynamic date range filters (*Today*, *This Week*, *This Month*).
- **Firebase Crashlytics & Push Notifications**: Integrated with `firebase_core`, `firebase_crashlytics`, and `firebase_messaging`.

### 3. Menu Items & Dish Catalog Management (`lib/features/items`)
- **Dual Layout Modes**: Switch seamlessly between **Grid View** (`ItemCard`) and **List View** (`ItemRowCard`), displaying dietary tags (`SPICY`, `JAIN`, `VEGAN`), FSSAI/Starred badges (`⭐ Starred / FSSAI Only`), and portion quantities.
- **Instant Availability Toggles**: Optimistic UI updates via `POST /api/v6/menu/item/update-quick`.
- **Comprehensive Item Editor (`ItemEditSheet`)**:
  - Create (`POST /api/v6/menu/item/create`), update (`POST /api/v6/menu/item/update`), and delete (`POST /api/v6/menu/item/delete`) dishes.
  - Manage multi-portion variants, calories, ingredients, allergen tags, and explicit `Kitchen Category` / `Sales Category` assignments (including `"None (Unassigned)"` support).
  - High-performance dish image compression, cropping, and gallery upload (`POST /api/v6/menu/item/update-image`, `POST /api/v4/upload_resto_gallery_neo`).
- **Resilient Offline-First Caching**: Isar NoSQL collection caching (`ItemsRepositoryImpl`) with automatic corrupt-DB recovery and in-memory fallback.

### 4. Menu Builder, Themes & Automated Session Scheduling (`lib/features/menu`)
- **Dynamic Menu Templates** (`/api/v6/menu_builder/get_menu_builder_data`, `/get_menu_temp_list_neo`, `/get_menu_template`, `/update_template_items`).
- **Live Theme Customizer** (`/api/v6/menu_builder/get_themes`, `/change_theme`): Customize primary brand colors, backgrounds, and typography previews.
- **Session Scheduler (`SessionEditSheet`)** (`/api/v6/menu_builder/get_session`, `/update_session`): Configure automated time-of-day menu switching (e.g., *Breakfast*, *Lunch*, *Evening Snacks*, *Dinner*) with zero-padded 24-hour (`HH:mm`) timing and template mapping.
- **Terms & Conditions Master**: Full CRUD for menu footer terms (`/api/v6/terms/list`, `/details`, `/create`, `/update`, `/delete`).

### 5. Print-Ready Vector PDF Wizard & QR Flyer Studio (`lib/features/share`)
- **Multi-Step Print-Ready Menu PDF Engine**:
  - **Step 1 — Template Validation**: Select target menu template with mandatory step validation.
  - **Step 2 — Layout & Styling**: Choose between `Classic`, `Card`, and `Compact` layouts (`Single` or `Two Columns`), category banner styles (`Plain`, `Solid`, `Gradient`), background palettes (`White`, `Cream`, `Beige`, `Blush`, `Grey`), header alignment, and typography casing (`Normal`, `UPPERCASE`, `Capitalize`).
  - **Step 3 — Content Toggles**: Toggle `Portions/Variants`, `Calories`, `Descriptions`, `Ingredients`, `Allergens/Dietary Tags`, dynamic `resto_info` header details, and `Terms & Conditions`.
- **QR Code & Table Flyer Publishing**:
  - Branded vector QR code rendering (`qr_flutter`), table-wise QR ZIP download (`/api/v6/dwn_tbl_qr_zip`), digital menu link sharing (`share_plus`), and direct printing (`printing`).

---

## Project Architecture

```text
lib/
├── core/
│   ├── api/                 # Dio ApiClient, interceptors, & V6 Endpoints
│   ├── errors/              # Functional Failure types (Dartz Either) & AppErrorType
│   ├── models/              # V6 login sync & shared domain models
│   ├── services/            # Device, Encryption, FCM, Logger, Toast, & Update services
│   ├── storage/             # Isar DatabaseService, MenuCollections, & SharedPreferences
│   ├── theme/               # AppColors, Nunito Typography, Dimensions, & Material 3 Theme
│   └── widgets/             # BrandProgressIndicator, ErestoTopHeader, AppBottomNav, Dialogs
├── features/
│   ├── auth/                # V6 Login controller, bindings, & responsive login views
│   ├── dashboard/           # Scan analytics repository, fl_chart widgets, & dashboard screen
│   ├── items/               # Menu items repository, Isar cache, ItemCard, & ItemEditSheet
│   ├── main/                # Main navigation shell & keep-alive tab wrapper
│   ├── menu/                # Menu builder, theme selector, SessionEditSheet, & T&C manager
│   ├── profile/             # Outlet profile, settings, & secure session logout
│   └── share/               # Vector PDF Wizard, QR flyer generator, & share screen
└── main.dart                # Application entry point, Firebase & Isar initialization
```

---

## API v6 Endpoints Summary

| Module | Endpoint | Description |
| :--- | :--- | :--- |
| **Auth & Sync** | `POST /api/v6/login` | Authenticate outlet user & retrieve token |
| | `GET /api/v6/get_login_sync_data` | Fetch master categories, tags, & outlet config |
| **Dashboard** | `GET /api/v6/get_dashboard_data` | Fetch scan analytics, KPIs, & active sessions |
| **Menu Items** | `GET /api/v6/menu/items` | List all menu items with categories & variants |
| | `GET /api/v6/menu/item/details` | Fetch full details for a single dish |
| | `POST /api/v6/menu/item/create` | Create a new menu dish |
| | `POST /api/v6/menu/item/update` | Update dish details, pricing, & categories |
| | `POST /api/v6/menu/item/update-quick` | Quick toggle dish availability / status |
| | `POST /api/v6/menu/item/update-image` | Upload or replace dish image |
| | `POST /api/v6/menu/item/delete` | Delete a menu dish |
| **Menu Builder** | `GET /api/v6/menu_builder/get_menu_builder_data` | Fetch templates, sessions, & builder state |
| | `POST /api/v6/menu_builder/change_theme` | Apply theme palette to active menu template |
| | `POST /api/v6/menu_builder/update_session` | Update session schedule & linked template |
| | `POST /api/v6/menu_builder/update_template_items` | Map/unmap dishes to a specific menu template |
| **Share & T&C** | `GET /api/v6/get_digital_menu_links` | Retrieve public QR links for digital menu |
| | `GET /api/v6/dwn_tbl_qr_zip` | Download table-wise QR code ZIP package |
| | `GET /api/v6/terms/list` | Manage restaurant Terms & Conditions |

---

## Getting Started

### Prerequisites
- **Flutter SDK**: `>=3.24.0` (Dart `>=3.2.0 <4.0.0`)
- **JDK**: Java 17
- **Android NDK**: `28.0.12674087` (configured for Android 15+ 16 KB page size alignment)

### Installation & Build

1. **Clone the repository**:
   ```bash
   git clone https://github.com/chintanjoshi01/eresto_digi_menu_flutter.git
   cd eresto_digi_menu_flutter
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run code generation (Freezed / JSON / Isar)**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the application**:
   ```bash
   flutter run
   ```

5. **Build release APK / AppBundle**:
   ```bash
   flutter build apk --release
   # or
   flutter build appbundle --release
   ```

---

## Latest Release Highlights (`v1.1.7+16`)

- **Google Play Policy & Android 15+ (16 KB Page Size) Compliance**:
  - Upgraded Android NDK to `r28` (`28.0.12674087`) with uncompressed 16 KB JNI alignment (`useLegacyPackaging = false`).
  - Bundled `0x4000` (16 KB) page-aligned `libisar.so` binaries across `arm64-v8a`, `armeabi-v7a`, `x86`, and `x86_64` in `android/isar_16kb_jniLibs`.
  - Hardened `DatabaseService` with automatic corrupt-DB recovery and `clearAll()` support on logout.
- **Multi-Page Vector PDF Menu Engine**:
  - Added Step 1 template validation (`"Select Menu Template"`), live `resto_info` restaurant header binding, and full multi-page vector PDF rendering across `Classic`, `Card`, and `Compact` layouts (`Single` & `Two Columns`).
- **Menu Sessions & Items QA Improvements**:
  - Responsive 2-column `MENU TEMPLATE` and `TIMING` cards with `HH:mm` 24-hour formatting.
  - Updated `"⭐ Starred / FSSAI Only"` filter pill, unified dietary tag + portion badges across Grid/List cards, and added explicit `"None (Unassigned)"` support for Kitchen & Sales categories in `ItemEditSheet`.

---

## License

Copyright © 2026 eResto / Restosoft Solutions. All rights reserved.
