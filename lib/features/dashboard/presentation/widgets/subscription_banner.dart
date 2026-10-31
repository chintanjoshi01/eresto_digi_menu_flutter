import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/models/v6_dashboard_response.dart';

/// Enterprise Subscription Warning & Grace Period Alert Banner
///
/// Displayed on the Dashboard screen for:
/// - Flag 2: Expiring Soon (0 to 7 days remaining) -> Warm Amber Warning
/// - Flag 3: Grace Period (Validity expired, within ext_days) -> Urgent Crimson Alert
class SubscriptionBanner extends StatelessWidget {
  final V6SubscriptionInfo subscription;
  final VoidCallback onRenew;
  final VoidCallback? onDismiss;

  const SubscriptionBanner({
    super.key,
    required this.subscription,
    required this.onRenew,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    if (!subscription.shouldShowWarningBanner) {
      return const SizedBox.shrink();
    }

    final isGracePeriod = subscription.isInGracePeriod;

    // Theme Colors
    final Color bgColor = isGracePeriod ? const Color(0xFFFEF2F2) : const Color(0xFFFFFBEB);
    final Color borderColor = isGracePeriod ? const Color(0xFFFECACA) : const Color(0xFFFDE68A);
    final Color primaryColor = isGracePeriod ? const Color(0xFFDC2626) : const Color(0xFFD97706);
    final Color badgeBg = isGracePeriod ? const Color(0xFFFEE2E2) : const Color(0xFFFEF3C7);
    final Color textColor = isGracePeriod ? const Color(0xFF991B1B) : const Color(0xFF92400E);
    final Color subtextColor = isGracePeriod ? const Color(0xFFB91C1C) : const Color(0xFFB45309);

    final IconData icon = isGracePeriod ? Icons.hourglass_top_rounded : Icons.warning_amber_rounded;
    final String badgeText = isGracePeriod
        ? "GRACE PERIOD"
        : (subscription.daysLeft <= 0 ? "EXPIRES TODAY" : "${subscription.daysLeft} DAYS LEFT");

    return Container(
      margin: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 4.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Alert Icon Container
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: badgeBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),

          // 2. Banner Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 6.w,
                  runSpacing: 4.h,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        badgeText,
                        style: GoogleFonts.poppins(
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    if (subscription.validity.isNotEmpty)
                      Text(
                        "Until ${subscription.validity}",
                        style: GoogleFonts.poppins(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w500,
                          color: subtextColor,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  subscription.displayMessage,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),

          // 3. Renew Action Button
          ElevatedButton(
            onPressed: onRenew,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              minimumSize: Size(64.w, 34.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              isGracePeriod ? "Renew Now" : "Renew",
              style: GoogleFonts.poppins(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
