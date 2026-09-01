import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../controllers/share_controller.dart';

class ShareScreen extends GetView<ShareController> {
  final GlobalKey _qrKey = GlobalKey();

  ShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final isTablet = shortestSide >= 550;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Share Digital Menu",
          style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.space24),
          child: Container(
            width: isTablet ? 480.w : double.infinity,
            padding: EdgeInsets.all(AppDimensions.space24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radius16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. RepaintBoundary wrapper around QR card flyer for clean capture
                RepaintBoundary(
                  key: _qrKey,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(AppDimensions.space16),
                    child: Column(
                      children: [
                        Text(
                          "SCAN TO VIEW MENU",
                          style: AppTypography.h3.copyWith(
                            letterSpacing: 2,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Obx(() {
                          final url = controller.qrUrl.value;
                          if (url.isEmpty) return const SizedBox();
                          return QrImageView(
                            data: url,
                            version: QrVersions.auto,
                            size: 200.w,
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: AppColors.primary,
                            ),
                            dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: Colors.black,
                            ),
                          );
                        }),
                        SizedBox(height: 16.h),
                        Text(
                          "Powered by eResto",
                          style: AppTypography.caption.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // 2. URL Copy link block
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppDimensions.radius8),
                    border: Border.all(color: AppColors.borderLight, width: 1.w),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(() => Text(
                              controller.qrUrl.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySmall,
                            )),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy_all_rounded, size: 20.sp, color: AppColors.primary),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: controller.qrUrl.value));
                          ToastService.showSuccess("Link copied to clipboard");
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28.h),

                // 3. Actions Row
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => controller.triggerNativeShare(_qrKey),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radius8),
                          ),
                          elevation: 0,
                        ),
                        icon: Icon(Icons.share_rounded, size: 18.sp),
                        label: Text("Share QR", style: AppTypography.button.copyWith(color: AppColors.primary)),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Obx(() {
                        final loading = controller.isGeneratingPdf.value;
                        return ElevatedButton.icon(
                          onPressed: loading ? null : () => controller.generateAndPrintPdf(_qrKey),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radius8),
                            ),
                            elevation: 0,
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
                              : Icon(Icons.print_rounded, size: 18.sp),
                          label: Text("Print PDF", style: AppTypography.button),
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
            _buildNavItem(Icons.palette_rounded, "Themes", isSelected: false, route: '/menu'),
            _buildNavItem(Icons.qr_code_2_rounded, "Share", isSelected: true, route: '/share'),
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
