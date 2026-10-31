import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/template_model.dart';
import '../controllers/menu_theme_controller.dart';

class ThemeCardItem {
  final int id;
  final String name;
  final List<Color> headerGradient;
  final Color cardBg;
  final Color barColor;

  const ThemeCardItem({
    required this.id,
    required this.name,
    required this.headerGradient,
    required this.cardBg,
    required this.barColor,
  });
}

class ThemePickerSheet extends StatefulWidget {
  final TemplateModel template;
  const ThemePickerSheet({super.key, required this.template});

  @override
  State<ThemePickerSheet> createState() => _ThemePickerSheetState();
}

class _ThemePickerSheetState extends State<ThemePickerSheet> {
  late String _selectedThemeName;

  final List<ThemeCardItem> _themes = const [
    // --- BASIC THEMES ---
    ThemeCardItem(
      id: 1,
      name: 'Basic - 1',
      headerGradient: [Color(0xFFC1272D), Color(0xFF9E1F24)],
      cardBg: Color(0xFFFFF8F8),
      barColor: Color(0xFFC1272D),
    ),
    ThemeCardItem(
      id: 2,
      name: 'Basic - 2',
      headerGradient: [Color(0xFFC1272D), Color(0xFF9E1F24)],
      cardBg: Color(0xFFFFF8F8),
      barColor: Color(0xFFC1272D),
    ),
    ThemeCardItem(
      id: 14,
      name: 'Basic - 3',
      headerGradient: [Color(0xFFC1272D), Color(0xFF9E1F24)],
      cardBg: Color(0xFFFFF8F8),
      barColor: Color(0xFFC1272D),
    ),
    ThemeCardItem(
      id: 15,
      name: 'Basic - 4',
      headerGradient: [Color(0xFFF59E0B), Color(0xFFD97706)],
      cardBg: Color(0xFFFFFBEB),
      barColor: Color(0xFFD97706),
    ),
    ThemeCardItem(
      id: 16,
      name: 'Basic - 5',
      headerGradient: [Color(0xFFEA580C), Color(0xFFC2410C)],
      cardBg: Color(0xFFFFF7ED),
      barColor: Color(0xFFEA580C),
    ),

    // --- CLASSIC THEMES ---
    ThemeCardItem(
      id: 3,
      name: 'Classic - 1',
      headerGradient: [Color(0xFF0F766E), Color(0xFF115E59)],
      cardBg: Color(0xFFF0FDFA),
      barColor: Color(0xFF0F766E),
    ),
    ThemeCardItem(
      id: 5,
      name: 'Classic - 2',
      headerGradient: [Color(0xFF0284C7), Color(0xFF0369A1)],
      cardBg: Color(0xFFF0F9FF),
      barColor: Color(0xFF0284C7),
    ),
    ThemeCardItem(
      id: 7,
      name: 'Classic - 3',
      headerGradient: [Color(0xFF334155), Color(0xFF1E293B)],
      cardBg: Color(0xFFF8FAFC),
      barColor: Color(0xFF334155),
    ),

    // --- TRENDY THEMES ---
    ThemeCardItem(
      id: 4,
      name: 'Trendy - 1',
      headerGradient: [Color(0xFF1E293B), Color(0xFF0F172A)],
      cardBg: Color(0xFF1E293B),
      barColor: Color(0xFF4B5563),
    ),
    ThemeCardItem(
      id: 6,
      name: 'Trendy - 2',
      headerGradient: [Color(0xFF4F46E5), Color(0xFF4338CA)],
      cardBg: Color(0xFFEEF2FF),
      barColor: Color(0xFF4F46E5),
    ),
    ThemeCardItem(
      id: 9,
      name: 'Trendy - 3',
      headerGradient: [Color(0xFF16A34A), Color(0xFF15803D)],
      cardBg: Color(0xFFF0FDF4),
      barColor: Color(0xFF16A34A),
    ),
    ThemeCardItem(
      id: 10,
      name: 'Trendy - 4',
      headerGradient: [Color(0xFFD97706), Color(0xFFB45309)],
      cardBg: Color(0xFFFFFBEB),
      barColor: Color(0xFFD97706),
    ),
    ThemeCardItem(
      id: 11,
      name: 'Trendy - 5',
      headerGradient: [Color(0xFF9333EA), Color(0xFF7E22CE)],
      cardBg: Color(0xFFFAF5FF),
      barColor: Color(0xFF9333EA),
    ),
    ThemeCardItem(
      id: 13,
      name: 'Trendy - 6',
      headerGradient: [Color(0xFFBE185D), Color(0xFF9D174D)],
      cardBg: Color(0xFFFDF2F8),
      barColor: Color(0xFFBE185D),
    ),

    // --- NEO THEMES ---
    ThemeCardItem(
      id: 8,
      name: 'Neo - 1',
      headerGradient: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
      cardBg: Color(0xFFF0F9FF),
      barColor: Color(0xFF0EA5E9),
    ),
    ThemeCardItem(
      id: 12,
      name: 'Neo - 2',
      headerGradient: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
      cardBg: Color(0xFFFAF5FF),
      barColor: Color(0xFF7C3AED),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedThemeName = widget.template.name.contains('-') ? widget.template.name : 'Basic - 3';
  }

  void _save() {
    final controller = Get.find<MenuThemeController>();
    final selected = _themes.firstWhere(
      (t) => t.name == _selectedThemeName,
      orElse: () => _themes[0],
    );
    controller.updateTemplateTheme(
      widget.template.id,
      selected.name,
      selected.barColor,
      themeId: selected.id,
    );
    controller.selectTheme(widget.template.id);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 580, maxHeight: 0.88.sh),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 10.h),
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(Icons.description_outlined, size: 16.sp, color: AppColors.primary),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Menu Templates",
                                style: GoogleFonts.poppins(
                                  fontSize: 11.sp,
                                  color: const Color(0xFF9CA3AF),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                widget.template.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF111827),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Container(
                            width: 28.w,
                            height: 28.h,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF3F4F6),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.close_rounded, size: 16.sp, color: const Color(0xFF6B7280)),
                          ),
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    // Info Context Strip
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: const Color(0xFFF3F4F6)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline_rounded, size: 13.sp, color: const Color(0xFF9CA3AF)),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              "You are changing the theme for this template. Sessions using this template will reflect the new theme.",
                              style: GoogleFonts.poppins(
                                fontSize: 11.sp,
                                color: const Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: Color(0xFFF3F4F6)),

              // Scrollable Theme Cards Grid
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "SELECT THEME",
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6B7280),
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 10.h),

                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10.w,
                          mainAxisSpacing: 10.h,
                          childAspectRatio: 0.74,
                        ),
                        itemCount: _themes.length,
                        itemBuilder: (context, index) {
                          final theme = _themes[index];
                          final isSelected = theme.name == _selectedThemeName;

                          return GestureDetector(
                            onTap: () => setState(() => _selectedThemeName = theme.name),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
                                  width: isSelected ? 2.2.w : 1.2.w,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary.withOpacity(0.12),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Column(
                                children: [
                                  // Header gradient area
                                  Container(
                                    height: 48.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: theme.headerGradient,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: 3.h,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.3),
                                            borderRadius: BorderRadius.circular(2.r),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Body area
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.r)),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                            decoration: BoxDecoration(
                                              color: theme.cardBg,
                                              borderRadius: BorderRadius.circular(4.r),
                                            ),
                                            child: Container(
                                              height: 3.5.h,
                                              width: 32.w,
                                              decoration: BoxDecoration(
                                                color: theme.barColor,
                                                borderRadius: BorderRadius.circular(2.r),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5.h),
                                          Text(
                                            theme.name,
                                            style: GoogleFonts.poppins(
                                              fontSize: 10.sp,
                                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                              color: isSelected ? const Color(0xFF111827) : const Color(0xFF4B5563),
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (isSelected) ...[
                                            SizedBox(height: 2.h),
                                            Text(
                                              "Selected",
                                              style: GoogleFonts.poppins(
                                                fontSize: 8.5.sp,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Fixed Action Bar with system navigation clearance
              Container(
                padding: EdgeInsets.fromLTRB(
                  16.w,
                  10.h,
                  16.w,
                  12.h + MediaQuery.of(context).padding.bottom,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
                ),
                child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFD1D5DB)),
                            foregroundColor: const Color(0xFF374151),
                            padding: EdgeInsets.symmetric(vertical: 11.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 11.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_rounded, size: 15.sp, color: Colors.white),
                              SizedBox(width: 6.w),
                              Text(
                                "Apply Theme",
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }
}
