import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/eresto_top_header.dart';
import '../../../main/presentation/controllers/main_shell_controller.dart';
import '../../../menu/presentation/controllers/menu_theme_controller.dart';
import '../controllers/menu_dashboard_controller.dart';
import '../widgets/active_session_grid.dart';
import '../widgets/dashboard_hero_card.dart';
import '../widgets/dashboard_shimmer_skeleton.dart';
import '../widgets/qr_scan_analytics_card.dart';
import '../widgets/subscription_banner.dart';

/// Enterprise Dashboard View matching eresto_menu_mobile_v41.html prototype specs.
class DashboardScreen extends GetView<MenuDashboardController> {
  final bool isEmbedded;

  const DashboardScreen({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    final content = controller.obx(
      (state) {
        // Defense-in-depth: if subscription is expired, display AppErrorView immediately
        if (controller.isSubscriptionExpired.value) {
          final sub = controller.subscriptionInfo.value;
          return AppErrorView(
            errorMessage: sub?.displayMessage ??
                "Subscription has expired. Please renew your subscription to continue using services.",
            onRetry: () => controller.fetchAnalytics(forceRefresh: true),
            onOfflineMode: () => controller.loadOfflineMode(),
            onRefresh: () => controller.refreshDashboard(),
            onRenew: () => controller.handleSubscriptionRenewal(),
          );
        }

        // Defense-in-depth: if force update is required, display AppErrorView immediately
        if (controller.isForceUpdateRequired.value) {
          return AppErrorView(
            errorMessage: controller.forceUpdateMessage.value,
            latestVersion: controller.latestAvailableVersion.value.isNotEmpty
                ? controller.latestAvailableVersion.value
                : null,
            onRetry: () => controller.fetchAnalytics(forceRefresh: true),
            onOfflineMode: () => controller.loadOfflineMode(),
            onRefresh: () => controller.refreshDashboard(),
          );
        }

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
                // Subscription Status Alert Banner (Flag 2: Expiring Soon, Flag 3: Grace Period)
                Obx(() {
                  final sub = controller.subscriptionInfo.value;
                  if (sub != null && sub.shouldShowWarningBanner) {
                    return SubscriptionBanner(
                      subscription: sub,
                      onRenew: () => controller.handleSubscriptionRenewal(),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                // Hero Header Banner (Solid Red)
                DashboardHeroCard(
                  restaurantName: state.restaurantName,
                  restaurantUrl: state.restaurantUrl,
                  menuUrls: state.menuUrls,
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

                // Active Sessions Grid (Only LIVE sessions, capped to 4 with 'View More' bottom sheet & instant session editor)
                _buildSectionHeader(
                  "Active Now",
                  actionText: state.sessionSummaryText,
                  onActionTap: () {
                    if (Get.isRegistered<MainShellController>()) {
                      Get.find<MainShellController>().changeTab(2);
                    } else {
                      Get.toNamed('/menu');
                    }
                  },
                ),
                ActiveSessionGrid(
                  sessions: state.activeSessions,
                  onViewMoreTapped: () {
                    if (Get.isRegistered<MainShellController>()) {
                      Get.find<MainShellController>().changeTab(2);
                    } else {
                      Get.toNamed('/menu');
                    }
                  },
                  onSessionTapped: (item) {
                    // 1. Switch to Menu Tab
                    if (Get.isRegistered<MainShellController>()) {
                      Get.find<MainShellController>().changeTab(2);
                    } else {
                      Get.toNamed('/menu');
                    }
                    // 2. Smartly focus & open that exact session in Menu
                    if (Get.isRegistered<MenuThemeController>()) {
                      Get.find<MenuThemeController>().focusAndOpenSession(
                        sessionId: item.id,
                        sessionName: item.title,
                        channel: item.channel,
                      );
                    }
                  },
                ),

                SizedBox(height: 28.h),
              ],
            ),
          ),
        );
      },
      onLoading: const DashboardShimmerSkeleton(),
      onError: (err) => Obx(
        () => AppErrorView(
          errorMessage: err,
          latestVersion: controller.latestAvailableVersion.value.isNotEmpty
              ? controller.latestAvailableVersion.value
              : null,
          onRetry: () => controller.fetchAnalytics(forceRefresh: true),
          onOfflineMode: () => controller.loadOfflineMode(),
          onRefresh: () => controller.refreshDashboard(),
          onRenew: () => controller.handleSubscriptionRenewal(),
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

  Widget _buildSectionHeader(String title, {String? actionText, VoidCallback? onActionTap}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTypography.sectionHeader.copyWith(
              fontSize: 14.sp,
              color: const Color(0xFF111827),
            ),
          ),
          if (actionText != null)
            GestureDetector(
              onTap: onActionTap,
              behavior: HitTestBehavior.opaque,
              child: Text(
                actionText,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 11.sp,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
