import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/storage/storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/menu_template_model.dart';
import '../../domain/models/template_model.dart';
import 'theme_picker_sheet.dart';

/// Enterprise Template Options Bottom Sheet matching Screenshot 3 & eresto_menu_mobile_v41.html.
class TemplateOptionsSheet extends StatelessWidget {
  final MenuTemplateModel? menuTemplate;
  final TemplateModel? template;
  final bool isMultiMenu;

  const TemplateOptionsSheet({
    super.key,
    this.menuTemplate,
    this.template,
    this.isMultiMenu = false,
  });

  @override
  Widget build(BuildContext context) {
    final name = menuTemplate?.name ?? template?.name ?? 'Main';
    final themeColor = menuTemplate?.themeColor ??
        (name == 'Main'
            ? const Color(0xFFC1272D)
            : (name == 'Breakfast'
                ? const Color(0xFFF59E0B)
                : (name == 'HI-TEA'
                    ? const Color(0xFF16A34A)
                    : (name == 'Multi Menu'
                        ? const Color(0xFF7C3AED)
                        : const Color(0xFF1E293B)))));

    final themeName = menuTemplate?.themeName.replaceAll('Theme: ', '') ??
        (name == 'Main'
            ? 'Basic - 3'
            : (name == 'Breakfast'
                ? 'Basic - 4'
                : (name == 'HI-TEA'
                    ? 'Trendy - 3'
                    : (name == 'Multi Menu' ? 'Neo - 2' : 'Trendy - 1'))));

    final subtitle = menuTemplate?.details ??
        (isMultiMenu
            ? "Multi Category Menu"
            : "Single Menu");

    final restoName = Get.isRegistered<StorageService>() ? Get.find<StorageService>().restoName : 'Restaurant Menu';
    final customerTitle = (menuTemplate?.customerTitle != null && menuTemplate!.customerTitle.isNotEmpty)
        ? menuTemplate!.customerTitle
        : restoName;
    final tagline = (menuTemplate?.tagline != null && menuTemplate!.tagline.isNotEmpty)
        ? menuTemplate!.tagline
        : 'Where Every Bite Brings Happiness.';
    final menuType = isMultiMenu ? 'Multi Category Menu' : 'Single Menu';
    final priceList = menuTemplate?.priceList ?? 'Default';
    final language = menuTemplate?.language ?? 'English';
    final catsCount = menuTemplate?.itemCategoriesCount ?? (isMultiMenu ? 0 : 0);
    final itemsCount = menuTemplate?.itemsTotal ?? 0;

    return Container(
      constraints: BoxConstraints(maxHeight: 0.90.sh),
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
        children: [
          // 1. Draggable Top Grab Bar
          Container(
            margin: EdgeInsets.only(top: 10.h, bottom: 6.h),
            width: 44.w,
            height: 4.5.h,
            decoration: BoxDecoration(
              color: const Color(0xFFD1D5DB),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),

          // 2. Template Header Title Strip
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                // Avatar Box with First Letter
                Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: themeColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'M',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Template Name & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                // Close Button
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Get.back(),
                  child: Container(
                    width: 28.w,
                    height: 28.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close_rounded, size: 14.sp, color: const Color(0xFF6B7280)),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF3F4F6)),

          // 3. Scrollable Sections Content
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                14.w,
                12.h,
                14.w,
                16.h + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── CARD 1: BASIC SETTINGS ──
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFF3F4F6), width: 1.w),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "BASIC SETTINGS",
                          style: GoogleFonts.poppins(
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF6B7280),
                            letterSpacing: 0.4,
                          ),
                        ),
                        SizedBox(height: 10.h),

                        // Row A: Menu Type & Customer Title
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Menu Type",
                                    style: GoogleFonts.poppins(fontSize: 9.sp, color: const Color(0xFF9CA3AF), fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    menuType,
                                    style: GoogleFonts.poppins(fontSize: 11.5.sp, fontWeight: FontWeight.w700, color: const Color(0xFF111827)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Customer Title",
                                    style: GoogleFonts.poppins(fontSize: 9.sp, color: const Color(0xFF9CA3AF), fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    customerTitle,
                                    style: GoogleFonts.poppins(fontSize: 11.5.sp, fontWeight: FontWeight.w700, color: const Color(0xFF111827)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10.h),

                        // Row B: Tagline
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tagline",
                              style: GoogleFonts.poppins(fontSize: 9.sp, color: const Color(0xFF9CA3AF), fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              tagline,
                              style: GoogleFonts.poppins(fontSize: 11.5.sp, fontWeight: FontWeight.w700, color: const Color(0xFF111827)),
                            ),
                          ],
                        ),

                        SizedBox(height: 10.h),

                        // Row C: Price List & Language
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Price List",
                                    style: GoogleFonts.poppins(fontSize: 9.sp, color: const Color(0xFF9CA3AF), fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    priceList,
                                    style: GoogleFonts.poppins(fontSize: 11.5.sp, fontWeight: FontWeight.w700, color: const Color(0xFF111827)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Language",
                                    style: GoogleFonts.poppins(fontSize: 9.sp, color: const Color(0xFF9CA3AF), fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    language,
                                    style: GoogleFonts.poppins(fontSize: 11.5.sp, fontWeight: FontWeight.w700, color: const Color(0xFF111827)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12.h),

                        // Row D: Selected Theme & Change Theme Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Selected Theme",
                                    style: GoogleFonts.poppins(fontSize: 9.sp, color: const Color(0xFF9CA3AF), fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Container(
                                        width: 11.w,
                                        height: 11.h,
                                        decoration: BoxDecoration(
                                          color: themeColor,
                                          borderRadius: BorderRadius.circular(2.r),
                                        ),
                                      ),
                                      SizedBox(width: 6.w),
                                      Flexible(
                                        child: Text(
                                          themeName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w600, color: const Color(0xFF111827)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8.w),

                            // Change Theme Button
                            InkWell(
                              borderRadius: BorderRadius.circular(6.r),
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Get.back();
                                Get.bottomSheet(
                                  ThemePickerSheet(
                                    template: template ??
                                        TemplateModel(
                                          id: menuTemplate?.id ?? 1,
                                          name: themeName,
                                          primaryColor: '0x${themeColor.value.toRadixString(16)}',
                                          backgroundColor: '0xFFFFFFFF',
                                          textColor: '0xFF111827',
                                          isActive: menuTemplate?.isActive ?? false,
                                        ),
                                  ),
                                  isScrollControlled: true,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6.r),
                                  border: Border.all(color: const Color(0xFFF5D0D1), width: 1.2.w),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.palette_outlined, size: 14.sp, color: AppColors.primary),
                                    SizedBox(width: 5.w),
                                    Text(
                                      "Change Theme",
                                      style: GoogleFonts.poppins(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // ── CARD 2: ITEMS & CATEGORIES ──
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFF3F4F6), width: 1.w),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "ITEMS & CATEGORIES",
                              style: GoogleFonts.poppins(
                                fontSize: 9.5.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF6B7280),
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),

                        // Stats Grid (Categories & Items Total)
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(color: const Color(0xFFE5E7EB)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ITEM CATEGORIES",
                                      style: GoogleFonts.poppins(fontSize: 8.5.sp, fontWeight: FontWeight.w700, color: const Color(0xFF9CA3AF)),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      "$catsCount picked",
                                      style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w600, color: const Color(0xFF111827)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(color: const Color(0xFFE5E7EB)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ITEMS TOTAL",
                                      style: GoogleFonts.poppins(fontSize: 8.5.sp, fontWeight: FontWeight.w700, color: const Color(0xFF9CA3AF)),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      "$itemsCount",
                                      style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w600, color: const Color(0xFF111827)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // ── CARD 3: DISPLAY SETTINGS ON MENU ──
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFF3F4F6), width: 1.w),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "DISPLAY SETTINGS ON MENU",
                          style: GoogleFonts.poppins(
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF6B7280),
                            letterSpacing: 0.4,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        // Checkmark Pills
                        Wrap(
                          spacing: 6.w,
                          runSpacing: 6.h,
                          children: const [
                            _DisplayCheckPill("Logo"),
                            _DisplayCheckPill("Currency"),
                            _DisplayCheckPill("Veg/Non-Veg"),
                            _DisplayCheckPill("Quantity"),
                            _DisplayCheckPill("Allergens"),
                            _DisplayCheckPill("Calories"),
                            _DisplayCheckPill("Pure Veg badge"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DisplayCheckPill extends StatelessWidget {
  final String label;
  const _DisplayCheckPill(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.5.h),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFBBF7D0), width: 1.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_rounded, size: 11.sp, color: const Color(0xFF15803D)),
          SizedBox(width: 3.w),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF15803D),
            ),
          ),
        ],
      ),
    );
  }
}
