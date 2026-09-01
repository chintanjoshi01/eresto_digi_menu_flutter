import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../controllers/menu_dashboard_controller.dart';
import '../widgets/qr_scan_chart.dart';

class DashboardScreen extends GetView<MenuDashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final isTablet = shortestSide >= 550;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Menu Dashboard",
          style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, size: 24.sp, color: AppColors.text),
            onPressed: () => controller.fetchAnalytics(forceRefresh: true),
          ),
          IconButton(
            icon: Icon(Icons.logout_rounded, size: 22.sp, color: AppColors.primary),
            onPressed: () async {
              // Perform logout redirection
              Get.offAllNamed('/login');
            },
          ),
          SShiftSpacer(width: 8.w),
        ],
      ),
      body: controller.obx(
        (state) {
          if (state == null) return const SizedBox();

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppDimensions.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Scan Metrics Header Card
                Container(
                  padding: EdgeInsets.all(AppDimensions.space16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Menu Scans",
                                style: AppTypography.bodySmall,
                              ),
                              Text(
                                state.totalScans.toString(),
                                style: AppTypography.h1.copyWith(
                                  fontSize: 32.sp,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          // Period Selector Row
                          Row(
                            children: ['today', 'week', 'month'].map((p) {
                              final isSelected = controller.selectedPeriod.value == p;
                              return GestureDetector(
                                onTap: () => controller.changePeriod(p),
                                child: Container(
                                  margin: EdgeInsets.only(left: 6.w),
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.primaryLight : Colors.transparent,
                                    borderRadius: BorderRadius.circular(AppDimensions.radius16),
                                  ),
                                  child: Text(
                                    p.toUpperCase(),
                                    style: AppTypography.caption.copyWith(
                                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      // Line chart rendering scan values
                      QrScanChart(
                        data: state.scanChartData,
                        labels: state.scanChartLabels,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // 2. Active Session / Templates Grid summary cards
                Text("Management Overview", style: AppTypography.h3),
                SizedBox(height: 10.h),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isTablet ? 3 : 1,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: isTablet ? 1.6 : 2.5,
                  children: [
                    // Published Items Card
                    _buildOverviewCard(
                      icon: Icons.restaurant_menu_rounded,
                      title: "Menu Items",
                      value: "${state.publishedItemsCount} / ${state.totalItems}",
                      subtitle: "Published / Total Items",
                      color: AppColors.success,
                      backgroundColor: AppColors.successLight,
                    ),
                    // Theme Template Card
                    _buildOverviewCard(
                      icon: Icons.palette_outlined,
                      title: "Active Template",
                      value: state.activeTemplateName ?? "Default Theme",
                      subtitle: "Current active visual layout",
                      color: AppColors.primary,
                      backgroundColor: AppColors.primaryLight,
                    ),
                    // Active Session Card
                    _buildOverviewCard(
                      icon: Icons.timer_outlined,
                      title: "Menu Session",
                      value: state.activeSessionName ?? "No Session",
                      subtitle: "Active menu display session",
                      color: AppColors.warning,
                      backgroundColor: AppColors.warningLight,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        onLoading: const Center(child: CircularProgressIndicator()),
        onError: (err) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48.sp, color: AppColors.primary),
              SizedBox(height: 12.h),
              Text(err ?? "Error loading dashboard", style: AppTypography.bodyLarge),
              SizedBox(height: 12.h),
              ElevatedButton(
                onPressed: () => controller.fetchAnalytics(forceRefresh: true),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      ),
      // Aligned Bottom Navigation Placeholder
      bottomNavigationBar: Container(
        height: AppDimensions.bottomNavHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: 1.h)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.dashboard_rounded, "Dashboard", isSelected: true, route: '/dashboard'),
            _buildNavItem(Icons.flatware_rounded, "Items", isSelected: false, route: '/items'),
            _buildNavItem(Icons.palette_rounded, "Themes", isSelected: false, route: '/menu'),
            _buildNavItem(Icons.qr_code_2_rounded, "Share", isSelected: false, route: '/share'),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        border: Border.all(color: AppColors.borderLight, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(AppDimensions.radius4),
                ),
                child: Icon(icon, size: 18.sp, color: color),
              ),
              SShiftSpacer(width: 8.w),
              Text(title, style: AppTypography.bodySmall),
            ],
          ),
          SShiftSpacer(height: 8.h),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.h3.copyWith(fontSize: 16.sp),
          ),
          Text(subtitle, style: AppTypography.caption),
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
            size: AppDimensions.icon24,
            color: isSelected ? AppColors.primary : AppColors.textMuted,
          ),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// Simple spacer widget to avoid duplicate code
class SShiftSpacer extends StatelessWidget {
  final double? width;
  final double? height;
  const SShiftSpacer({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: height);
  }
}
