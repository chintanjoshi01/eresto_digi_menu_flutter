# Standalone eResto DigiMenu Application Walkthrough

We have completed the implementation of the standalone **eResto DigiMenu Management Application** located at `D:\Projects\Flutter\eresto_digi_menu_flutter`. The application is structured as an enterprise-grade MVVM codebase with strict separation of concerns, offline first data caching, and clean user experience designs aligned with the primary Edge host application.

---

## 1. Architectural File Mapping

The codebase enforces separation between the business logic and the view representations:

```
lib/
├── core/
│   ├── api/
│   │   ├── api_client.dart       # Dio HTTP Client with interceptors
│   │   ├── api_exception.dart    # Structured API exception model
│   │   └── endpoints.dart        # Endpoints registry
│   ├── services/
│   │   └── toast_service.dart    # Toastification alert wrappers
│   ├── storage/
│   │   ├── database_service.dart # Isar DB opening bootstrapping
│   │   ├── menu_collections.dart # Schemas for templates, sessions, items
│   │   └── storage_service.dart  # JWT and resto_id SharedPreferences
│   └── theme/
│       ├── app_colors.dart       # Seed colors aligned with parent POS app
│       ├── app_dimensions.dart   # Layout dimensions
│       ├── app_typography.dart   # Nunito typography font definitions
│       └── app_theme.dart        # ThemeData configurations
├── features/
│   ├── auth/
│   │   ├── bindings/             # Bindings registering repository & viewModel
│   │   ├── data/                 # Remote API datasource and persistence layers
│   │   ├── domain/               # AuthModel entity & AuthRepository interface
│   │   └── presentation/         # LoginController state and LoginScreen view
│   ├── dashboard/
│   │   ├── bindings/             # Bindings registering repository & viewModel
│   │   ├── data/                 # Analytics DB caches & api fetches
│   │   ├── domain/               # DashboardModel entities
│   │   └── presentation/         # Charting widgets & DashboardScreen view
│   ├── items/
│   │   ├── bindings/             # Bindings registering repository & viewModel
│   │   ├── data/                 # Items local database queries & updates
│   │   ├── domain/               # ItemModel entities & ItemsRepository
│   │   └── presentation/         # ItemCards, ItemEditSheet, and ItemsScreen views
│   ├── menu/
│   │   ├── bindings/             # Bindings registering repository & viewModel
│   │   ├── data/                 # Session details & Theme configurations
│   │   ├── domain/               # Models representing templates & active sessions
│   │   └── presentation/         # ThemePickerSheet, SessionEditSheet, and MenuScreen
│   └── share/
│       ├── bindings/             # Bindings registering share controller
│       └── presentation/         # PDF generator & ShareScreen view
└── main.dart                     # Application initialization entry point
```

---

## 2. Key Implementations

### A. Authentication
- Implemented `AuthRepository` with functional error wrapping using Dartz's `Either`.
- Successful logins store the operator's JWT token and Restaurant ID locally in `StorageService` using `shared_preferences`.
- Automatically redirects from boot to `/dashboard` if a valid active session is cached.

### B. Dashboard & Analytics
- Beautifully renders scan trends using a customized cubic curve `LineChart` from `fl_chart`.
- Incorporates dynamic period indicators ("Today", "This Week", "This Month") that automatically fetch and refresh data.
- Overview metrics track total categories, published items, and active session overrides.

### C. Menu Items
- Features search debounce matching and dynamically generated horizontal category filters.
- Implements optimistic UI updates for item availability toggles (reverts status automatically with a toast notification if the API patch fails).
- Built-in `ItemEditSheet` providing responsive validation inputs (e.g. positive pricing limits, mandatory titles) and local image picking.

### D. Menu Configurator
- Template Themes configures primary brand hex color palettes, typography styling, and dynamic previews.
- Sessions Schedules configures startTime/endTime intervals and interactive campaign descriptions.
- "Publish Live" synchronizes local draft configurations to the cloud server.

### E. Share & Flyer printings
- Renders high-quality QR codes inside a `RepaintBoundary`.
- Generates print-ready PDF flyers on-the-fly using `pdf` layout builders.
- Native sharing triggers `share_plus` options using cached image files.

---

## 3. Compilation & Verification Results

We verified compiling dependencies and static analysis:
- **Code Generation (`build_runner`)**: Generated Isar database mappings and Freezed models successfully.
- **Static Analysis (`flutter analyze`)**: The project compiles cleanly with **0 errors** and **0 warnings**.
