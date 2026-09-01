# 🍽️ eResto DigiMenu Management Application

A high-performance, enterprise-grade Flutter application built for digital restaurant menu management, analytics, and session scheduling. Designed with strict **MVVM Clean Architecture**, **GetX State Management**, **Isar NoSQL Offline Caching**, and custom **Canvas Animations**.

---

## 🌟 Highlights & Enterprise Features

- **🔐 Enterprise Authentication**: Custom canvas painter `BrandProgressIndicator` with staggered micro-animations and session state persistence (`shared_preferences`).
- **📊 Real-time Scan Analytics**: Interactive menu scan trend visualization powered by `fl_chart` with dynamic period selectors (*Today*, *This Week*, *This Month*).
- **🍕 Menu Items Management**: Optimistic UI toggles for dish availability, multi-category filters, search query debouncing, and an interactive item editor sheet.
- **🎨 Theme & Session Configurator**: Live primary color palette customization, custom font styling previews, and automated session schedule overrides.
- **📱 QR Code & PDF Flyer Publishing**: RepaintBoundary vector QR code generation, instant native sharing (`share_plus`), and print-ready PDF flyer layout builders (`pdf` & `printing`).
- **⚡ Offline-First Architecture**: Dual local database caching (`Isar`) with 5-minute TTL invalidation and automatic offline fallback mechanisms.

---

## 🏗️ Architecture & Tech Stack

```
lib/
├── core/
│   ├── api/          # Dio REST Client with Authorization Interceptors
│   ├── services/     # Toastification & Alert Services
│   ├── storage/      # Isar Database & SharedPreferences
│   ├── theme/        # App Colors, Typography (Nunito), Dimensions & Theme
│   └── widgets/      # BrandProgressIndicator custom canvas painters
├── features/
│   ├── auth/         # Login ViewModel, Models & Views
│   ├── dashboard/    # Analytics Repositories, Charting Widgets & Screen
│   ├── items/        # Menu Items Caches, Edit Sheet & Grid Views
│   ├── menu/         # Theme Customizer, Session Edit Sheet & View
│   └── share/        # QR Generator, PDF Builder & Share View
└── main.dart         # GetX Route Registrar & App Entry Point
```

### Key Libraries
- **State Management & DI**: `GetX ^4.6.6`
- **Database & Local Cache**: `Isar ^3.1.0`
- **Networking**: `Dio ^5.7.0`
- **Functional Utilities**: `Dartz ^0.10.1` & `Freezed ^2.5.2`
- **UI & Analytics**: `fl_chart ^0.69.0`, `flutter_screenutil ^5.9.0`, `google_fonts ^6.1.0`
- **Sharing & PDF**: `qr_flutter ^4.1.0`, `pdf ^3.11.1`, `printing ^5.13.2`, `share_plus ^7.2.2`

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: `>=3.24.0`
- **Dart SDK**: `>=3.2.0 <4.0.0`
- **Android Studio / Java**: JDK 17

### Installation & Run

1. **Clone the repository**:
   ```bash
   git clone https://github.com/chintanjoshi01/eresto_digi_menu_flutter.git
   cd eresto_digi_menu_flutter
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run code generation**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Launch Application**:
   ```bash
   flutter run
   ```

---

## 📄 License

Copyright © 2026 eResto. All rights reserved.
