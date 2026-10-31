# ERESTO DIGIMENU — BRAND PACKAGE v2.0
## Official Brand Identity & Design System Guide

---

## 1. Brand Overview

**eResto DigiMenu** is an enterprise-grade digital dining and menu management application designed for modern restaurants, cloud kitchens, and hospitality venues.

This Brand Package consolidates all official visual assets, logos, color codes, typographic standards, and layout rules to ensure 100% brand consistency across digital products, mobile apps, point-of-sale systems, print collaterals, and marketing touchpoints.

---

## 2. Official Color Palette

| Color Name | Swatch | HEX | RGB | CMYK | Role & Usage |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Eresto Red** | ![#D32F2F](https://via.placeholder.com/15/D32F2F/000000?text=+) | `#D32F2F` | `211, 47, 47` | `0, 78, 78, 17` | Primary brand color, 'e' letter, 'DigiMenu' wordmark, light ® trademark badge |
| **Charcoal Gray** | ![#424242](https://via.placeholder.com/15/424242/000000?text=+) | `#424242` | `66, 66, 66` | `0, 0, 0, 74` | 'resto' wordmark body, primary text, dark card headings |
| **Cool Gray** | ![#9E9E9E](https://via.placeholder.com/15/9E9E9E/000000?text=+) | `#9E9E9E` | `158, 158, 158` | `0, 0, 0, 38` | Secondary text, borders, dividers, subtle tags |
| **Light Background** | ![#F9F9F9](https://via.placeholder.com/15/F9F9F9/000000?text=+) | `#F9F9F9` | `249, 249, 249` | `0, 0, 0, 2` | App screen backgrounds, light card fills, surface tint |
| **Dark Neutral** | ![#212121](https://via.placeholder.com/15/212121/000000?text=+) | `#212121` | `33, 33, 33` | `0, 0, 0, 87` | Dark mode surfaces, dark backdrops |
| **Pure White** | ![#FFFFFF](https://via.placeholder.com/15/FFFFFF/000000?text=+) | `#FFFFFF` | `255, 255, 255` | `0, 0, 0, 0` | Official App Icon squircle background, card surfaces, white reverse logos |

---

## 3. Typographic Hierarchy & Logo Geometry

- **Primary Typeface**: **Poppins** (Google Fonts / Modern Geometric Sans-Serif)
- **Sub-Brand Wordmark**: **`DigiMenu`** (written as a single unified compound word with **NO SPACE** between Digi and Menu).
- **Sub-Brand Styling**: Set in **Poppins SemiBold** (`FontWeight.w600`, letter-spacing: `7.0px`), colored in 100% **Eresto Red** (`#D32F2F`), centered optically beneath the `eresto®` lockup.
- **Letter Spacing ('e' to 'r')**: Formatted with an elegant, generous white margin matching official master brand specifications (5.8% ratio of 'e' glyph width), preventing glyph collision.
- **Cutlery Plate Emblem ('o')**: Crisp geometric cutlery cutout inside the 'o' plate consisting of 4 straight parallel fork tines at -45°, an elegant curved fork neck, straight parallel crossing handles, an oval spoon bowl, and dual concentric plate rim crescents.
- **Registered Trademark (®)**: Styled with a thin, delicate circular stroke (`stroke-width: ~2.0px`) and light-weighted sans-serif 'R' in vivid Eresto Red (`#D32F2F`), avoiding heavy bold strokes.

### Application Hierarchy Guidelines

| Hierarchy Level | Weight | Size Token | Purpose / Application |
| :--- | :--- | :--- | :--- |
| **Brand Wordmark (eResto)** | `FontWeight.w700` (Bold) | Custom Vector | Primary brand mark recognition |
| **Brand Sub-Brand (DigiMenu)**| `FontWeight.w600` (SemiBold) | Custom Vector | Sub-brand descriptor (NO SPACE), 100% Eresto Red (`#D32F2F`) |
| **App Icon Container** | Pure White Squircle | `1024 × 1024` / `512 × 512` | Adaptive launcher icon (`rx=224`) with centered logo lockup |
| **KPI Metrics / Prices** | `FontWeight.w700` (Bold) | `18.sp` – `28.sp` | High-impact numbers, totals, scan counts |
| **Screen & Section Titles** | `FontWeight.w600` (SemiBold) | `15.sp` – `18.sp` | Page headers, modal dialog titles |
| **Card / Item Titles** | `FontWeight.w600` (SemiBold) | `13.sp` – `14.5.sp` | Food item names, session channel names |
| **Interactive Buttons / Pills** | `FontWeight.w500` (Medium) | `12.sp` – `13.5.sp` | Action buttons (`Done`, `Save`, `Filter`) |
| **Form Labels & Eyebrows** | `FontWeight.w500` (Medium) | `9.5.sp` – `11.sp` | Section eyebrows (`SESSIONS`, `MENU CATEGORIES`) |
| **Body & Subtitles** | `FontWeight.w400` (Regular) | `11.sp` – `13.sp` | Descriptions, helper hints, info labels |

---

## 4. Brand Package Assets Inventory

```
brand_package/
├── 00_Brand_Package_Showcase.png               # High-res visual overview showcase
├── BRAND_GUIDELINES.md                          # This comprehensive brand specification
├── README.txt                                   # Quick directory overview
│
├── 01_Master_Logo/
│   ├── eresto_digimenu_master_horizontal.svg   # Vector master horizontal logo (Red + Charcoal)
│   └── eresto_digimenu_master_horizontal.png   # 2400x600 transparent master PNG
│
├── 02_White_Version/
│   ├── eresto_digimenu_white.svg               # Pure white vector for dark backgrounds
│   ├── eresto_digimenu_white.png               # Transparent white PNG
│   ├── eresto_digimenu_white_accent.svg        # White text with Eresto Red emblem accent
│   └── eresto_digimenu_white_accent.png        # Transparent white + red accent PNG
│
├── 03_Monochrome/
│   ├── eresto_digimenu_black.svg               # 100% black vector for single-color print/receipts
│   ├── eresto_digimenu_black.png               # 100% black PNG
│   ├── eresto_digimenu_monochrome.svg          # Grayscale vector (Charcoal + Cool Gray)
│   └── eresto_digimenu_monochrome.png          # Grayscale PNG
│
├── 04_Icons/
│   ├── eresto_app_icon.svg                     # Official App Icon squircle (Android 12+ safe)
│   ├── eresto_app_icon.png                     # 1024x1024 master icon PNG
│   ├── eresto_dish_icon.svg                    # Cutlery & plate circular emblem vector
│   ├── eresto_dish_icon.png                    # Cutlery & plate emblem PNG
│   ├── eresto_e_icon.svg                       # E monogram vector
│   ├── eresto_e_icon.png                       # E monogram PNG
│   ├── eresto_digimenu_icon.svg                # DigiMenu emblem vector
│   └── eresto_digimenu_icon.png                # DigiMenu emblem PNG
│
├── 05_Alternate_Layouts/
│   ├── eresto_digimenu_stacked.svg             # Vertical stacked logo with full taglines
│   ├── eresto_digimenu_stacked.png             # 1200x1200 stacked PNG
│   ├── eresto_digimenu_stacked_white.svg       # Vertical stacked white on dark vector
│   └── eresto_digimenu_stacked_white.png       # 1200x1200 stacked white PNG
│
└── 06_Brand_Guidelines/
    ├── Colour_Codes.txt                        # Quick copy-paste color values
    └── Eresto_DigiMenu_Brand_Guidelines.pdf    # Print-ready brand guidelines PDF
```

---

## 5. Logo Usage Rules & Clear Space

### Minimum Clear Space
Maintain a clear margin equal to the height of the circular dish emblem (`X`) around the entire perimeter of the logo. No other text, graphic elements, or borders may intrude into this exclusion zone.

```
       ┌───────────────────────────────┐
       │               X               │
       │   ┌───────────────────────┐   │
       │ X │   eResto DigiMenu     │ X │
       │   └───────────────────────┘   │
       │               X               │
       ┌───────────────────────────────┐
```

### Minimum Reproduction Sizing
- **Digital / Screen**: Minimum height of **24px** (horizontal) or **48px** (stacked).
- **Print**: Minimum width of **30mm** (horizontal) or **20mm** (stacked).
- **App Icon**: Master raster rendered at **1024×1024px**; splash icons downscaled to `512px` (xxxhdpi), `384px` (xxhdpi), `288px` (xhdpi), `192px` (hdpi).

### Prohibited Practices (Don'ts)
- ❌ **Do not** stretch, skew, or distort the proportions of the logo.
- ❌ **Do not** change the color of the `eResto` wordmark from `#424242` or `#FFFFFF`.
- ❌ **Do not** place the dark Master Logo on dark backgrounds (always use `02_White_Version`).
- ❌ **Do not** render `DigiMenu` in a heavier font weight than `eResto`.
- ❌ **Do not** crop the circular plate or cutlery graphic inside the emblem.

---

## 6. Official Brand Voice & Taglines

- **Product Tagline**:  
  `"Your Menu. More Possibilities."`
- **Supporting Sequence**:  
  `"SCAN • EXPLORE • ORDER • GROW"`
- **App Store / Launcher Name**:  
  `Digi Menu`
- **Product Entity**:  
  `eResto DigiMenu powered by Restrosoft Solutions Pvt. Ltd.`
