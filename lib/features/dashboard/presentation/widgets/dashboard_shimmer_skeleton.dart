import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_dimensions.dart';

/// High-fidelity Shimmer skeleton that mirrors the Dashboard screen layout.
class DashboardShimmerSkeleton extends StatelessWidget {
  const DashboardShimmerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE5E7EB),
      highlightColor: const Color(0xFFF9FAFB),
      period: const Duration(milliseconds: 1200),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Header Banner Skeleton
            _buildHeroSkeleton(),

            // 2. Overlapping Scans Analytics Card Skeleton
            Transform.translate(
              offset: Offset(0, -20.h),
              child: _buildAnalyticsCardSkeleton(),
            ),

            // 3. Active Now Section Skeleton
            _buildSectionHeaderSkeleton(width: 80.w, actionWidth: 100.w),
            _buildActiveSessionsGridSkeleton(),

            SizedBox(height: 28.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSkeleton() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFC1272D).withOpacity(0.85),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 36.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Restaurant Name & Published Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmerBox(width: 160.w, height: 20.h, radius: 4.r, color: Colors.white.withOpacity(0.4)),
                  SizedBox(height: 6.h),
                  _shimmerBox(width: 110.w, height: 12.h, radius: 4.r, color: Colors.white.withOpacity(0.25)),
                ],
              ),
              _shimmerBox(width: 80.w, height: 24.h, radius: 12.r, color: Colors.white.withOpacity(0.35)),
            ],
          ),
          SizedBox(height: 14.h),

          // Divider
          Container(
            height: 1.h,
            color: Colors.white.withOpacity(0.2),
          ),
          SizedBox(height: 12.h),

          // Row 2: Items & Categories Split
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(width: 80.w, height: 10.h, radius: 3.r, color: Colors.white.withOpacity(0.3)),
                    SizedBox(height: 6.h),
                    _shimmerBox(width: 60.w, height: 22.h, radius: 4.r, color: Colors.white.withOpacity(0.45)),
                    SizedBox(height: 4.h),
                    _shimmerBox(width: 100.w, height: 10.h, radius: 3.r, color: Colors.white.withOpacity(0.25)),
                  ],
                ),
              ),
              Container(
                width: 1.w,
                height: 40.h,
                color: Colors.white.withOpacity(0.2),
                margin: EdgeInsets.symmetric(horizontal: 12.w),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(width: 90.w, height: 10.h, radius: 3.r, color: Colors.white.withOpacity(0.3)),
                    SizedBox(height: 6.h),
                    _shimmerBox(width: 45.w, height: 22.h, radius: 4.r, color: Colors.white.withOpacity(0.45)),
                    SizedBox(height: 4.h),
                    _shimmerBox(width: 85.w, height: 10.h, radius: 3.r, color: Colors.white.withOpacity(0.25)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCardSkeleton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Menu Filter Tabs
          Row(
            children: [
              _shimmerBox(width: 80.w, height: 22.h, radius: 4.r),
              SizedBox(width: 12.w),
              _shimmerBox(width: 65.w, height: 22.h, radius: 4.r),
              SizedBox(width: 12.w),
              _shimmerBox(width: 55.w, height: 22.h, radius: 4.r),
            ],
          ),
          SizedBox(height: 12.h),

          // 2. Trend title & period pills
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerBox(width: 110.w, height: 14.h, radius: 3.r),
              Row(
                children: [
                  _shimmerBox(width: 44.w, height: 20.h, radius: 10.r),
                  SizedBox(width: 4.w),
                  _shimmerBox(width: 44.w, height: 20.h, radius: 10.r),
                  SizedBox(width: 4.w),
                  _shimmerBox(width: 48.w, height: 20.h, radius: 10.r),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // 3. Big Metric readout
          _shimmerBox(width: 70.w, height: 26.h, radius: 4.r),
          SizedBox(height: 4.h),
          _shimmerBox(width: 95.w, height: 12.h, radius: 3.r),
          SizedBox(height: 14.h),

          // 4. Line Chart Placeholder
          _shimmerBox(
            width: double.infinity,
            height: 85.h,
            radius: 8.r,
          ),
          SizedBox(height: 12.h),

          // Divider
          Container(height: 1, color: const Color(0xFFF3F4F6)),
          SizedBox(height: 10.h),

          // 5. Footer Stats
          Row(
            children: [
              Expanded(child: Center(child: _shimmerStatColumn())),
              Container(width: 1.w, height: 24.h, color: const Color(0xFFF3F4F6)),
              Expanded(child: Center(child: _shimmerStatColumn())),
              Container(width: 1.w, height: 24.h, color: const Color(0xFFF3F4F6)),
              Expanded(child: Center(child: _shimmerStatColumn())),
            ],
          ),
        ],
      ),
    );
  }

  Widget _shimmerStatColumn() {
    return Column(
      children: [
        _shimmerBox(width: 50.w, height: 10.h, radius: 2.r),
        SizedBox(height: 4.h),
        _shimmerBox(width: 36.w, height: 14.h, radius: 3.r),
      ],
    );
  }

  Widget _buildSectionHeaderSkeleton({required double width, double? actionWidth}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _shimmerBox(width: width, height: 14.h, radius: 3.r),
          if (actionWidth != null)
            _shimmerBox(width: actionWidth, height: 12.h, radius: 3.r),
        ],
      ),
    );
  }

  Widget _buildActiveSessionsGridSkeleton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildSessionCardSkeleton()),
              SizedBox(width: 8.w),
              Expanded(child: _buildSessionCardSkeleton()),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(child: _buildSessionCardSkeleton()),
              SizedBox(width: 8.w),
              Expanded(child: _buildSessionCardSkeleton()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCardSkeleton() {
    return AspectRatio(
      aspectRatio: 1.34,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _shimmerBox(width: 45.w, height: 12.h, radius: 3.r),
                _shimmerBox(width: 40.w, height: 12.h, radius: 3.r),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: 70.w, height: 14.h, radius: 3.r),
                SizedBox(height: 4.h),
                _shimmerBox(width: 90.w, height: 10.h, radius: 2.r),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _shimmerBox(width: 50.w, height: 12.h, radius: 2.r),
                _shimmerBox(width: 44.w, height: 12.h, radius: 3.r),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    required double radius,
    Color? color,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
