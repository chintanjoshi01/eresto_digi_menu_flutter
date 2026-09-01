import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/template_model.dart';
import '../controllers/menu_theme_controller.dart';

class ThemePickerSheet extends StatefulWidget {
  final TemplateModel template;
  const ThemePickerSheet({super.key, required this.template});

  @override
  State<ThemePickerSheet> createState() => _ThemePickerSheetState();
}

class _ThemePickerSheetState extends State<ThemePickerSheet> {
  late String _primaryColorHex;
  late String _backgroundColorHex;
  late String _textColorHex;

  final List<String> _primaryPresets = [
    '0xFFAB2421', // Crimson
    '0xFF1E6B3C', // Forest Green
    '0xFF1E3C6B', // Navy Blue
    '0xFFE67E22', // Orange
    '0xFF8E44AD', // Purple
  ];

  final List<String> _bgPresets = [
    '0xFFF5F5F5', // Soft White
    '0xFFEAEAEA', // Off-White
    '0xFFFFF9E6', // Cream
    '0xFFEBF5FB', // Light Blue
    '0xFFF5EEF8', // Light Purple
  ];

  final List<String> _textPresets = [
    '0xFF2C3E50', // Dark Slate
    '0xFF1C2833', // Charcoal
    '0xFF7F8C8D', // Slate Gray
  ];

  @override
  void initState() {
    super.initState();
    _primaryColorHex = widget.template.primaryColor;
    _backgroundColorHex = widget.template.backgroundColor;
    _textColorHex = widget.template.textColor;
  }

  void _save() {
    final controller = Get.find<MenuThemeController>();
    controller.updateThemeColors(
      id: widget.template.id,
      primary: _primaryColorHex,
      bg: _backgroundColorHex,
      text: _textColorHex,
    );
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Theme Customization", style: AppTypography.h2),
              IconButton(
                icon: Icon(Icons.close_rounded, size: 24.sp),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // 1. Primary Colors Grid
          Text("Primary Theme Color", style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          Row(
            children: _primaryPresets.map((hex) {
              final isSel = _primaryColorHex == hex;
              final col = Color(int.parse(hex));
              return _buildColorDot(col, hex, isSel, (val) => setState(() => _primaryColorHex = val));
            }).toList(),
          ),
          SizedBox(height: 16.h),

          // 2. Background Colors Grid
          Text("Scaffold Background Color", style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          Row(
            children: _bgPresets.map((hex) {
              final isSel = _backgroundColorHex == hex;
              final col = Color(int.parse(hex));
              return _buildColorDot(col, hex, isSel, (val) => setState(() => _backgroundColorHex = val));
            }).toList(),
          ),
          SizedBox(height: 16.h),

          // 3. Text Colors Grid
          Text("Typography Color", style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          Row(
            children: _textPresets.map((hex) {
              final isSel = _textColorHex == hex;
              final col = Color(int.parse(hex));
              return _buildColorDot(col, hex, isSel, (val) => setState(() => _textColorHex = val));
            }).toList(),
          ),
          SizedBox(height: 28.h),

          // Live Preview Area
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Color(int.parse(_backgroundColorHex)),
              borderRadius: BorderRadius.circular(AppDimensions.radius8),
              border: Border.all(color: AppColors.borderLight, width: 1.w),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.restaurant_menu_rounded,
                  color: Color(int.parse(_primaryColorHex)),
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  "Interactive Preview Mode",
                  style: AppTypography.bodyMedium.copyWith(
                    color: Color(int.parse(_textColorHex)),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Save Changes
          SizedBox(
            width: double.infinity,
            height: 46.h,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radius8),
                ),
                elevation: 0,
              ),
              child: Text("Save Palette", style: AppTypography.button),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorDot(Color col, String hex, bool isSel, ValueChanged<String> onTap) {
    return GestureDetector(
      onTap: () => onTap(hex),
      child: Container(
        margin: EdgeInsets.only(right: 12.w),
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: col,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSel ? Colors.black : Colors.grey.shade300,
            width: isSel ? 2.5.w : 1.w,
          ),
        ),
      ),
    );
  }
}
