import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../controllers/menu_theme_controller.dart';
import '../widgets/session_edit_sheet.dart';
import '../widgets/theme_picker_sheet.dart';

/// Enterprise Menu Templates Screen matching eresto_menu_mobile_v5.html prototype specs.
class MenuScreen extends GetView<MenuThemeController> {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top App Header Bar
            _buildTopHeader(),

            // 2. Body Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(14.w),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Publish Banner (publish-banner)
                    _buildPublishBanner(),
                    SizedBox(height: 10.h),

                    // Preview Customer Menu (preview-row)
                    _buildPreviewRow(),
                    SizedBox(height: 16.h),

                    // Menu Templates Section Header
                    _buildSectionHeader("Menu Templates"),
                    SizedBox(height: 6.h),

                    // Menu Templates Cards List
                    Obx(() {
                      if (controller.isLoadingTemplates.value) {
                        return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                      }

                      final templates = controller.templates;
                      if (templates.isEmpty) {
                        return Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: Text(
                              "No templates configured",
                              style: GoogleFonts.nunito(fontSize: 13.sp, color: AppColors.textMuted),
                            ),
                          ),
                        );
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppDimensions.radius12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: templates.length,
                          separatorBuilder: (context, index) => const Divider(
                            height: 1,
                            color: Color(0xFFF3F4F6),
                          ),
                          itemBuilder: (context, index) {
                            final template = templates[index];
                            final isMain = template.isActive;

                            return InkWell(
                              onTap: () {
                                Get.bottomSheet(
                                  ThemePickerSheet(template: template),
                                  isScrollControlled: true,
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.all(13.w),
                                child: Row(
                                  children: [
                                    // Icon square
                                    Container(
                                      width: 36.w,
                                      height: 36.h,
                                      decoration: BoxDecoration(
                                        color: isMain ? const Color(0xFFFEF2F2) : const Color(0xFFFFF7ED),
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: Icon(
                                        Icons.description_outlined,
                                        size: 18.sp,
                                        color: isMain ? AppColors.primary : const Color(0xFFF97316),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),

                                    // Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                template.name,
                                                style: GoogleFonts.nunito(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color(0xFF111827),
                                                ),
                                              ),
                                              if (isMain) ...[
                                                SizedBox(width: 6.w),
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFDCFCE7),
                                                    borderRadius: BorderRadius.circular(4.r),
                                                  ),
                                                  child: Text(
                                                    "Active",
                                                    style: GoogleFonts.nunito(
                                                      fontSize: 9.sp,
                                                      fontWeight: FontWeight.w700,
                                                      color: const Color(0xFF16A34A),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            "${template.name} · Used in 3 sessions · 344 items",
                                            style: GoogleFonts.nunito(
                                              fontSize: 10.sp,
                                              color: const Color(0xFF6B7280),
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          // Theme chip
                                          Row(
                                            children: [
                                              Container(
                                                width: 10.w,
                                                height: 10.h,
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius: BorderRadius.circular(2.r),
                                                ),
                                              ),
                                              SizedBox(width: 4.w),
                                              Text(
                                                "Theme: ${template.name}",
                                                style: GoogleFonts.nunito(
                                                  fontSize: 10.sp,
                                                  color: const Color(0xFF6B7280),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      size: 18.sp,
                                      color: const Color(0xFF9CA3AF),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                    SizedBox(height: 18.h),

                    // Active Sessions Schedule Section
                    _buildSectionHeader("Sessions Schedule Configuration"),
                    SizedBox(height: 6.h),

                    Obx(() {
                      if (controller.isLoadingSessions.value) {
                        return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                      }

                      final sessions = controller.sessions;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: sessions.length,
                        itemBuilder: (context, index) {
                          final session = sessions[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 8.h),
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppDimensions.radius12),
                              border: Border.all(
                                color: session.isActive ? const Color(0xFF16A34A) : const Color(0xFFE5E7EB),
                                width: session.isActive ? 1.5.w : 1.w,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: session.isActive
                                        ? const Color(0xFFDCFCE7)
                                        : const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    Icons.access_time_filled_rounded,
                                    size: 20.sp,
                                    color: session.isActive
                                        ? const Color(0xFF16A34A)
                                        : const Color(0xFF9CA3AF),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        session.name,
                                        style: GoogleFonts.nunito(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF111827),
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        "${session.startTime} – ${session.endTime} · Dine-In menu",
                                        style: GoogleFonts.nunito(
                                          fontSize: 10.5.sp,
                                          color: const Color(0xFF6B7280),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.settings_outlined, size: 18.sp, color: const Color(0xFF9CA3AF)),
                                  onPressed: () {
                                    Get.bottomSheet(
                                      SessionEditSheet(session: session),
                                      isScrollControlled: true,
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Prototype Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: 58.h,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: const Color(0xFFF3F4F6), width: 1.h)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.grid_view_rounded, "Dashboard", isSelected: false, route: '/dashboard'),
            _buildNavItem(Icons.flatware_rounded, "Items", isSelected: false, route: '/items'),
            _buildNavItem(Icons.palette_rounded, "Themes", isSelected: true, route: '/menu'),
            _buildNavItem(Icons.qr_code_2_rounded, "Share", isSelected: false, route: '/share'),
          ],
        ),
      ),
    );
  }

  Widget _buildPublishBanner() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E293B),
            Color(0xFF334155),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(9.r),
            ),
            child: Icon(Icons.cloud_upload_outlined, color: Colors.white, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Publish Menu",
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Customers see your latest changes after publishing.",
                  style: GoogleFonts.nunito(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    "3 changes pending",
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Obx(() {
            final isPub = controller.isPublishing.value;
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: isPub ? null : () => controller.publishMenuChanges(),
              child: Text(
                isPub ? "..." : "Publish Now",
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPreviewRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.remove_red_eye_outlined, size: 18.sp, color: const Color(0xFF3B82F6)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Preview Customer Menu",
                  style: GoogleFonts.nunito(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
                Text(
                  "See exactly what your customers see",
                  style: GoogleFonts.nunito(
                    fontSize: 10.5.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, size: 18.sp, color: const Color(0xFF9CA3AF)),
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.menu_rounded, color: Colors.white, size: 20.sp),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "eResto",
                        style: GoogleFonts.nunito(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF111827),
                        ),
                      ),
                      Text(
                        "Plus",
                        style: GoogleFonts.nunito(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Trulyy Tadkaaz",
                    style: GoogleFonts.nunito(
                      fontSize: 10.sp,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_none_rounded, size: 22.sp, color: const Color(0xFF374151)),
                onPressed: () {},
                constraints: const BoxConstraints(),
                padding: EdgeInsets.all(6.w),
              ),
              SizedBox(width: 8.w),
              CircleAvatar(
                radius: 14.r,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  "CI",
                  style: GoogleFonts.nunito(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.nunito(
        fontSize: 14.sp,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF111827),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {required bool isSelected, required String route}) {
    return InkWell(
      onTap: () {
        if (!isSelected) {
          Get.offAllNamed(route);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 22.sp,
            color: isSelected ? AppColors.primary : const Color(0xFF9CA3AF),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 11.sp,
              color: isSelected ? AppColors.primary : const Color(0xFF9CA3AF),
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
