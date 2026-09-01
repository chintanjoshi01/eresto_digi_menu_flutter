import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_dimensions.dart';

/// Enterprise Dashboard Hero Component displaying restaurant identity,
/// live publishing status badge, and key item counters.
class DashboardHeroCard extends StatelessWidget {
  final String restaurantName;
  final String restaurantUrl;
  final bool isPublished;
  final int totalItems;
  final int availableItems;
  final int hiddenItems;

  const DashboardHeroCard({
    super.key,
    required this.restaurantName,
    required this.restaurantUrl,
    required this.isPublished,
    required this.totalItems,
    required this.availableItems,
    required this.hiddenItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 42.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFC1272D),
            Color(0xFF9E1F24),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppDimensions.radius20),
          bottomRight: Radius.circular(AppDimensions.radius20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant Name & Live Status Badge
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
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      restaurantUrl,
                      style: GoogleFonts.nunito(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              // Published Status Pill Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.h,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4ADE80),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      isPublished ? "Published" : "Draft",
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),

          // 3-Column Items Stats Row
          Row(
            children: [
              _buildStatColumn("Total Items", totalItems.toString()),
              _buildDivider(),
              _buildStatColumn("Available", availableItems.toString()),
              _buildDivider(),
              _buildStatColumn("Hidden", hiddenItems.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: GoogleFonts.nunito(
              color: Colors.white.withOpacity(0.8),
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1.w,
      height: 24.h,
      color: Colors.white.withOpacity(0.2),
    );
  }
}
