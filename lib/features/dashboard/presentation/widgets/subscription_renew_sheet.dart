import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/services/toast_service.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/v6_dashboard_response.dart';

/// Enterprise Renewal & Support Action Modal Sheet
class SubscriptionRenewSheet extends StatelessWidget {
  final V6SubscriptionInfo subscription;
  final VoidCallback? onCheckStatus;

  const SubscriptionRenewSheet({
    super.key,
    required this.subscription,
    this.onCheckStatus,
  });

  static const String supportPhone = "+919499740227";
  static const String supportPhoneDisplay = "+91 94997 40227";
  static const String supportWhatsApp = "919499740227";
  static const String portalUrl = "https://new.eresto.app";

  static Future<void> show(
    BuildContext context, {
    required V6SubscriptionInfo subscription,
    VoidCallback? onCheckStatus,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SubscriptionRenewSheet(
        subscription: subscription,
        onCheckStatus: onCheckStatus,
      ),
    );
  }

  Future<void> _launchCall() async {
    final uri = Uri.parse("tel:$supportPhone");
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Clipboard.setData(const ClipboardData(text: supportPhone));
        ToastService.showInfo("Support number copied: $supportPhoneDisplay");
      }
    } catch (_) {
      Clipboard.setData(const ClipboardData(text: supportPhone));
      ToastService.showInfo("Support number copied: $supportPhoneDisplay");
    }
  }

  Future<void> _launchWhatsApp() async {
    final restoName = Get.isRegistered<StorageService>()
        ? Get.find<StorageService>().restoName
        : "Restaurant";
    final msg = Uri.encodeComponent(
      "Hello eResto Support, I want to renew my DigiMenu subscription for $restoName.",
    );
    final uri = Uri.parse("https://wa.me/$supportWhatsApp?text=$msg");

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ToastService.showError("Could not open WhatsApp.");
      }
    } catch (e) {
      ToastService.showError("Could not open WhatsApp: $e");
    }
  }

  Future<void> _launchPortal() async {
    final uri = Uri.parse(portalUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ToastService.showError("Could not open browser portal.");
      }
    } catch (e) {
      ToastService.showError("Could not open portal: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGrace = subscription.isInGracePeriod;
    final isExpired = subscription.isExpired;

    final Color primaryColor = isExpired
        ? const Color(0xFFDC2626)
        : (isGrace ? const Color(0xFFEA580C) : const Color(0xFFD97706));

    final String statusLabel = isExpired
        ? "SUBSCRIPTION EXPIRED"
        : (isGrace ? "GRACE PERIOD ACTIVE" : "EXPIRING SOON");

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
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 18.h),

          // Icon & Header
          Container(
            width: 54.w,
            height: 54.w,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isExpired ? Icons.lock_clock_rounded : Icons.workspace_premium_rounded,
              color: primaryColor,
              size: 28.sp,
            ),
          ),
          SizedBox(height: 12.h),

          // Status Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: primaryColor.withOpacity(0.3)),
            ),
            child: Text(
              statusLabel,
              style: GoogleFonts.poppins(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w700,
                color: primaryColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
          SizedBox(height: 8.h),

          Text(
            "Renew DigiMenu Subscription",
            style: GoogleFonts.poppins(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 6.h),

          Text(
            subscription.displayMessage,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12.5.sp,
              color: const Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          SizedBox(height: 18.h),

          // Validity Summary Card
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoColumn(
                  "Validity",
                  subscription.validity.isNotEmpty ? subscription.validity : "Elapsed",
                  primaryColor,
                ),
                Container(width: 1, height: 28.h, color: const Color(0xFFCBD5E1)),
                _buildInfoColumn(
                  "Status",
                  isExpired ? "Needs Renewal" : (isGrace ? "In Grace" : "${subscription.daysLeft} Days"),
                  const Color(0xFF0F172A),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // Action 1: WhatsApp Support
          SizedBox(
            width: double.infinity,
            height: 46.h,
            child: ElevatedButton.icon(
              onPressed: _launchWhatsApp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              icon: const Icon(Icons.chat_bubble_rounded, size: 18, color: Colors.white),
              label: Text(
                "Renew via WhatsApp ($supportPhoneDisplay)",
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),

          // Action 2: Call Support
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: OutlinedButton.icon(
              onPressed: _launchCall,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0F172A),
                side: const BorderSide(color: Color(0xFFCBD5E1)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              icon: const Icon(Icons.phone_in_talk_rounded, size: 17, color: Color(0xFF0F172A)),
              label: Text(
                "Call Specialist ($supportPhoneDisplay)",
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),

          // Action 3: Web Portal
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: OutlinedButton.icon(
              onPressed: _launchPortal,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0F172A),
                side: const BorderSide(color: Color(0xFFCBD5E1)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              icon: const Icon(Icons.open_in_browser_rounded, size: 17, color: Color(0xFF0F172A)),
              label: Text(
                "Open eResto Web Portal",
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),

          // Action 4: Refresh Status
          if (onCheckStatus != null)
            TextButton.icon(
              onPressed: () {
                Get.back();
                onCheckStatus!();
              },
              icon: const Icon(Icons.refresh_rounded, size: 16, color: AppColors.primary),
              label: Text(
                "I've Renewed, Check Status Now",
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 10.5.sp,
            color: const Color(0xFF94A3B8),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            color: valueColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
