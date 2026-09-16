import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_typography.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? customContent;
  final IconData? icon;
  final Color? iconColor;
  final String? badgeText;
  final Color? badgeColor;
  final String? primaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final Color? primaryButtonColor;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;
  final bool isForceAction;
  final bool isLoading;
  final bool isDangerous;

  const AppDialog({
    super.key,
    required this.title,
    this.message,
    this.customContent,
    this.icon,
    this.iconColor,
    this.badgeText,
    this.badgeColor,
    this.primaryButtonText,
    this.onPrimaryPressed,
    this.primaryButtonColor,
    this.secondaryButtonText,
    this.onSecondaryPressed,
    this.isForceAction = false,
    this.isLoading = false,
    this.isDangerous = false,
  });

  // ---------------------------------------------------------------------------
  // Static Helper Methods for Enterprise Clean Usage across Controllers/Views
  // ---------------------------------------------------------------------------

  /// Displays a Force / Optional App Update Dialog
  static Future<T?> showUpdate<T>({
    required String message,
    String title = "App Update Required",
    String? versionTag = "Latest Release",
    String buttonText = "Update Now",
    VoidCallback? onUpdate,
    bool isForceUpgrade = true,
  }) {
    return show<T>(
      dialog: AppDialog(
        title: title,
        message: message,
        badgeText: versionTag ?? "System Update",
        badgeColor: AppColors.primary,
        icon: Icons.system_update_rounded,
        iconColor: AppColors.primary,
        primaryButtonText: buttonText,
        primaryButtonColor: AppColors.primary,
        isForceAction: isForceUpgrade,
        onPrimaryPressed: () {
          if (!isForceUpgrade) {
            Get.back();
          }
          onUpdate?.call();
        },
      ),
      barrierDismissible: !isForceUpgrade,
    );
  }

  /// Displays a Action Confirmation Dialog (e.g. Logout, Delete Item)
  static Future<T?> showConfirmation<T>({
    required String title,
    required String message,
    String confirmText = "Confirm",
    String cancelText = "Cancel",
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool isDangerous = false,
    IconData icon = Icons.help_outline_rounded,
  }) {
    return show<T>(
      dialog: AppDialog(
        title: title,
        message: message,
        icon: icon,
        iconColor: isDangerous ? AppColors.error : AppColors.primary,
        isDangerous: isDangerous,
        primaryButtonText: confirmText,
        primaryButtonColor: isDangerous ? AppColors.error : AppColors.primary,
        onPrimaryPressed: () {
          Get.back();
          onConfirm();
        },
        secondaryButtonText: cancelText,
        onSecondaryPressed: () {
          Get.back();
          onCancel?.call();
        },
      ),
    );
  }

  /// Displays an Informational / Alert Notice Dialog
  static Future<T?> showNotice<T>({
    required String title,
    required String message,
    String buttonText = "OK",
    VoidCallback? onPressed,
    IconData icon = Icons.info_outline_rounded,
    Color? iconColor,
    String? badgeText,
  }) {
    return show<T>(
      dialog: AppDialog(
        title: title,
        message: message,
        badgeText: badgeText,
        icon: icon,
        iconColor: iconColor ?? AppColors.primary,
        primaryButtonText: buttonText,
        onPrimaryPressed: () {
          Get.back();
          onPressed?.call();
        },
      ),
    );
  }

  /// Low-level static method to launch the dialog with smooth animation & scale safety
  static Future<T?> show<T>({
    required Widget dialog,
    bool barrierDismissible = true,
  }) {
    return Get.dialog<T>(
      dialog,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withOpacity(0.55),
      transitionCurve: Curves.fastOutSlowIn,
      transitionDuration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? (isDangerous ? AppColors.error : AppColors.primary);
    final effectivePrimaryColor = primaryButtonColor ?? (isDangerous ? AppColors.error : AppColors.primary);

    return PopScope(
      canPop: !isForceAction,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.symmetric(
          horizontal: AppDimensions.space20,
          vertical: AppDimensions.space24,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 420.w, // Responsive Max-width for Tablets, Foldables & POS Displays
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radius24),
                border: Border.all(
                  color: AppColors.borderLight,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 30,
                    spreadRadius: 2,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radius24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --- Decorative Top Accent Bar ---
                    Container(
                      height: 4.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            effectivePrimaryColor,
                            effectivePrimaryColor.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),

                    // --- Scrollable Body Content for Screen Safety ---
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          AppDimensions.space24,
                          AppDimensions.space24,
                          AppDimensions.space24,
                          AppDimensions.space16,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 1. Icon Badge with Glowing Outer Ring (If Provided)
                            if (icon != null) ...[
                              _buildIconBadge(effectiveIconColor),
                              SizedBox(height: AppDimensions.space16),
                            ],

                            // 2. Optional Sub-Header Tag / Badge Chip
                            if (badgeText != null && badgeText!.isNotEmpty) ...[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: (badgeColor ?? effectivePrimaryColor).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  badgeText!.toUpperCase(),
                                  style: GoogleFonts.nunito(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                    color: badgeColor ?? effectivePrimaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: AppDimensions.space12),
                            ],

                            // 3. Dialog Title
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: AppTypography.h2.copyWith(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark,
                                height: 1.25,
                              ),
                            ),

                            // 4. Dialog Message Description
                            if (message != null && message!.isNotEmpty) ...[
                              SizedBox(height: AppDimensions.space8),
                              Text(
                                message!,
                                textAlign: TextAlign.center,
                                style: AppTypography.bodyMedium.copyWith(
                                  fontSize: 13.sp,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ],

                            // 5. Custom Content Widget (If passed)
                            if (customContent != null) ...[
                              SizedBox(height: AppDimensions.space12),
                              customContent!,
                            ],
                          ],
                        ),
                      ),
                    ),

                    // --- Action Buttons Section ---
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppDimensions.space24,
                        0,
                        AppDimensions.space24,
                        AppDimensions.space24,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Primary Action Button
                          if (primaryButtonText != null)
                            SizedBox(
                              width: double.infinity,
                              height: 46.h,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: effectivePrimaryColor,
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  shadowColor: effectivePrimaryColor.withOpacity(0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                                  ),
                                ),
                                onPressed: isLoading ? null : onPrimaryPressed,
                                child: isLoading
                                    ? SizedBox(
                                        height: 20.h,
                                        width: 20.h,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        primaryButtonText!,
                                        style: AppTypography.button.copyWith(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                              ),
                            ),

                          // Secondary Action Button (Cancel / Dismiss)
                          if (secondaryButtonText != null) ...[
                            SizedBox(height: AppDimensions.space8),
                            SizedBox(
                              width: double.infinity,
                              height: 42.h,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.textSecondary,
                                  side: const BorderSide(
                                    color: AppColors.border,
                                    width: 1.2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                                  ),
                                ),
                                onPressed: onSecondaryPressed,
                                child: Text(
                                  secondaryButtonText!,
                                  style: AppTypography.bodyLarge.copyWith(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a beautifully styled icon container with concentric glow rings
  Widget _buildIconBadge(Color accentColor) {
    return Container(
      width: 64.w,
      height: 64.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: accentColor.withOpacity(0.08),
        border: Border.all(
          color: accentColor.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: accentColor.withOpacity(0.15),
          ),
          child: Icon(
            icon,
            size: 28.sp,
            color: accentColor,
          ),
        ),
      ),
    );
  }
}
