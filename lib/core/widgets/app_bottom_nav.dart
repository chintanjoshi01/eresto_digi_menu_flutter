import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Unified Prototype Bottom Navigation Bar used across Dashboard, Items, Menu, and Share screens.
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTabSelected;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: const Color(0xFFE5E7EB), width: 1.h)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 52.h,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    index: 0,
                    icon: Icons.grid_view_rounded,
                    label: "Dashboard",
                    isSelected: currentIndex == 0,
                    route: '/dashboard',
                  ),
                  _buildNavItem(
                    index: 1,
                    icon: Icons.format_list_bulleted_rounded,
                    label: "Items",
                    isSelected: currentIndex == 1,
                    route: '/items',
                  ),
                  _buildNavItem(
                    index: 2,
                    icon: Icons.description_outlined,
                    label: "Menu",
                    isSelected: currentIndex == 2,
                    route: '/menu',
                  ),
                  _buildNavItem(
                    index: 3,
                    icon: Icons.share_outlined,
                    label: "Share",
                    isSelected: currentIndex == 3,
                    route: '/share',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
    required String route,
  }) {
    final color = isSelected ? AppColors.primary : const Color(0xFF9CA3AF);
    return InkWell(
      onTap: () {
        if (!isSelected) {
          HapticFeedback.selectionClick();
          if (onTabSelected != null) {
            onTabSelected!(index);
          } else {
            Get.offNamed(route);
          }
        }
      },
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
        child: AnimatedScale(
          scale: isSelected ? 1.06 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20.sp),
              SizedBox(height: 2.h),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: AppTypography.labelSmall.copyWith(
                  color: color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
