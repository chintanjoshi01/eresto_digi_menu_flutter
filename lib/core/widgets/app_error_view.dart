import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../errors/app_error_type.dart';
import '../services/app_update_service.dart';
import '../services/device_service.dart';
import '../theme/app_colors.dart';

/// Enterprise-grade full-screen or embedded Error, Connectivity & Update View.
///
/// Intelligently categorizes failures into discrete enterprise states:
/// 1. App Update Required / Available (with Google Play Store action & version badge)
/// 2. Network / Connectivity Timeout (with Wi-Fi & data troubleshooting tips)
/// 3. Scheduled Cloud Maintenance (with service advisory & offline safety note)
/// 4. Session Expired / Unauthorized (with direct login redirect action)
/// 5. Cloud Service Incident / 500 (with operational health alert)
/// 6. Permission / Module Access Restricted (with subscription guide)
class AppErrorView extends StatefulWidget {
  final AppErrorType? errorType;
  final String? errorMessage;
  final String? title;
  final String? currentVersion;
  final String? latestVersion;
  final Future<void> Function()? onRetry;
  final VoidCallback? onOfflineMode;
  final VoidCallback? onUpdate;
  final VoidCallback? onLogin;
  final VoidCallback? onRenew;
  final Future<void> Function()? onRefresh;
  final IconData? customIcon;
  final bool isCompact;
  final dynamic rawError;

  const AppErrorView({
    super.key,
    this.errorType,
    this.errorMessage,
    this.title,
    this.currentVersion,
    this.latestVersion,
    this.onRetry,
    this.onOfflineMode,
    this.onUpdate,
    this.onLogin,
    this.onRenew,
    this.onRefresh,
    this.customIcon,
    this.isCompact = false,
    this.rawError,
  });

  @override
  State<AppErrorView> createState() => _AppErrorViewState();
}

class _AppErrorViewState extends State<AppErrorView> {
  bool _isRetrying = false;
  bool _isOpeningStore = false;

  /// Classify the exact enterprise error type from properties or message
  AppErrorType get _resolvedType {
    if (widget.errorType != null) return widget.errorType!;
    return AppErrorClassifier.classify(
      widget.rawError,
      message: widget.errorMessage,
    );
  }

  /// Get the visual configuration for the resolved error type
  AppErrorVisuals get _visuals {
    return AppErrorClassifier.getVisuals(
      _resolvedType,
      customMessage: _cleanErrorMessage,
      currentVersion: widget.currentVersion ?? DeviceService.appVersion,
      latestVersion: widget.latestVersion,
    );
  }

  String? get _cleanErrorMessage {
    if (widget.errorMessage == null || widget.errorMessage!.isEmpty) return null;
    var msg = widget.errorMessage!;
    // Clean raw Dart/Dio exception prefixes
    msg = msg.replaceAll(RegExp(r'^ApiException:\s*', caseSensitive: false), '');
    msg = msg.replaceAll(RegExp(r'^Exception:\s*', caseSensitive: false), '');
    msg = msg.replaceAll(RegExp(r'^DioException\s*\[.*?\]:\s*', caseSensitive: false), '');
    return msg.trim();
  }

  String get _resolvedTitle {
    if (widget.title != null && widget.title!.isNotEmpty) {
      return widget.title!;
    }
    return _visuals.title;
  }

  String get _resolvedMessage {
    final clean = _cleanErrorMessage;
    if (clean != null && clean.isNotEmpty) {
      return clean;
    }
    return _visuals.defaultMessage;
  }

  IconData get _resolvedIcon {
    if (widget.customIcon != null) return widget.customIcon!;
    return _visuals.icon;
  }

  Future<void> _handleRetry() async {
    if (_isRetrying) return;
    HapticFeedback.lightImpact();
    setState(() => _isRetrying = true);

    try {
      if (widget.onRetry != null) {
        await widget.onRetry!();
      } else if (widget.onRefresh != null) {
        await widget.onRefresh!();
      }
    } finally {
      if (mounted) {
        setState(() => _isRetrying = false);
      }
    }
  }

  Future<void> _handleUpdate() async {
    if (_isOpeningStore) return;
    HapticFeedback.mediumImpact();
    setState(() => _isOpeningStore = true);

    try {
      if (widget.onUpdate != null) {
        widget.onUpdate!();
      } else {
        await AppUpdateService.openPlayStore();
      }
    } finally {
      if (mounted) {
        setState(() => _isOpeningStore = false);
      }
    }
  }

  void _handleLogin() {
    HapticFeedback.lightImpact();
    if (widget.onLogin != null) {
      widget.onLogin!();
    } else {
      Get.offAllNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final visuals = _visuals;

    final content = LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 64.h),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // 1. Layered Concentric Icon Badge with Dynamic Status Ring
                  _buildIconBadge(visuals),

                  SizedBox(height: 20.h),

                  // 2. Clear, Enterprise Title
                  Text(
                    _resolvedTitle,
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                      letterSpacing: -0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 8.h),

                  // 3. User-Friendly Subtitle / Explanation
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      _resolvedMessage,
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                        height: 1.45,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 22.h),

                  // 4. Contextual Information / Troubleshooting Card
                  _buildContextualCard(visuals),

                  SizedBox(height: 26.h),

                  // 5. High-Impact Action Buttons
                  _buildActionButtons(visuals),

                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (widget.onRefresh != null) {
      return RefreshIndicator(
        onRefresh: widget.onRefresh!,
        color: visuals.primaryColor,
        backgroundColor: Colors.white,
        strokeWidth: 2.5,
        child: content,
      );
    }

    return content;
  }

  /// Multi-layered glowing concentric badge tailored to the error scenario
  Widget _buildIconBadge(AppErrorVisuals visuals) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer soft ambient ring
        Container(
          width: 88.w,
          height: 88.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: visuals.backgroundColor,
            border: Border.all(
              color: visuals.borderColor,
              width: 1.5.w,
            ),
            boxShadow: [
              BoxShadow(
                color: visuals.primaryColor.withOpacity(0.08),
                blurRadius: 24,
                spreadRadius: 4,
                offset: const Offset(0, 6),
              ),
            ],
          ),
        ),

        // Inner vibrant ring
        Container(
          width: 62.w,
          height: 62.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: visuals.primaryColor.withOpacity(0.12),
          ),
          child: Center(
            child: Icon(
              _resolvedIcon,
              size: 30.sp,
              color: visuals.primaryColor,
            ),
          ),
        ),

        // Status dot with subtle glow
        Positioned(
          bottom: 2.h,
          right: 2.w,
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: visuals.statusDotColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Contextual advice card (switches between version info, troubleshooting, or maintenance)
  Widget _buildContextualCard(AppErrorVisuals visuals) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 340.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(visuals.cardIcon, size: 15.sp, color: const Color(0xFF64748B)),
              SizedBox(width: 7.w),
              Expanded(
                child: Text(
                  visuals.cardHeader,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF334155),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ...visuals.tips.map((tip) {
            return Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 5.h, right: 8.w),
                    width: 5.w,
                    height: 5.w,
                    decoration: BoxDecoration(
                      color: visuals.primaryColor.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      tip,
                      style: GoogleFonts.poppins(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// High-contrast primary action + optional secondary offline / alternative buttons
  Widget _buildActionButtons(AppErrorVisuals visuals) {
    final type = _resolvedType;

    return Column(
      children: [
        // --- 1. PRIMARY ACTION BUTTON ---
        if (type == AppErrorType.appUpdate) ...[
          // Update on Google Play Button
          Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: 320.w),
            height: 46.h,
            child: ElevatedButton.icon(
              onPressed: _isOpeningStore ? null : _handleUpdate,
              icon: _isOpeningStore
                  ? SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.download_rounded, size: 18, color: Colors.white),
              label: Text(
                _isOpeningStore ? "Opening Play Store..." : "Update on Google Play",
                style: GoogleFonts.poppins(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 2.5,
                shadowColor: AppColors.primary.withOpacity(0.35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
            ),
          ),
        ] else if (type == AppErrorType.unauthorized) ...[
          // Sign In Again Button
          Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: 320.w),
            height: 46.h,
            child: ElevatedButton.icon(
              onPressed: _handleLogin,
              icon: const Icon(Icons.login_rounded, size: 18, color: Colors.white),
              label: Text(
                "Sign In Again",
                style: GoogleFonts.poppins(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: visuals.primaryColor,
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: visuals.primaryColor.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ] else if (type == AppErrorType.subscriptionExpired) ...[
          // Renew Subscription Button
          Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: 320.w),
            height: 46.h,
            child: ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                widget.onRenew?.call();
              },
              icon: const Icon(Icons.support_agent_rounded, size: 18, color: Colors.white),
              label: Text(
                visuals.primaryButtonText,
                style: GoogleFonts.poppins(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: visuals.primaryColor,
                foregroundColor: Colors.white,
                elevation: 2.5,
                shadowColor: visuals.primaryColor.withOpacity(0.35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
            ),
          ),
        ] else ...[
          // Standard Primary Retry Button
          Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: 320.w),
            height: 46.h,
            child: ElevatedButton(
              onPressed: _isRetrying ? null : _handleRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: visuals.primaryColor,
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: visuals.primaryColor.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
              child: _isRetrying
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "Reconnecting...",
                          style: GoogleFonts.poppins(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(visuals.primaryButtonIcon, size: 17.sp, color: Colors.white),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            visuals.primaryButtonText,
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],

        // --- 2. SECONDARY ACTION (Offline Mode if supported and not App Update or Expired Subscription) ---
        if (widget.onOfflineMode != null &&
            visuals.showOfflineModeAction &&
            type != AppErrorType.appUpdate &&
            type != AppErrorType.subscriptionExpired) ...[
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: 320.w),
            height: 42.h,
            child: OutlinedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                widget.onOfflineMode!();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF334155),
                side: BorderSide(color: const Color(0xFFCBD5E1), width: 1.2.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bolt_rounded,
                    size: 16.sp,
                    color: const Color(0xFF64748B),
                  ),
                  SizedBox(width: 6.w),
                  Flexible(
                    child: Text(
                      "Continue in Offline Mode",
                      style: GoogleFonts.poppins(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF334155),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        // --- 3. TERTIARY ACTION: Refresh / Re-test Check ---
        if (type == AppErrorType.appUpdate && (widget.onRetry != null || widget.onRefresh != null)) ...[
          SizedBox(height: 6.h),
          TextButton.icon(
            onPressed: _isRetrying ? null : _handleRetry,
            icon: Icon(Icons.refresh_rounded, size: 14.sp, color: const Color(0xFF64748B)),
            label: Text(
              _isRetrying ? "Checking..." : "Check Again",
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
