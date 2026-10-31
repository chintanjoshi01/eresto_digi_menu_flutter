import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Enterprise Typography System for eResto Digital Menu.
///
/// Implements full Material 3 semantic type scale specifications powered by Google Fonts Poppins.
/// Follows disciplined enterprise hierarchy:
/// - Bold (w700): Strictly reserved for eResto brand mark and high-impact numerical KPI metrics.
/// - SemiBold (w600): Reserved for primary page titles, card headers, and major dialog headings.
/// - Medium (w500): Used for section titles, interactive buttons, form labels, and status badges.
/// - Regular (w400): Used for all body text, subtitles, textfield inputs, and DigiMenu lockup text.
/// - Light (w300): Used for metadata, captions, and fine details.
class AppTypography {
  // ---------------------------------------------------------------------------
  // 1. Display Styles (Hero figures, KPI metrics, promotional displays)
  // ---------------------------------------------------------------------------
  static TextStyle get displayLarge => GoogleFonts.poppins(
        fontSize: 30.sp,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.2,
        color: AppColors.text,
      );

  static TextStyle get displayMedium => GoogleFonts.poppins(
        fontSize: 26.sp,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: -0.15,
        color: AppColors.text,
      );

  static TextStyle get displaySmall => GoogleFonts.poppins(
        fontSize: 22.sp,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: -0.1,
        color: AppColors.text,
      );

  // ---------------------------------------------------------------------------
  // 2. Headline Styles (Screen titles, major page headings, dialog titles)
  // ---------------------------------------------------------------------------
  static TextStyle get headlineLarge => GoogleFonts.poppins(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: -0.1,
        color: AppColors.text,
      );

  static TextStyle get headlineMedium => GoogleFonts.poppins(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0.0,
        color: AppColors.text,
      );

  static TextStyle get headlineSmall => GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        height: 1.35,
        letterSpacing: 0.0,
        color: AppColors.text,
      );

  // ---------------------------------------------------------------------------
  // 3. Title Styles (Card headers, list sections, form group headers, subtitles)
  // ---------------------------------------------------------------------------
  static TextStyle get titleLarge => GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        height: 1.35,
        letterSpacing: 0.05,
        color: AppColors.text,
      );

  static TextStyle get titleMedium => GoogleFonts.poppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.05,
        color: AppColors.text,
      );

  static TextStyle get titleSmall => GoogleFonts.poppins(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        height: 1.4,
        letterSpacing: 0.1,
        color: AppColors.textSecondary,
      );

  // ---------------------------------------------------------------------------
  // 4. Body Styles (Main content copy, paragraphs, table rows, form inputs)
  // ---------------------------------------------------------------------------
  static TextStyle get bodyLarge => GoogleFonts.poppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.15,
        color: AppColors.text,
      );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        height: 1.45,
        letterSpacing: 0.15,
        color: AppColors.text,
      );

  static TextStyle get bodySmall => GoogleFonts.poppins(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        height: 1.4,
        letterSpacing: 0.2,
        color: AppColors.textSecondary,
      );

  // ---------------------------------------------------------------------------
  // 5. Label Styles (Buttons, chips, form field labels, badges, captions, tabs)
  // ---------------------------------------------------------------------------
  static TextStyle get labelLarge => GoogleFonts.poppins(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: 0.1,
        color: Colors.white,
      );

  static TextStyle get labelMedium => GoogleFonts.poppins(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: 0.25,
        color: AppColors.textSecondary,
      );

  static TextStyle get labelSmall => GoogleFonts.poppins(
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        height: 1.2,
        letterSpacing: 0.35,
        color: AppColors.textMuted,
      );

  // ---------------------------------------------------------------------------
  // 6. Semantic Convenience Aliases (Clean Enterprise Readability)
  // ---------------------------------------------------------------------------
  static TextStyle get pageTitle => headlineLarge;
  static TextStyle get sectionHeader => titleMedium;
  static TextStyle get cardTitle => titleLarge;
  static TextStyle get subtitle => titleSmall;
  static TextStyle get formLabel => labelMedium.copyWith(
        fontWeight: FontWeight.w500,
        color: AppColors.text,
      );
  static TextStyle get metricValue => GoogleFonts.poppins(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
      );

  // Backward compatibility aliases
  static TextStyle get h1 => headlineLarge;
  static TextStyle get h2 => headlineMedium;
  static TextStyle get h3 => headlineSmall;
  static TextStyle get button => labelLarge;
  static TextStyle get caption => labelSmall;

  // ---------------------------------------------------------------------------
  // 7. Official Brand Package v1.0 Identity Typography
  // ---------------------------------------------------------------------------
  /// Primary Tagline: "Your Menu. More Possibilities." (Regular, airy, elegant)
  static TextStyle get taglinePrimary => GoogleFonts.poppins(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.charcoalGray,
        letterSpacing: 0.25,
      );

  /// Supporting Tagline Sequence: "SCAN • EXPLORE • ORDER • GROW" (Medium, tracked)
  static TextStyle get taglineSequence => GoogleFonts.poppins(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.coolGray,
        letterSpacing: 2.0,
      );

  /// Official eResto Wordmark: Bold (w700) to anchor the primary brand
  static TextStyle get erestoWordmark => GoogleFonts.poppins(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.charcoalGray,
      );

  /// Official DigiMenu Lockup Text: Regular (w400) - strictly lighter than eResto to preserve brand hierarchy
  static TextStyle get digimenuWordmark => GoogleFonts.poppins(
        fontSize: 22.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.erestoRed,
      );

  // ---------------------------------------------------------------------------
  // 8. Full Material 3 TextTheme Generator
  // ---------------------------------------------------------------------------
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );
}
