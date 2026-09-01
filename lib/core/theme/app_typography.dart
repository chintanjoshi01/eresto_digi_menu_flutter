import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static TextStyle get h1 => GoogleFonts.nunito(
        fontSize: 24.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.text,
      );

  static TextStyle get h2 => GoogleFonts.nunito(
        fontSize: 20.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.text,
      );

  static TextStyle get h3 => GoogleFonts.nunito(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
      );

  static TextStyle get bodyLarge => GoogleFonts.nunito(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      );

  static TextStyle get bodyMedium => GoogleFonts.nunito(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.text,
      );

  static TextStyle get bodySmall => GoogleFonts.nunito(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  static TextStyle get caption => GoogleFonts.nunito(
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      );

  static TextStyle get button => GoogleFonts.nunito(
        fontSize: 13.sp,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      );
}
