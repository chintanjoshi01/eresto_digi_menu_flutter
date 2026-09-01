import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../domain/dashboard_model.dart';

/// Enterprise Component rendering ranked category views statistics with progress bars.
class TopCategoriesList extends StatelessWidget {
  final List<CategoryViewStat> categories;

  const TopCategoriesList({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: categories.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          final isLast = idx == categories.length - 1;
          final barColor = _parseColor(item.colorHex);

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(bottom: BorderSide(color: Color(0xFFF9FAFB))),
            ),
            child: Row(
              children: [
                // Rank Badge
                Container(
                  width: 22.w,
                  height: 22.h,
                  decoration: BoxDecoration(
                    color: barColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item.rank.toString(),
                    style: GoogleFonts.nunito(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      color: barColor,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),

                // Category Name & Progress Bar
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: GoogleFonts.nunito(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Progress track
                      Container(
                        height: 4.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: item.percentage.clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: barColor,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),

                // Views Count
                Text(
                  "${item.views} views",
                  style: GoogleFonts.nunito(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex));
    } catch (_) {
      return AppColors.primary;
    }
  }
}
