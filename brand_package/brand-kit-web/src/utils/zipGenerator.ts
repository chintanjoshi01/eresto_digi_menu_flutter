import JSZip from 'jszip';
import { saveAs } from 'file-saver';
import confetti from 'canvas-confetti';
import type { BrandConfig } from '../types/brand';

export const generateBrandKitZip = async (config: BrandConfig) => {
  const zip = new JSZip();
  const folderName = `${config.brandName.replace(/[^a-zA-Z0-9]/g, '_')}_Brand_Kit_v${config.version}`;
  const root = zip.folder(folderName)!;

  // Helper for SVG rendering strings
  const getMasterLogoSvg = () => `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 400" width="1200" height="400">
  <defs>
    <linearGradient id="primaryGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="${config.primaryColor}"/>
      <stop offset="100%" stop-color="${config.goldColor}"/>
    </linearGradient>
    <filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="8" stdDeviation="12" flood-color="#000" flood-opacity="0.25"/>
    </filter>
  </defs>

  <!-- Background -->
  <rect width="1200" height="400" fill="${config.darkBgColor}" rx="24"/>
  
  <!-- Grid Accent -->
  <pattern id="grid" width="40" height="40" patternUnits="userSpaceOnUse">
    <path d="M 40 0 L 0 0 0 40" fill="none" stroke="rgba(255,255,255,0.03)" stroke-width="1"/>
  </pattern>
  <rect width="1200" height="400" fill="url(#grid)" rx="24"/>

  <!-- Brand Icon Badge -->
  <g transform="translate(100, 100)" filter="url(#shadow)">
    <rect width="200" height="200" rx="40" fill="url(#primaryGrad)"/>
    <text x="100" y="135" font-family="${config.displayFont}, sans-serif" font-size="110" font-weight="bold" fill="#FFFFFF" text-anchor="middle">${config.monogramLetter}</text>
  </g>

  <!-- Typography -->
  <g transform="translate(340, 175)">
    <text font-family="${config.displayFont}, sans-serif" font-size="90" font-weight="800" fill="#FFFFFF" letter-spacing="-2">${config.brandName}</text>
    <text y="50" font-family="${config.bodyFont}, sans-serif" font-size="28" font-weight="500" fill="${config.goldColor}" letter-spacing="4">${config.subtitle.toUpperCase()}</text>
    <text y="95" font-family="${config.bodyFont}, sans-serif" font-size="20" font-weight="400" fill="rgba(255,255,255,0.6)">${config.tagline}</text>
  </g>
</svg>`;

  const getWhiteLogoSvg = () => `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 400" width="1200" height="400">
  <rect width="1200" height="400" fill="${config.charcoalColor}" rx="24"/>
  <g transform="translate(100, 100)">
    <rect width="200" height="200" rx="40" fill="rgba(255,255,255,0.15)"/>
    <text x="100" y="135" font-family="${config.displayFont}, sans-serif" font-size="110" font-weight="bold" fill="#FFFFFF" text-anchor="middle">${config.monogramLetter}</text>
  </g>
  <g transform="translate(340, 175)">
    <text font-family="${config.displayFont}, sans-serif" font-size="90" font-weight="800" fill="#FFFFFF" letter-spacing="-2">${config.brandName}</text>
    <text y="50" font-family="${config.bodyFont}, sans-serif" font-size="28" font-weight="500" fill="#FFFFFF" opacity="0.8" letter-spacing="4">${config.subtitle.toUpperCase()}</text>
  </g>
</svg>`;

  const getMonoLogoSvg = () => `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 400" width="1200" height="400">
  <rect width="1200" height="400" fill="${config.lightBgColor}" rx="24" stroke="rgba(0,0,0,0.1)" stroke-width="2"/>
  <g transform="translate(100, 100)">
    <rect width="200" height="200" rx="40" fill="${config.charcoalColor}"/>
    <text x="100" y="135" font-family="${config.displayFont}, sans-serif" font-size="110" font-weight="bold" fill="#FFFFFF" text-anchor="middle">${config.monogramLetter}</text>
  </g>
  <g transform="translate(340, 175)">
    <text font-family="${config.displayFont}, sans-serif" font-size="90" font-weight="800" fill="${config.charcoalColor}" letter-spacing="-2">${config.brandName}</text>
    <text y="50" font-family="${config.bodyFont}, sans-serif" font-size="28" font-weight="500" fill="${config.primaryColor}" letter-spacing="4">${config.subtitle.toUpperCase()}</text>
  </g>
</svg>`;

  const getAppIconSvg = (bg: string, text: string) => `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" width="512" height="512">
  <rect width="512" height="512" rx="112" fill="${bg}"/>
  <text x="256" y="340" font-family="${config.displayFont}, sans-serif" font-size="300" font-weight="bold" fill="${text}" text-anchor="middle">${config.monogramLetter}</text>
</svg>`;

  // 1. Logos
  const folder01 = root.folder('01_Master_Logo');
  folder01?.file(`${config.brandName}_Master_Logo.svg`, getMasterLogoSvg());

  const folder02 = root.folder('02_White_Version');
  folder02?.file(`${config.brandName}_Logo_White.svg`, getWhiteLogoSvg());

  const folder03 = root.folder('03_Monochrome');
  folder03?.file(`${config.brandName}_Logo_Monochrome.svg`, getMonoLogoSvg());

  // 2. Icons
  const folder04 = root.folder('04_Icons');
  folder04?.file(`App_Icon_Primary.svg`, getAppIconSvg(config.primaryColor, '#FFFFFF'));
  folder04?.file(`App_Icon_Dark.svg`, getAppIconSvg(config.darkBgColor, config.goldColor));
  folder04?.file(`App_Icon_Gold.svg`, getAppIconSvg(config.goldColor, '#FFFFFF'));

  // 3. Theme Code Exports
  const themeFolder = root.folder('theme_export');
  
  // Compose
  const composeFolder = themeFolder?.folder('compose');
  composeFolder?.file('Color.kt', `package com.brand.${config.brandName.toLowerCase()}.ui.theme

import androidx.compose.ui.graphics.Color

// ${config.brandName} Brand Colors v${config.version}
val ${config.brandName}Primary = Color(0xFF${config.primaryColor.replace('#', '')})
val ${config.brandName}Charcoal = Color(0xFF${config.charcoalColor.replace('#', '')})
val ${config.brandName}Gold = Color(0xFF${config.goldColor.replace('#', '')})
val ${config.brandName}DarkBg = Color(0xFF${config.darkBgColor.replace('#', '')})
val ${config.brandName}LightBg = Color(0xFF${config.lightBgColor.replace('#', '')})
`);

  // Flutter
  const flutterFolder = themeFolder?.folder('flutter');
  flutterFolder?.file('brand_theme.dart', `import 'package:flutter/material.dart';

/// ${config.brandName} Brand Theme Tokens v${config.version}
class ${config.brandName}BrandColors {
  static const Color primary = Color(0xFF${config.primaryColor.replace('#', '')});
  static const Color charcoal = Color(0xFF${config.charcoalColor.replace('#', '')});
  static const Color gold = Color(0xFF${config.goldColor.replace('#', '')});
  static const Color darkBg = Color(0xFF${config.darkBgColor.replace('#', '')});
  static const Color lightBg = Color(0xFF${config.lightBgColor.replace('#', '')});
}
`);

  // Tailwind
  const tailwindFolder = themeFolder?.folder('tailwind');
  tailwindFolder?.file('tailwind.config.js', `/** @type {import('tailwindcss').Config} */
module.exports = {
  theme: {
    extend: {
      colors: {
        brand: {
          primary: '${config.primaryColor}',
          charcoal: '${config.charcoalColor}',
          gold: '${config.goldColor}',
          dark: '${config.darkBgColor}',
          light: '${config.lightBgColor}',
        }
      },
      fontFamily: {
        display: ['${config.displayFont}', 'sans-serif'],
        body: ['${config.bodyFont}', 'sans-serif'],
      }
    }
  }
}
`);

  // SwiftUI
  const swiftUiFolder = themeFolder?.folder('swiftui');
  swiftUiFolder?.file('ColorTokens.swift', `import SwiftUI

// ${config.brandName} Brand Theme Tokens
public extension Color {
    static let brandPrimary = Color(hex: "${config.primaryColor}")
    static let brandCharcoal = Color(hex: "${config.charcoalColor}")
    static let brandGold = Color(hex: "${config.goldColor}")
    static let brandDarkBg = Color(hex: "${config.darkBgColor}")
    static let brandLightBg = Color(hex: "${config.lightBgColor}")
}
`);

  // CSS
  const cssFolder = themeFolder?.folder('css');
  cssFolder?.file('tokens.css', `:root {
  --brand-primary: ${config.primaryColor};
  --brand-charcoal: ${config.charcoalColor};
  --brand-gold: ${config.goldColor};
  --brand-dark-bg: ${config.darkBgColor};
  --brand-light-bg: ${config.lightBgColor};
  --brand-font-display: '${config.displayFont}', sans-serif;
  --brand-font-body: '${config.bodyFont}', sans-serif;
}
`);

  // Guidelines Markdown
  root.file('BRAND_GUIDELINES.md', `# ${config.brandName} Brand Identity Guidelines
> Version ${config.version} | Generated via Antigravity Brand Kit Creator

## 1. Executive Summary
- **Brand Name**: ${config.brandName}
- **Subtitle**: ${config.subtitle}
- **Tagline**: ${config.tagline}
- **Industry**: ${config.industry}

## 2. Color Palette
- **Primary Accent**: \`${config.primaryColor}\`
- **Deep Charcoal**: \`${config.charcoalColor}\`
- **Gold Accent**: \`${config.goldColor}\`
- **Dark Background**: \`${config.darkBgColor}\`
- **Light Background**: \`${config.lightBgColor}\`

## 3. Typography Architecture
- **Display / Header**: \`${config.displayFont}\`
- **Body Text**: \`${config.bodyFont}\`

---
*Created automatically with Antigravity AI Agentic System.*
`);

  root.file('README.md', `# ${config.brandName} Package
Contains SVG logo variants, app icons, brand guidelines, and multi-platform theme tokens.
`);

  // Generate ZIP blob and trigger download
  const content = await zip.generateAsync({ type: 'blob' });
  saveAs(content, `${folderName}.zip`);

  // Trigger celebration confetti
  confetti({
    particleCount: 120,
    spread: 70,
    origin: { y: 0.6 }
  });
};
