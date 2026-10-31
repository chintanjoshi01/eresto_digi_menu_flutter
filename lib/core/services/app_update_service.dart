import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/device_service.dart';
import '../services/toast_service.dart';
import '../theme/app_colors.dart';
import '../widgets/app_dialog.dart';

/// Enterprise Service handling Application Updates, Version Checks,
/// Google Play Store deep linking, and update presentation dialogs.
class AppUpdateService {
  AppUpdateService._();

  /// Default Google Play application identifier for eResto DigiMenu
  static const String defaultPackageName = 'in.eresto.digimenu';

  /// Android Market URI scheme for opening the native Google Play Store app directly
  static const String marketUriPrefix = 'market://details?id=';

  /// Fallback web HTTPS URL for Google Play Store in browser
  static const String webPlayStorePrefix = 'https://play.google.com/store/apps/details?id=';

  /// Resolves the current installed application version string (e.g. "1.1.4")
  static String get currentAppVersion => DeviceService.appVersion;

  /// Launches the Google Play Store page for eResto DigiMenu.
  ///
  /// First attempts native `market://details?id=...` with external application mode.
  /// If the Play Store app is not installed (e.g. emulator, de-Googled devices),
  /// falls back seamlessly to the standard HTTPS browser store link.
  static Future<bool> openPlayStore({String? packageName}) async {
    final pkg = (packageName != null && packageName.isNotEmpty)
        ? packageName
        : defaultPackageName;

    final marketUri = Uri.parse('$marketUriPrefix$pkg');
    final webUri = Uri.parse('$webPlayStorePrefix$pkg');

    try {
      HapticFeedback.mediumImpact();
      if (await canLaunchUrl(marketUri)) {
        final launched = await launchUrl(
          marketUri,
          mode: LaunchMode.externalApplication,
        );
        if (launched) return true;
      }
    } catch (_) {
      // Ignore and fallback to web browser URL
    }

    try {
      if (await canLaunchUrl(webUri)) {
        return await launchUrl(
          webUri,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      Get.log("Failed to launch Google Play Store URL: $e", isError: true);
    }

    ToastService.showError(
      "Could not open Google Play Store automatically. Please search for 'eResto DigiMenu' on the Play Store.",
    );
    return false;
  }

  /// Determines if a server error message indicates that an app update is required.
  static bool isUpdateRequiredMessage(String? message) {
    if (message == null || message.trim().isEmpty) return false;
    final lower = message.toLowerCase();
    return lower.contains('update the app') ||
        lower.contains('update your app') ||
        lower.contains('latest version') ||
        lower.contains('upgrade-app') ||
        lower.contains('upgrade the app') ||
        lower.contains('upgrade your app') ||
        lower.contains('new version is available') ||
        lower.contains('app version');
  }

  /// Displays an Enterprise App Update Modal Dialog
  static Future<void> showUpdateDialog({
    required BuildContext context,
    required String message,
    String? latestVersion,
    bool isForceUpgrade = true,
    VoidCallback? onOfflineMode,
    VoidCallback? onPostpone,
  }) async {
    await AppDialog.showUpdate(
      title: isForceUpgrade ? "App Update Required" : "New Version Available",
      message: message.isNotEmpty
          ? message
          : "A newer version of eResto DigiMenu is available on Google Play with critical updates and performance enhancements.",
      versionTag: latestVersion != null ? "v$latestVersion" : "Latest Release",
      buttonText: "Update on Google Play",
      isForceUpgrade: isForceUpgrade,
      onUpdate: () => openPlayStore(),
    );
  }

  /// Displays a modern, non-blocking App Update Bottom Sheet for optional/soft updates
  static Future<void> showUpdateBottomSheet({
    required BuildContext context,
    required String message,
    String? latestVersion,
    VoidCallback? onOfflineMode,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pull pill indicator
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),

              // Rocket Icon badge
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.1),
                ),
                child: Center(
                  child: Icon(
                    Icons.system_update_rounded,
                    color: AppColors.primary,
                    size: 32.sp,
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              Text(
                "App Update Available",
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 8.h),

              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: const Color(0xFF64748B),
                  height: 1.45,
                ),
              ),
              SizedBox(height: 20.h),

              // Version comparison card
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildVersionChip("Installed", "v$currentAppVersion", const Color(0xFF64748B)),
                    Icon(Icons.arrow_forward_rounded, size: 16.sp, color: const Color(0xFF94A3B8)),
                    _buildVersionChip("Latest", latestVersion != null ? "v$latestVersion" : "Google Play", AppColors.primary),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Update Button
              SizedBox(
                width: double.infinity,
                height: 46.h,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.back();
                    openPlayStore();
                  },
                  icon: const Icon(Icons.download_rounded, color: Colors.white, size: 18),
                  label: Text(
                    "Update on Google Play",
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),

              if (onOfflineMode != null) ...[
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.infinity,
                  height: 42.h,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                      onOfflineMode();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF334155),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      "Continue in Offline Mode",
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF334155),
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: 12.h),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildVersionChip(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF94A3B8),
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
