import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/services/toast_service.dart';
import '../../../../core/theme/app_colors.dart';

/// Enterprise Bottom Sheet displaying all published digital menu URLs for the restaurant.
/// Provides instant 1-tap "Copy" and "Open" actions for each channel link.
class MenuUrlsBottomSheet extends StatelessWidget {
  final String restaurantName;
  final List<String> menuUrls;

  const MenuUrlsBottomSheet({
    super.key,
    required this.restaurantName,
    required this.menuUrls,
  });

  /// Static helper to display this sheet cleanly via GetX
  static void show(
    BuildContext context, {
    required String restaurantName,
    required List<String> menuUrls,
  }) {
    HapticFeedback.lightImpact();
    Get.bottomSheet(
      MenuUrlsBottomSheet(
        restaurantName: restaurantName,
        menuUrls: menuUrls,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Deduplicate and clean URLs
    final cleanUrls = menuUrls
        .map((u) => cleanUrl(u))
        .where((u) => u.isNotEmpty)
        .toSet()
        .toList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Top Drag Handle
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 10.h, bottom: 8.h),
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            // 2. Header
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 4.h, 16.w, 12.h),
              child: Row(
                children: [
                  Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: const Color(0xFFFEE2E2),
                        width: 1.w,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.link_rounded,
                        size: 20.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Published Menu Links",
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF111827),
                            letterSpacing: -0.2,
                          ),
                        ),
                        Text(
                          "$restaurantName · ${cleanUrls.length} Active ${cleanUrls.length == 1 ? 'Channel' : 'Channels'}",
                          style: GoogleFonts.poppins(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.close_rounded,
                      size: 20.sp,
                      color: const Color(0xFF6B7280),
                    ),
                    tooltip: "Close",
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Color(0xFFE5E7EB)),

            // 3. Scrollable List of Menu URLs
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(
                  16.w,
                  14.h,
                  16.w,
                  14.h + MediaQuery.of(context).padding.bottom,
                ),
                itemCount: cleanUrls.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final url = cleanUrls[index];
                  return _buildUrlCard(context, url, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrlCard(BuildContext context, String url, int index) {
    final meta = _resolveChannelMeta(url);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Channel Tag + Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: meta.bgColor,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(meta.icon, size: 15.sp, color: meta.accentColor),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    meta.title,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8.w),
                ),
                child: Text(
                  meta.badge,
                  style: GoogleFonts.poppins(
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF475569),
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // Row 2: Clean URL display
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8.w),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.link_rounded,
                  size: 13.sp,
                  color: const Color(0xFF94A3B8),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    url,
                    style: GoogleFonts.poppins(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF334155),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10.h),

          // Row 3: Action Buttons (Copy & Open)
          Row(
            children: [
              // 1. Copy Button
              Expanded(
                child: SizedBox(
                  height: 36.h,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Clipboard.setData(ClipboardData(text: url));
                      ToastService.showSuccess("Copied ${meta.title} link!");
                    },
                    icon: Icon(
                      Icons.copy_rounded,
                      size: 14.sp,
                      color: const Color(0xFF334155),
                    ),
                    label: Text(
                      "Copy",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF334155),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF334155),
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: const Color(0xFFCBD5E1),
                        width: 1.w,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 8.w),

              // 2. Open Button
              Expanded(
                child: SizedBox(
                  height: 36.h,
                  child: ElevatedButton.icon(
                    onPressed: () => _openUrl(url),
                    icon: Icon(
                      Icons.open_in_new_rounded,
                      size: 14.sp,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Open",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Sanitizes raw URL strings: strips redundant protocols, cleans duplicate slashes, and ensures https
  static String cleanUrl(String raw) {
    var u = raw.trim();
    // 1. Remove duplicate protocols e.g. https://https:// or http://https://
    while (u.startsWith('https://https://') ||
        u.startsWith('http://https://') ||
        u.startsWith('https://http://') ||
        u.startsWith('http://http://')) {
      u = u.replaceFirst(RegExp(r'^https?://'), '');
    }
    // 2. Ensure scheme is present
    if (!u.startsWith('http://') && !u.startsWith('https://')) {
      u = 'https://$u';
    }
    // 3. Deduplicate slashes not part of scheme
    u = u.replaceAll(RegExp(r'(?<!:)/{2,}'), '/');
    return u;
  }

  Future<void> _openUrl(String url) async {
    HapticFeedback.lightImpact();
    final target = cleanUrl(url);
    final uri = Uri.tryParse(target);

    if (uri == null) {
      Clipboard.setData(ClipboardData(text: target));
      ToastService.showInfo("Link copied to clipboard!");
      return;
    }

    bool launched = false;

    // Strategy 1: In-App Browser View (Chrome Custom Tabs on Android / SFSafariViewController on iOS)
    // Most reliable on Android 11+, seamless, maintains in-app context
    try {
      launched = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } catch (_) {
      launched = false;
    }

    // Strategy 2: External Browser Application (Default system browser like Chrome/Firefox)
    if (!launched) {
      try {
        launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {
        launched = false;
      }
    }

    // Strategy 3: Platform Default
    if (!launched) {
      try {
        launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (_) {
        launched = false;
      }
    }

    // Strategy 4: In-App WebView fallback
    if (!launched) {
      try {
        launched = await launchUrl(uri, mode: LaunchMode.inAppWebView);
      } catch (_) {
        launched = false;
      }
    }

    // Safe fallback: If system cannot launch any browser, copy link so user is never blocked
    if (!launched) {
      Clipboard.setData(ClipboardData(text: target));
      ToastService.showInfo("Link copied to clipboard! Paste in your browser.");
    }
  }

  /// Resolve user-friendly label, icon, and colors for a menu URL
  _ChannelMeta _resolveChannelMeta(String url) {
    final lower = url.toLowerCase();

    if (lower.endsWith('/dine-in') || lower.contains('dine-in')) {
      return const _ChannelMeta(
        title: "Dine-IN Menu",
        badge: "DINE-IN",
        icon: Icons.restaurant_rounded,
        accentColor: Color(0xFFD32F2F),
        bgColor: Color(0xFFFEF2F2),
      );
    }
    if (lower.endsWith('/ird') || lower.contains('ird')) {
      return const _ChannelMeta(
        title: "In-Room Dining (IRD)",
        badge: "IRD",
        icon: Icons.room_service_rounded,
        accentColor: Color(0xFF2563EB),
        bgColor: Color(0xFFEFF6FF),
      );
    }

    // Dynamic categories (cat2, cat3, cat4, cat5, cat6...)
    final catMatch = RegExp(r'/cat(\d+)').firstMatch(lower);
    if (catMatch != null) {
      final catNum = catMatch.group(1);
      return _ChannelMeta(
        title: "Category $catNum Menu",
        badge: "CAT $catNum",
        icon: Icons.menu_book_rounded,
        accentColor: const Color(0xFF7C3AED),
        bgColor: const Color(0xFFF5F3FF),
      );
    }

    // Default generic channel
    final uri = Uri.tryParse(url);
    final lastSegment = (uri != null && uri.pathSegments.isNotEmpty)
        ? uri.pathSegments.last.toUpperCase()
        : "MENU";

    return _ChannelMeta(
      title: "$lastSegment Menu",
      badge: lastSegment,
      icon: Icons.language_rounded,
      accentColor: const Color(0xFF0D9488),
      bgColor: const Color(0xFFF0FDFA),
    );
  }
}

class _ChannelMeta {
  final String title;
  final String badge;
  final IconData icon;
  final Color accentColor;
  final Color bgColor;

  const _ChannelMeta({
    required this.title,
    required this.badge,
    required this.icon,
    required this.accentColor,
    required this.bgColor,
  });
}
