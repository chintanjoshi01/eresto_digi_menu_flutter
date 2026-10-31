import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'menu_urls_bottom_sheet.dart';

/// Red Hero Component displaying Restaurant info, Published badge, and No. of Items / Categories split.
/// Matches eresto_menu_mobile_v41.html prototype specs 100%.
class DashboardHeroCard extends StatelessWidget {
  final String restaurantName;
  final String restaurantUrl;
  final List<String> menuUrls;
  final bool isPublished;
  final int totalItems;
  final int totalCategories;
  final VoidCallback? onItemsTap;
  final VoidCallback? onCategoriesTap;

  const DashboardHeroCard({
    super.key,
    required this.restaurantName,
    required this.restaurantUrl,
    this.menuUrls = const [],
    required this.isPublished,
    this.totalItems = 247,
    this.totalCategories = 10,
    this.onItemsTap,
    this.onCategoriesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFC1272D),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 36.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Restaurant Name & Published Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  restaurantName,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              // Status Pill Badge (● Published)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 0.8.w,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      isPublished ? "Published" : "Draft",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFDCFCE7),
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Menu Link Pill - Full Width across the card
          Builder(
            builder: (context) {
              final allUrls = menuUrls.isNotEmpty
                  ? menuUrls
                  : (restaurantUrl.isNotEmpty ? [restaurantUrl] : const <String>[]);
              final primaryRawUrl = allUrls.isNotEmpty ? allUrls.first : restaurantUrl;
              final cleanDisplayUrl = primaryRawUrl
                  .replaceAll(RegExp(r'(?<!:)/{2,}'), '/')
                  .replaceFirst(RegExp(r'^https?://'), '');

              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  MenuUrlsBottomSheet.show(
                    context,
                    restaurantName: restaurantName,
                    menuUrls: allUrls,
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.28),
                      width: 0.8.w,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.link_rounded,
                        size: 14.sp,
                        color: Colors.white.withOpacity(0.95),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          cleanDisplayUrl,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.arrow_drop_down_rounded,
                        size: 20.sp,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 14.h),

          // Horizontal Divider Line
          Container(
            width: double.infinity,
            height: 1.h,
            color: Colors.white.withOpacity(0.15),
          ),
          SizedBox(height: 12.h),

          // Row 2: No. of Items and No. of Categories Split
          Row(
            children: [
              // Column 1: NO. OF ITEMS
              Expanded(
                child: InkWell(
                  onTap: onItemsTap,
                  borderRadius: BorderRadius.circular(8.r),
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "NO. OF ITEMS",
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              "$totalItems",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700,
                                height: 1.1,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "Items",
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Total items in menu",
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Vertical Divider Line
              Container(
                width: 1.w,
                height: 42.h,
                color: Colors.white.withOpacity(0.15),
                margin: EdgeInsets.only(right: 12.w),
              ),

              // Column 2: NO. OF CATEGORIES
              Expanded(
                child: InkWell(
                  onTap: onCategoriesTap,
                  borderRadius: BorderRadius.circular(8.r),
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "NO. OF CATEGORIES",
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              "$totalCategories",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700,
                                height: 1.1,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "Categories",
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Active categories",
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
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
}
