import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

/// Component displaying pending unpublished menu modifications notice
/// and providing an immediate Publish action button.
class UnpublishedStatusBanner extends StatelessWidget {
  final int count;
  final String summary;
  final VoidCallback onPublishPressed;

  const UnpublishedStatusBanner({
    super.key,
    required this.count,
    required this.summary,
    required this.onPublishPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        border: Border.all(color: const Color(0xFFFEE2E2)),
      ),
      child: Row(
        children: [
          // Alert Icon Badge
          Container(
            width: 34.w,
            height: 34.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radius8),
            ),
            child: Icon(
              Icons.edit_document,
              size: 18.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 10.w),

          // Message Body
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$count unpublished changes",
                  style: GoogleFonts.nunito(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF991B1B),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  summary,
                  style: GoogleFonts.nunito(
                    fontSize: 11.sp,
                    color: const Color(0xFFB91C1C),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Publish Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radius8),
              ),
              elevation: 0,
            ),
            onPressed: onPublishPressed,
            child: Text(
              "Publish",
              style: GoogleFonts.nunito(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
