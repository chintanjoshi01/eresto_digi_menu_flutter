---
name: brand-kit-creator
description: >-
  Standardized workflow to build a complete application brand kit, vector/raster logo assets, brand guidelines documentation, design system theme tokens (colors & typography), native/animated splash screens, and audit app UI for brand compliance. Use when creating a brand package, establishing brand identity guidelines, or updating app themes for Flutter, Web, or Mobile.
---

# Brand Kit Creator Skill

This skill provides a comprehensive, step-by-step workflow for extracting brand requirements, generating a standardized `brand_package/` directory with production-ready vector and high-res raster assets, creating brand guidelines documentation, and integrating brand tokens into any codebase.

---

## Workflow Overview

```
1. Brand Discovery & Spec Definition
   └─ Color Palette (HEX, RGB)
   └─ Typography Hierarchy & Typeface Selection
   └─ Monograms, Icons & Taglines

2. Brand Package Asset Generation (`brand_package/`)
   ├─ 01_Master_Logo/            (Full-color horizontal SVG + PNG)
   ├─ 02_White_Version/          (White & White-Accent SVG + PNG)
   ├─ 03_Monochrome/             (Black & Charcoal Monochrome SVG + PNG)
   ├─ 04_Icons/                  (App Icon, E Monogram, Feature Icons)
   ├─ 05_Alternate_Layouts/      (Stacked Vertical Logo SVG + PNG)
   └─ 06_Brand_Guidelines/       (BRAND_GUIDELINES.md & Colour_Codes.txt)

3. Codebase Theme & Design System Integration
   ├─ Color Tokens & Palette (`app_colors.dart` / CSS variables)
   ├─ Typography Token Scale (`app_typography.dart` / font styles)
   ├─ Native Splash Screens (Android XML / iOS Storyboard / Web manifest)
   └─ In-App Animated Splash Sequence

4. UI Audit & Refactoring
   ├─ Standardize font weights (Light, Regular, Medium, SemiBold, Bold)
   ├─ Replace ad-hoc hex colors with brand theme constants
   └─ Audit navigation bars, headers, cards, dialogs & buttons

5. Verification & Quality Assurance
   └─ Run compiler/linter checks (0 errors, 0 warnings, 0 lints)
```

---

## Phase 1: Brand Discovery & Specification

1. **Extract Core Colors**:
   - **Primary Brand Color**: Dominant brand accent (e.g., `#D32F2F` / `rgb(211, 47, 47)`).
   - **Secondary / Charcoal**: Dark contrast element (e.g., `#424242` / `rgb(66, 66, 66)`).
   - **Cool Neutral / Muted Gray**: Secondary text & borders (e.g., `#9E9E9E` / `rgb(158, 158, 158)`).
   - **Light Background**: Clean neutral background (e.g., `#F9F9F9` / `rgb(249, 249, 249)`).
2. **Define Typography Hierarchy**:
   - **Primary Typeface**: Modern geometric sans-serif (e.g., Poppins, Inter, Roboto).
   - **Weight Scale**:
     - Light (`w300`): Subtitles, subtle captions.
     - Regular (`w400`): Body text, form fields.
     - Medium (`w500`): Section headers, button labels, tab titles.
     - SemiBold (`w600`): Card titles, prominent metrics.
     - Bold (`w700`): Hero titles, main header brand text.
3. **Identify Key Brand Elements**:
   - App Display Name & Master Taglines.
   - Primary Monogram / App Icon emblem.
   - Clear space boundaries (minimum padding around logo = height of emblem 'X').

---

## Phase 2: Brand Package Generation (`brand_package/`)

Create the standardized `brand_package/` directory in the project root:

```text
brand_package/
├── 00_Brand_Package_Showcase.png              # High-resolution visual overview sheet
├── BRAND_GUIDELINES.md                         # Complete brand identity, clear space & typography guide
├── README.md                                   # Quick directory index & color reference
├── README.txt                                  # Plaintext quick reference
│
├── 01_Master_Logo/
│   ├── app_logo_master_horizontal.svg          # Master full-color horizontal vector
│   └── app_logo_master_horizontal.png          # 2400×600 transparent master PNG
│
├── 02_White_Version/
│   ├── app_logo_white.svg                      # 100% white vector for dark backgrounds
│   ├── app_logo_white.png                      # Transparent white PNG
│   ├── app_logo_white_accent.svg               # White wordmark + accent color emblem
│   └── app_logo_white_accent.png               # White + accent PNG
│
├── 03_Monochrome/
│   ├── app_logo_black.svg                      # 100% pure black vector (print/receipts)
│   ├── app_logo_black.png                      # 100% black PNG
│   ├── app_logo_monochrome.svg                 # Charcoal + Gray monochrome vector
│   └── app_logo_monochrome.png                 # Monochrome PNG
│
├── 04_Icons/
│   ├── app_icon.svg                            # Squircle app icon vector (Android 12+ safe)
│   ├── app_icon.png                            # 1024×1024 master app icon PNG
│   ├── app_monogram.svg                        # Lettermark / monogram vector
│   └── app_feature_icon.svg                    # Secondary feature emblem vector
│
├── 05_Alternate_Layouts/
│   ├── app_logo_stacked.svg                    # Vertical stacked logo with taglines vector
│   ├── app_logo_stacked.png                    # 1200×1200 stacked PNG
│   ├── app_logo_stacked_white.svg              # Vertical stacked white on dark vector
│   └── app_logo_stacked_white.png              # 1200×1200 stacked white PNG
│
└── 06_Brand_Guidelines/
    ├── Colour_Codes.txt                       # Quick copy-paste color codes (HEX, RGB)
    └── App_Brand_Guidelines.pdf               # Print-ready official Brand Guidelines PDF
```

### Guidelines Document Template (`BRAND_GUIDELINES.md`)
Include clear sections in `BRAND_GUIDELINES.md`:
- **Core Identity**: Mission statement, tagline, visual personality.
- **Logo Variations**: Usage rules for Master, White, Monochrome, and Stacked versions.
- **Clear Space & Minimum Sizes**: Minimum height specifications (e.g., 24px digital, 10mm print).
- **Color Specifications**: Primary, Secondary, Neutral HEX, RGB, HSL values.
- **Typography Rules**: Typeface download link, font size scale, and explicit line height ratios.
- **Do's & Don'ts**: Prohibited distortions, wrong background choices, or improper font weight usage.

---

## Phase 3: Codebase Theme & Design System Integration

### 1. Color Palette Tokens
Define centralized color constants (e.g., `AppColors` in Flutter or CSS variables in Web):

```dart
class AppColors {
  static const Color primary = Color(0xFFD32F2F);
  static const Color secondary = Color(0xFF424242);
  static const Color neutralGray = Color(0xFF9E9E9E);
  static const Color background = Color(0xFFF9F9F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
}
```

### 2. Typography Token Scale
Implement strict font weight mapping (using Poppins or chosen typeface):

```dart
class AppTypography {
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700, // Bold
    fontSize: 32,
    height: 1.2,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 18,
    height: 1.3,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400, // Regular
    fontSize: 14,
    height: 1.5,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500, // Medium
    fontSize: 12,
  );
}
```

### 3. Native & Animated Splash Screens
1. **Native Launch Background (Android/iOS)**:
   - Configure native drawable XMLs (`launch_background.xml` for Android v21+) to display the brand logo or monogram centered on background color.
2. **In-App Animated Splash Sequence**:
   - Create a smooth entrance screen featuring logo scaling, fade transition, and brand progress indicator during app warmup.

---

## Phase 4: UI Audit & Brand Alignment Refactoring

Conduct a systematic audit across all screens:
1. **Headers & Navigation Bars**: Ensure consistent top bar styling, brand emblem alignment, and theme text colors.
2. **Card & Container Styling**: Replace harsh shadows or saturated backgrounds with clean neutral surfaces, rounded corners (e.g., 12px/16px radius), and brand accent borders.
3. **Buttons & Inputs**: Apply primary brand color to primary call-to-action buttons; use outline/ghost styles for secondary actions.
4. **Font Weight Audit**: Eliminate indiscriminate use of `FontWeight.bold` on body/label elements. Reserve bold for main section titles and key hero callouts.

---

## Phase 5: Verification & Quality Check

Run full project diagnostics:
- **Flutter**: `flutter analyze`
- **Web**: `npm run lint` / `npm run build`
- **Android/iOS**: Build check (`flutter build apk --dry-run` or platform equivalent)

**Completion Criteria**:
- [ ] 0 errors, 0 warnings, 0 lints.
- [ ] `brand_package/` directory present with all vector (`.svg`) & raster (`.png`) assets.
- [ ] `BRAND_GUIDELINES.md` and color reference text files populated.
- [ ] App color & typography design system unified under single token source.
- [ ] Native & animated splash screen implemented and verified.
