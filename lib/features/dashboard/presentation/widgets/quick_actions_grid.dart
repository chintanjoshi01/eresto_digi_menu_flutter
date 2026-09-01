import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

/// Component rendering quick action shortcut tiles for the dashboard screen.
class QuickActionsGrid extends StatelessWidget {
  final VoidCallback onAllItemsPressed;
  final VoidCallback onPublishPressed;
  final VoidCallback onQrSharePressed;
  final VoidCallback onAddItemPressed;

  const QuickActionsGrid({
    super.key,
    required this.onAllItemsPressed,
    required this.onPublishPressed,
    required this.onQrSharePressed,
    required this.onAddItemPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      child: Row(
        children: [
          _buildActionItem(
            label: "All Items",
            icon: Icons.grid_view_rounded,
            iconColor: const Color(0xFFC1272D),
            bgColor: const Color(0xFFFEF2F2),
            onTap: onAllItemsPressed,
          ),
          SizedBox(width: 8.w),
          _buildActionItem(
            label: "Publish",
            icon: Icons.cloud_upload_rounded,
            iconColor: const Color(0xFF16A34A),
            bgColor: const Color(0xFFF0FDF4),
            onTap: onPublishPressed,
          ),
          SizedBox(width: 8.w),
          _buildActionItem(
            label: "QR & Share",
            icon: Icons.share_rounded,
            iconColor: const Color(0xFF3B82F6),
            bgColor: const Color(0xFFEFF6FF),
            onTap: onQrSharePressed,
          ),
          SizedBox(width: 8.w),
          _buildActionItem(
            label: "Add Item",
            icon: Icons.add_circle_outline_rounded,
            iconColor: const Color(0xFFCA8A04),
            bgColor: const Color(0xFFFEF9C3),
            onTap: onAddItemPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required String label,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radius12),
              border: Border.all(color: const Color(0xFFF3F4F6)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 34.w,
                  height: 34.h,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(AppDimensions.radius8),
                  ),
                  child: Icon(
                    icon,
                    size: 18.sp,
                    color: iconColor,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  label,
                  style: GoogleFonts.nunito(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
