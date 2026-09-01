import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../controllers/menu_theme_controller.dart';
import '../widgets/theme_picker_sheet.dart';
import '../widgets/session_edit_sheet.dart';

class MenuScreen extends GetView<MenuThemeController> {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final isTablet = shortestSide >= 550;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Menu Templates & Sessions",
          style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, size: 24.sp, color: AppColors.text),
            onPressed: () => controller.loadData(forceRefresh: true),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Publish Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Publish Updates", style: AppTypography.h3),
                    Text("Push menu updates live to customers", style: AppTypography.caption),
                  ],
                ),
                Obx(() {
                  final loading = controller.isPublishing.value;
                  return ElevatedButton.icon(
                    onPressed: loading ? null : () => controller.publishMenuChanges(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radius8),
                      ),
                    ),
                    icon: loading
                        ? SizedBox(
                            width: 16.w,
                            height: 16.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Icon(Icons.cloud_upload_outlined, size: 18.sp),
                    label: Text("Publish Live", style: AppTypography.button.copyWith(fontSize: 12.sp)),
                  );
                }),
              ],
            ),
            Divider(height: 32.h, color: AppColors.borderLight),

            // 1. Templates Themes Selection
            Text("Select Template Theme", style: AppTypography.h3),
            SizedBox(height: 12.h),
            Obx(() {
              if (controller.isLoadingTemplates.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final templates = controller.templates;
              if (templates.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Text("No templates configured", style: AppTypography.bodySmall),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet ? 3 : 1,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: isTablet ? 1.8 : 2.5,
                ),
                itemCount: templates.length,
                itemBuilder: (context, index) {
                  final template = templates[index];
                  final primColor = Color(int.parse(template.primaryColor));
                  final bgColor = Color(int.parse(template.backgroundColor));
                  final textColor = Color(int.parse(template.textColor));

                  return GestureDetector(
                    onTap: () => controller.selectTheme(template.id),
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppDimensions.radius12),
                        border: Border.all(
                          color: template.isActive ? AppColors.primary : AppColors.borderLight,
                          width: template.isActive ? 2.w : 1.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 8,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                template.name,
                                style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                              ),
                              if (template.isActive)
                                Icon(Icons.check_circle_rounded, size: 20.sp, color: AppColors.primary)
                              else
                                GestureDetector(
                                  onTap: () {
                                    Get.bottomSheet(
                                      ThemePickerSheet(template: template),
                                      isScrollControlled: true,
                                    );
                                  },
                                  child: Icon(Icons.settings_suggest_rounded, size: 18.sp, color: AppColors.textMuted),
                                ),
                            ],
                          ),
                          const Spacer(),
                          // Theme Colors bar representing preview
                          Container(
                            height: 28.h,
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(AppDimensions.radius4),
                              border: Border.all(color: Colors.grey.shade200, width: 1.w),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(width: 8.w, height: 8.w, decoration: BoxDecoration(color: primColor, shape: BoxShape.circle)),
                                SizedBox(width: 6.w),
                                Text("Preview Text", style: TextStyle(color: textColor, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
            SizedBox(height: 24.h),

            // 2. Active Session overriding
            Text("Sessions Schedule Configuration", style: AppTypography.h3),
            SizedBox(height: 12.h),
            Obx(() {
              if (controller.isLoadingSessions.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final sessions = controller.sessions;
              if (sessions.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Text("No sessions configured", style: AppTypography.bodySmall),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(AppDimensions.space16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.radius12),
                      border: Border.all(
                        color: session.isActive ? AppColors.success : AppColors.borderLight,
                        width: session.isActive ? 1.5.w : 1.w,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: session.isActive ? AppColors.successLight : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(AppDimensions.radius8),
                          ),
                          child: Icon(
                            Icons.timer_outlined,
                            size: 24.sp,
                            color: session.isActive ? AppColors.success : AppColors.textMuted,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                session.name,
                                style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "Schedule: ${session.startTime} - ${session.endTime}",
                                style: AppTypography.bodySmall,
                              ),
                              if (session.offerDescription != null && session.offerDescription!.isNotEmpty) ...[
                                SizedBox(height: 6.h),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.warningLight,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Text(
                                    session.offerDescription!,
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.warning,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.settings_outlined, size: 20.sp, color: AppColors.textMuted),
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
      bottomNavigationBar: Container(
        height: AppDimensions.bottomNavHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: 1.h)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.dashboard_rounded, "Dashboard", isSelected: false, route: '/dashboard'),
            _buildNavItem(Icons.flatware_rounded, "Items", isSelected: false, route: '/items'),
            _buildNavItem(Icons.palette_rounded, "Themes", isSelected: true, route: '/menu'),
            _buildNavItem(Icons.qr_code_2_rounded, "Share", isSelected: false, route: '/share'),
          ],
        ),
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
