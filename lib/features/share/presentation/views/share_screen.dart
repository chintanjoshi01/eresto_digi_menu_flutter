import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../controllers/share_controller.dart';

/// Enterprise Share Screen matching eresto_menu_mobile_v5.html prototype specs.
class ShareScreen extends GetView<ShareController> {
  final GlobalKey _qrKey = GlobalKey();

  ShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Prototype Top App Header Bar
            _buildTopHeader(),

            // 2. Scrollable Body Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(14.w),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Main QR Code Card (qr-card)
                    _buildQrCard(),
                    SizedBox(height: 14.h),

                    // Share Options List (share-list)
                    _buildShareOptionsList(),
                    SizedBox(height: 24.h),
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
            _buildNavItem(Icons.palette_rounded, "Themes", isSelected: false, route: '/menu'),
            _buildNavItem(Icons.qr_code_2_rounded, "Share", isSelected: true, route: '/share'),
          ],
        ),
      ),
    );
  }

  Widget _buildQrCard() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // QR Tabs Row (qr-tabs)
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildQrTab("dine_in", "dine-in QR Code"),
                SizedBox(width: 6.w),
                _buildQrTab("ird", "ird QR Code"),
                SizedBox(width: 6.w),
                _buildQrTab("tables", "Tables"),
              ],
            ),
          ),
          SizedBox(height: 14.h),

          // QR Canvas Wrapper Container (qr-wrap)
          RepaintBoundary(
            key: _qrKey,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Center(
                child: Obx(() {
                  final url = controller.qrUrl.value;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      QrImageView(
                        data: url,
                        version: QrVersions.auto,
                        size: 130.w,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Color(0xFF111827),
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Color(0xFF111827),
                        ),
                      ),
                      // eR Brand Center Logo Badge
                      Container(
                        width: 22.w,
                        height: 22.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(color: AppColors.primary, width: 1.5.w),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "eR",
                          style: GoogleFonts.nunito(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // QR URL Row Box (qr-url-row)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Obx(
                    () => Text(
                      controller.qrUrl.value,
                      style: GoogleFonts.nunito(
                        fontSize: 11.sp,
                        color: const Color(0xFF374151),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                InkWell(
                  onTap: () => controller.copyUrl(),
                  child: Icon(
                    Icons.copy_rounded,
                    size: 14.sp,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),

          // Action Buttons (qr-btns)
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => controller.generateAndPrintPdf(_qrKey),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  icon: Icon(Icons.download_rounded, size: 14.sp),
                  label: Text(
                    "Download QR",
                    style: GoogleFonts.nunito(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => controller.triggerNativeShare(_qrKey),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF3F4F6),
                    foregroundColor: const Color(0xFF374151),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  icon: Icon(Icons.share_outlined, size: 14.sp, color: const Color(0xFF374151)),
                  label: Text(
                    "Share",
                    style: GoogleFonts.nunito(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF374151),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareOptionsList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildShareOptionItem(
            icon: Icons.chat_bubble_outline_rounded,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF25D366),
            title: "Share on WhatsApp",
            subtitle: "Send menu link to customers",
            onTap: () => controller.triggerNativeShare(_qrKey),
          ),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          _buildShareOptionItem(
            icon: Icons.camera_alt_outlined,
            iconBg: const Color(0xFFFDF2F8),
            iconColor: const Color(0xFFE1306C),
            title: "Share to Instagram",
            subtitle: "Post your menu link in bio",
            onTap: () => controller.triggerNativeShare(_qrKey),
          ),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          _buildShareOptionItem(
            icon: Icons.copy_rounded,
            iconBg: const Color(0xFFEFF6FF),
            iconColor: const Color(0xFF3B82F6),
            title: "Copy Menu Link",
            subtitle: controller.qrUrl.value,
            onTap: () => controller.copyUrl(),
          ),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          _buildShareOptionItem(
            icon: Icons.picture_as_pdf_outlined,
            iconBg: const Color(0xFFFEF2F2),
            iconColor: AppColors.primary,
            title: "Download Menu as PDF",
            subtitle: "A4 portrait · Classic / Card / Compact",
            onTap: () => controller.generateAndPrintPdf(_qrKey),
          ),
        ],
      ),
    );
  }

  Widget _buildShareOptionItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(9.r),
              ),
              child: Icon(icon, size: 18.sp, color: iconColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.nunito(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.nunito(
                      fontSize: 10.5.sp,
                      color: const Color(0xFF6B7280),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
  }

  Widget _buildQrTab(String id, String label) {
    final isSelected = controller.activeQrTab.value == id;
    return GestureDetector(
      onTap: () => controller.updateQrTab(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 10.5.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF4B5563),
          ),
        ),
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
              InkWell(
                onTap: () => Get.toNamed('/profile'),
                child: CircleAvatar(
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
              ),
            ],
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
