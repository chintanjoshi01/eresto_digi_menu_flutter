import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Red Hero Component displaying Restaurant info, Published badge, and No. of Items / Categories split.
/// Matches eresto_menu_mobile_v41.html prototype specs 100%.
class DashboardHeroCard extends StatelessWidget {
  final String restaurantName;
  final String restaurantUrl;
  final bool isPublished;
  final int totalItems;
  final int totalCategories;
  final VoidCallback? onItemsTap;
  final VoidCallback? onCategoriesTap;

  const DashboardHeroCard({
    super.key,
    required this.restaurantName,
    required this.restaurantUrl,
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
          // Row 1: Restaurant Name, URL & Published Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurantName,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      restaurantUrl,
                      style: GoogleFonts.nunito(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              // Status Pill Badge (● Published)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20.r),
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
                      style: GoogleFonts.nunito(
                        color: const Color(0xFFDCFCE7),
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
                          style: GoogleFonts.nunito(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w800,
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
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "Items",
                              style: GoogleFonts.nunito(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Total items in menu",
                          style: GoogleFonts.nunito(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
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
                          style: GoogleFonts.nunito(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w800,
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
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "Categories",
                              style: GoogleFonts.nunito(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Active categories",
                          style: GoogleFonts.nunito(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
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
