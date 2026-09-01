import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/brand_progress_indicator.dart';
import '../controllers/menu_dashboard_controller.dart';
import '../widgets/active_session_strip.dart';
import '../widgets/dashboard_hero_card.dart';
import '../widgets/qr_scan_analytics_card.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/top_categories_list.dart';
import '../widgets/unpublished_status_banner.dart';

/// Enterprise Dashboard View matching eresto_menu_mobile_v5.html prototype specs.
class DashboardScreen extends GetView<MenuDashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: controller.obx(
          (state) {
            if (state == null) return const SizedBox.shrink();

            return Column(
              children: [
                // 1. Prototype Top App Header Bar
                _buildTopHeader(state.restaurantName),

                // 2. Scrollable Body Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Overlapping Hero + Analytics Stack
                        SizedBox(
                          width: double.infinity,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Hero Background Banner
                              Padding(
                                padding: EdgeInsets.only(bottom: 100.h),
                                child: DashboardHeroCard(
                                  restaurantName: state.restaurantName,
                                  restaurantUrl: state.restaurantUrl,
                                  isPublished: state.isPublished,
                                  totalItems: state.totalItems,
                                  availableItems: state.availableItems,
                                  hiddenItems: state.hiddenItems,
                                ),
                              ),
                              // Overlapping Scans Analytics Card
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Obx(
                                  () => QrScanAnalyticsCard(
                                    totalScans: state.qrScansToday,
                                    deltaPercent: state.qrScanDeltaPercent,
                                    activePeriod: controller.selectedPeriod.value,
                                    onPeriodChanged: (p) => controller.changePeriod(p),
                                    chartData: state.scanChartData,
                                    chartLabels: state.scanChartLabels,
                                    avgScansPerHour: state.avgScansPerHour,
                                    peakScans: state.peakScans,
                                    yesterdayScans: state.yesterdayScans,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),

                        // Menu Status Banner
                        _buildSectionHeader("Menu Status"),
                        UnpublishedStatusBanner(
                          count: state.unpublishedChangesCount,
                          summary: state.unpublishedChangesSummary,
                          onPublishPressed: () => Get.toNamed('/menu'),
                        ),

                        // Active Session Strip
                        _buildSectionHeader("Active Now"),
                        ActiveSessionStrip(
                          sessionName: state.activeSessionName,
                          sessionTime: state.activeSessionTime,
                        ),

                        // Top Categories Today
                        _buildSectionHeader(
                          "Top Categories Today",
                          actionText: "by views",
                        ),
                        TopCategoriesList(
                          categories: state.topCategories,
                        ),

                        // Quick Actions Grid
                        _buildSectionHeader("Quick Actions"),
                        QuickActionsGrid(
                          onAllItemsPressed: () => Get.toNamed('/items'),
                          onPublishPressed: () => Get.toNamed('/menu'),
                          onQrSharePressed: () => Get.toNamed('/share'),
                          onAddItemPressed: () => Get.toNamed('/items'),
                        ),

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          onLoading: const Center(
            child: BrandProgressIndicator(size: 44, color: AppColors.primary),
          ),
          onError: (err) => Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded, size: 48.sp, color: AppColors.primary),
                  SizedBox(height: 12.h),
                  Text(
                    err ?? "Failed to load dashboard data",
                    style: GoogleFonts.nunito(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radius8),
                      ),
                    ),
                    onPressed: () => controller.fetchAnalytics(forceRefresh: true),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // Aligned Prototype Bottom Navigation Bar
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
            _buildNavItem(Icons.grid_view_rounded, "Dashboard", isSelected: true, route: '/dashboard'),
            _buildNavItem(Icons.flatware_rounded, "Items", isSelected: false, route: '/items'),
            _buildNavItem(Icons.palette_rounded, "Themes", isSelected: false, route: '/menu'),
            _buildNavItem(Icons.qr_code_2_rounded, "Share", isSelected: false, route: '/share'),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader(String subtitle) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Menu Icon + Brand Title & Subtitle
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
                    subtitle,
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
          // Right: Notification Bell & Profile Avatar
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

  Widget _buildSectionHeader(String title, {String? actionText}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.nunito(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF111827),
            ),
          ),
          if (actionText != null)
            Text(
              actionText,
              style: GoogleFonts.nunito(
                fontSize: 11.sp,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
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
