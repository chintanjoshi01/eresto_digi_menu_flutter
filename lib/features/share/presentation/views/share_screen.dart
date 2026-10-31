import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/eresto_top_header.dart';
import '../controllers/share_controller.dart';
import '../widgets/download_menu_pdf_sheet.dart';
import 'terms_condition_master_screen.dart';

/// Enterprise Share & More Screen matching Screenshot 1 and HTML Prototype v41/v42.
class ShareScreen extends GetView<ShareController> {
  final bool isEmbedded;

  const ShareScreen({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    final content = RefreshIndicator(
      onRefresh: () => controller.fetchDigitalMenuLinks(),
      color: AppColors.primary,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(14.w),
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Column(
          children: [
            // Main Dine-In / Channel QR Code Card
            _buildQrCard(context),
            SizedBox(height: 14.h),

            // Share & Export Options List
            _buildShareOptionsList(context),
            SizedBox(height: 24.h),
          ],
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
        child: const ErestoTopHeader(),
      ),
      body: SafeArea(child: content),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
    );
  }

  // --------------------------------------------------------------------------
  // Main QR Code Card
  // --------------------------------------------------------------------------

  Widget _buildQrCard(BuildContext context) {
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
          // Dynamic Channel Tabs Row with Auto-scroll
          Obx(() {
            if (controller.isLoadingLinks.value && controller.digitalChannels.isEmpty) {
              return SizedBox(
                height: 32.h,
                child: const Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              controller: controller.tabScrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: controller.digitalChannels.map((ch) {
                  return Padding(
                    padding: EdgeInsets.only(right: 6.w),
                    child: _buildDynamicQrTab(ch),
                  );
                }).toList(),
              ),
            );
          }),
          SizedBox(height: 14.h),

          // Swipeable QR Carousel with brand overlay & nav arrows
          SizedBox(
            height: 254.h,
            child: Obx(() {
              if (controller.isLoadingLinks.value && controller.digitalChannels.isEmpty) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                );
              }

              return Stack(
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    controller: controller.qrPageController,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: controller.onQrPageChanged,
                    itemCount: controller.digitalChannels.length,
                    itemBuilder: (context, index) {
                      final channel = controller.digitalChannels[index];
                      final qrKey = controller.getQrKey(index);
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: RepaintBoundary(
                          key: qrKey,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(color: const Color(0xFFF3F4F6)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    QrImageView(
                                      data: channel.fullUrl,
                                      version: QrVersions.auto,
                                      errorCorrectionLevel: QrErrorCorrectLevel.H,
                                      size: 164.w,
                                      padding: const EdgeInsets.all(4.0),
                                      eyeStyle: const QrEyeStyle(
                                        eyeShape: QrEyeShape.square,
                                        color: Color(0xFF111827),
                                      ),
                                      dataModuleStyle: const QrDataModuleStyle(
                                        dataModuleShape: QrDataModuleShape.square,
                                        color: Color(0xFF111827),
                                      ),
                                    ),
                                    // Official eResto "o" Cutlery Plate Badge
                                    Container(
                                      width: 34.w,
                                      height: 34.w,
                                      padding: EdgeInsets.all(2.5.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2.w),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.12),
                                            blurRadius: 4,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: Image.asset(
                                          'assets/images/eresto_qr_plate_logo.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "${controller.restoName.value} • ${channel.name}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF6B7280),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Previous page arrow (if not on first page)
                  if (controller.activeChannelIndex.value > 0)
                    Positioned(
                      left: 8.w,
                      child: _buildNavArrow(
                        icon: Icons.chevron_left_rounded,
                        onTap: () => controller.selectChannelByIndex(controller.activeChannelIndex.value - 1),
                      ),
                    ),
                  // Next page arrow (if not on last page)
                  if (controller.activeChannelIndex.value < controller.digitalChannels.length - 1)
                    Positioned(
                      right: 8.w,
                      child: _buildNavArrow(
                        icon: Icons.chevron_right_rounded,
                        onTap: () => controller.selectChannelByIndex(controller.activeChannelIndex.value + 1),
                      ),
                    ),
                ],
              );
            }),
          ),
          SizedBox(height: 10.h),

          // Elegant Animated Carousel Indicator Dots
          Obx(() {
            if (controller.digitalChannels.length <= 1) return const SizedBox.shrink();
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(controller.digitalChannels.length, (idx) {
                final isCurrent = idx == controller.activeChannelIndex.value;
                return GestureDetector(
                  onTap: () => controller.selectChannelByIndex(idx),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutCubic,
                    margin: EdgeInsets.symmetric(horizontal: 2.5.w),
                    height: 5.h,
                    width: isCurrent ? 18.w : 5.w,
                    decoration: BoxDecoration(
                      color: isCurrent ? AppColors.primary : const Color(0xFFD1D5DB),
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ),
                );
              }),
            );
          }),
          SizedBox(height: 10.h),

          // QR URL Row Box with Copy button
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
                      style: GoogleFonts.poppins(
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
                  borderRadius: BorderRadius.circular(4.r),
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Icon(
                      Icons.copy_rounded,
                      size: 15.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),

          // Action Buttons: Download QR & Share
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    final activeKey = controller.getQrKey(controller.activeChannelIndex.value);
                    controller.generateAndPrintQrPdf(activeKey);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 11.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.r),
                    ),
                    elevation: 0,
                  ),
                  icon: Icon(Icons.download_rounded, size: 15.sp),
                  label: Text(
                    "Download QR",
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    final activeKey = controller.getQrKey(controller.activeChannelIndex.value);
                    controller.triggerNativeShare(activeKey);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF374151),
                    padding: EdgeInsets.symmetric(vertical: 11.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.r),
                    ),
                    elevation: 0,
                  ),
                  icon: Icon(Icons.share_outlined, size: 15.sp, color: const Color(0xFF374151)),
                  label: Text(
                    "Share",
                    style: GoogleFonts.poppins(
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

  // --------------------------------------------------------------------------
  // Share & Export Options List
  // --------------------------------------------------------------------------

  Widget _buildShareOptionsList(BuildContext context) {
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
          // WhatsApp
          _buildShareOptionItem(
            icon: Icons.chat_bubble_outline_rounded,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF25D366),
            title: "Share on WhatsApp",
            subtitle: "Send menu link to customers",
            onTap: () => controller.shareToWhatsApp(),
          ),
          const Divider(height: 1, color: Color(0xFFF9FAFB)),

          // Instagram
          _buildShareOptionItem(
            icon: Icons.camera_alt_outlined,
            iconBg: const Color(0xFFFDF2F8),
            iconColor: const Color(0xFFE1306C),
            title: "Share to Instagram",
            subtitle: "Post your menu link in bio",
            onTap: () => controller.shareToInstagram(),
          ),
          const Divider(height: 1, color: Color(0xFFF9FAFB)),

          // Download Menu as PDF
          _buildShareOptionItem(
            icon: Icons.picture_as_pdf_outlined,
            iconBg: const Color(0xFFFEF2F2),
            iconColor: AppColors.primary,
            title: "Download Menu as PDF",
            subtitle: "A4 portrait · Classic / Card / Compact",
            onTap: () => DownloadMenuPdfSheet.show(context),
          ),
          const Divider(height: 1, color: Color(0xFFF9FAFB)),

          // Download Tables QR (ZIP)
          Obx(() {
            final isDownloading = controller.isDownloadingZip.value;
            return _buildShareOptionItem(
              icon: Icons.qr_code_2_rounded,
              iconBg: const Color(0xFFF0F9FF),
              iconColor: const Color(0xFF0891B2),
              title: "Download Tables QR",
              subtitle: "Individual QR codes for each table (zip)",
              trailingWidget: isDownloading
                  ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0891B2)),
                      ),
                    )
                  : null,
              onTap: isDownloading ? () {} : () => controller.downloadTableQrZip(),
            );
          }),
          const Divider(height: 1, color: Color(0xFFF9FAFB)),

          // Terms & Conditions
          _buildShareOptionItem(
            icon: Icons.gavel_rounded,
            iconBg: const Color(0xFFFEF9C3),
            iconColor: const Color(0xFFCA8A04),
            title: "Terms & Conditions",
            subtitle: "View and edit your terms for customers",
            onTap: () => Get.to(() => const TermsConditionMasterScreen()),
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
    Widget? trailingWidget,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 19.sp, color: iconColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 10.5.sp,
                      color: const Color(0xFF9CA3AF),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            trailingWidget ??
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18.sp,
                  color: const Color(0xFFD1D5DB),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavArrow({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.white.withOpacity(0.92),
      shape: const CircleBorder(),
      elevation: 2.5,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Icon(icon, size: 20.sp, color: const Color(0xFF374151)),
        ),
      ),
    );
  }

  Widget _buildDynamicQrTab(dynamic channel) {
    final slug = channel.slug as String;
    final name = channel.name as String;

    return Obx(() {
      final isSelected = controller.activeChannelSlug.value == slug;

      return GestureDetector(
        onTap: () => controller.selectChannel(channel),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 11.5.sp,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF4B5563),
            ),
          ),
        ),
      );
    });
  }
}
