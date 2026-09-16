import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/eresto_top_header.dart';
import '../../../main/presentation/controllers/main_shell_controller.dart';
import '../controllers/menu_dashboard_controller.dart';
import '../widgets/active_session_grid.dart';
import '../widgets/dashboard_hero_card.dart';
import '../widgets/dashboard_shimmer_skeleton.dart';
import '../widgets/qr_scan_analytics_card.dart';
import '../widgets/quick_actions_grid.dart';

/// Enterprise Dashboard View matching eresto_menu_mobile_v41.html prototype specs.
class DashboardScreen extends GetView<MenuDashboardController> {
  final bool isEmbedded;

  const DashboardScreen({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    final content = controller.obx(
      (state) {
        if (state == null) return const DashboardShimmerSkeleton();

        return RefreshIndicator(
          onRefresh: () => controller.refreshDashboard(),
          color: AppColors.primary,
          backgroundColor: Colors.white,
          strokeWidth: 2.5,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Header Banner (Solid Red)
                DashboardHeroCard(
                  restaurantName: state.restaurantName,
                  restaurantUrl: state.restaurantUrl,
                  isPublished: state.isPublished,
                  totalItems: state.totalItems,
                  totalCategories: state.totalCategories,
                  onItemsTap: () {
                    if (Get.isRegistered<MainShellController>()) {
                      Get.find<MainShellController>().changeTab(1);
                    } else {
                      Get.toNamed('/items');
                    }
                  },
                ),

                // Overlapping Scans Analytics Card
                Transform.translate(
                  offset: Offset(0, -20.h),
                  child: Obx(
                    () => QrScanAnalyticsCard(
                      totalScans: state.totalScans,
                      deltaPercent: state.deltaPercent,
                      activePeriod: controller.selectedPeriod.value,
                      onPeriodChanged: (p) => controller.changePeriod(p),
                      selectedMenuFilter: controller.selectedMenuFilter.value,
                      onMenuFilterChanged: (f) => controller.changeMenuFilter(f),
                      menuServices: controller.menuServices,
                      chartData: state.scanChartData,
                      chartLabels: state.scanChartLabels,
                      peakHour: state.peakHour,
                      peakScans: state.peakScans,
                      yesterdayScans: state.yesterdayScans,
                      margin: EdgeInsets.symmetric(horizontal: 12.w),
                    ),
                  ),
                ),

                // Active Sessions 2x2 Grid with real LIVE / UPCOMING tags
                _buildSectionHeader(
                  "Active Now",
                  actionText: state.sessionSummaryText,
                ),
                ActiveSessionGrid(
                  sessions: state.activeSessions,
                  onSessionTapped: () {
                    if (Get.isRegistered<MainShellController>()) {
                      Get.find<MainShellController>().changeTab(2);
                    } else {
                      Get.toNamed('/menu');
                    }
                  },
                ),

                // Quick Actions Grid
                _buildSectionHeader("Quick Actions"),
                QuickActionsGrid(
                  onAllItemsPressed: () {
                    if (Get.isRegistered<MainShellController>()) {
                      Get.find<MainShellController>().changeTab(1);
                    } else {
                      Get.toNamed('/items');
                    }
                  },
                  onPublishPressed: () {
                    if (Get.isRegistered<MainShellController>()) {
                      Get.find<MainShellController>().changeTab(2);
                    } else {
                      Get.toNamed('/menu');
                    }
                  },
                  onQrSharePressed: () {
                    if (Get.isRegistered<MainShellController>()) {
                      Get.find<MainShellController>().changeTab(3);
                    } else {
                      Get.toNamed('/share');
                    }
                  },
                  onAddItemPressed: () {
                    if (Get.isRegistered<MainShellController>()) {
                      Get.find<MainShellController>().changeTab(1);
                    } else {
                      Get.toNamed('/items');
                    }
                  },
                ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      },
      onLoading: const DashboardShimmerSkeleton(),
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
    );

    if (isEmbedded) {
      return content;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(52.h),
        child: ErestoTopHeader(
          subtitle: controller.state?.restaurantName ?? "Trulyy Tadkaaz",
        ),
      ),
      body: SafeArea(child: content),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
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
}
