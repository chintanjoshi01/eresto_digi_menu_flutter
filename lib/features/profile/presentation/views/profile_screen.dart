import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/services/toast_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/profile_controller.dart';

/// Enterprise Account & Profile Screen:
/// Displays user credentials, restaurant information, master data synchronization, and secure logout.
class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18.sp,
            color: const Color(0xFF111827),
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Account Profile",
          style: GoogleFonts.nunito(
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF111827),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 550.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. User Identity & Account Card
                  _buildUserAccountCard(context),
                  SizedBox(height: 14.h),

                  // 2. Restaurant & Outlet Details Card
                  _buildRestaurantCard(context),
                  SizedBox(height: 14.h),

                  // 3. Master Catalog Sync Card
                  _buildSyncCard(context),
                  SizedBox(height: 24.h),

                  // 4. Logout Action
                  _buildLogoutSection(context),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 1. User Account & Identity Card
  // --------------------------------------------------------------------------
  Widget _buildUserAccountCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + Name + Role Header
          Row(
            children: [
              // Initials Avatar with Verified Badge
              Stack(
                children: [
                  Container(
                    width: 54.w,
                    height: 54.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Obx(
                      () => Text(
                        controller.initials,
                        style: GoogleFonts.nunito(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -1,
                    right: -1,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        width: 14.w,
                        height: 14.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFF16A34A),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check_rounded, color: Colors.white, size: 10.sp),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 14.w),

              // Name and Designation Pill
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        controller.userName.value,
                        style: GoogleFonts.nunito(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF111827),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Obx(
                      () => Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                        ),
                        child: Text(
                          controller.userRole.value,
                          style: GoogleFonts.nunito(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          SizedBox(height: 14.h),

          // Email Row
          Obx(
            () => _buildInfoRow(
              icon: Icons.email_outlined,
              label: "Email Address",
              value: controller.userEmail.value.isNotEmpty
                  ? controller.userEmail.value
                  : "Not provided",
              onCopy: controller.userEmail.value.isNotEmpty
                  ? () {
                      Clipboard.setData(ClipboardData(text: controller.userEmail.value));
                      ToastService.showSuccess("Email copied to clipboard");
                    }
                  : null,
            ),
          ),
          SizedBox(height: 12.h),

          // Mobile Row
          Obx(
            () => _buildInfoRow(
              icon: Icons.phone_outlined,
              label: "Contact Number",
              value: controller.userMobile.value.isNotEmpty
                  ? controller.userMobile.value
                  : "Not provided",
              onCopy: controller.userMobile.value.isNotEmpty
                  ? () {
                      Clipboard.setData(ClipboardData(text: controller.userMobile.value));
                      ToastService.showSuccess("Contact number copied");
                    }
                  : null,
            ),
          ),
          SizedBox(height: 12.h),

          // Status Row
          Row(
            children: [
              Icon(Icons.shield_outlined, size: 17.sp, color: const Color(0xFF6B7280)),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  "Session Status",
                  style: GoogleFonts.nunito(
                    fontSize: 12.5.sp,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFF16A34A),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      "Active & Connected",
                      style: GoogleFonts.nunito(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF16A34A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 2. Restaurant & Outlet Details Card
  // --------------------------------------------------------------------------
  Widget _buildRestaurantCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.storefront_rounded, size: 17.sp, color: AppColors.primary),
              ),
              SizedBox(width: 10.w),
              Text(
                "Restaurant & Outlet",
                style: GoogleFonts.nunito(
                  fontSize: 14.5.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          SizedBox(height: 14.h),

          // Restaurant Name
          Obx(
            () => _buildInfoRow(
              icon: Icons.business_rounded,
              label: "Restaurant Name",
              value: controller.restaurantName.value,
            ),
          ),
          SizedBox(height: 12.h),

          // Location
          Obx(
            () => _buildInfoRow(
              icon: Icons.location_on_outlined,
              label: "Outlet Location",
              value: controller.restoLocation.value.isNotEmpty
                  ? controller.restoLocation.value
                  : "Main Branch",
            ),
          ),
          SizedBox(height: 12.h),

          // Subscription Plan
          Obx(
            () => _buildInfoRow(
              icon: Icons.workspace_premium_outlined,
              label: "Subscription Plan",
              value: controller.subscription.value.isNotEmpty
                  ? controller.subscription.value
                  : "Standard Plan",
            ),
          ),

          // License Validity
          Obx(() {
            if (controller.validity.value.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: _buildInfoRow(
                icon: Icons.calendar_today_outlined,
                label: "License Validity",
                value: controller.validity.value,
              ),
            );
          }),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 3. Master Data Synchronization Card
  // --------------------------------------------------------------------------
  Widget _buildSyncCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.cloud_sync_rounded, size: 18.sp, color: const Color(0xFF0284C7)),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  "Data Synchronization",
                  style: GoogleFonts.nunito(
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            "Sync your categories, tax templates, price templates, and kitchen settings directly from the cloud server.",
            style: GoogleFonts.nunito(
              fontSize: 12.sp,
              color: const Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
          SizedBox(height: 12.h),

          // Last Synced Timestamp
          Obx(() {
            if (controller.lastSyncTime.value.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  Icon(Icons.access_time_rounded, size: 15.sp, color: const Color(0xFF9CA3AF)),
                  SizedBox(width: 6.w),
                  Text(
                    "Last synchronized: ${controller.lastSyncTime.value}",
                    style: GoogleFonts.nunito(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            );
          }),

          // Sync Action Button
          SizedBox(
            width: double.infinity,
            child: Obx(
              () => OutlinedButton.icon(
                onPressed: controller.isSyncingData.value ? null : () => controller.syncMasterData(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0284C7),
                  side: const BorderSide(color: Color(0xFFBAE6FD)),
                  backgroundColor: const Color(0xFFF0F9FF),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
                icon: controller.isSyncingData.value
                    ? SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0284C7)),
                        ),
                      )
                    : const Icon(Icons.sync_rounded, size: 18),
                label: Text(
                  controller.isSyncingData.value ? "Synchronizing..." : "Sync Master Data Now",
                  style: GoogleFonts.nunito(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 4. Logout Section
  // --------------------------------------------------------------------------
  Widget _buildLogoutSection(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: Obx(
            () => ElevatedButton.icon(
              onPressed: controller.isLoggingOut.value ? null : () => controller.logout(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              icon: controller.isLoggingOut.value
                  ? SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.logout_rounded, size: 18),
              label: Text(
                controller.isLoggingOut.value ? "Signing Out..." : "Sign Out of Station",
                style: GoogleFonts.nunito(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline_rounded, size: 13.sp, color: const Color(0xFF9CA3AF)),
            SizedBox(width: 4.w),
            Text(
              "Session secured with eResto Cloud Authentication",
              style: GoogleFonts.nunito(
                fontSize: 11.sp,
                color: const Color(0xFF9CA3AF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // Reusable Info Row
  // --------------------------------------------------------------------------
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onCopy,
  }) {
    return Row(
      children: [
        Icon(icon, size: 17.sp, color: const Color(0xFF6B7280)),
        SizedBox(width: 10.w),
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 12.5.sp,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (onCopy != null) ...[
          SizedBox(width: 4.w),
          InkWell(
            onTap: onCopy,
            borderRadius: BorderRadius.circular(4.r),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Icon(Icons.copy_rounded, size: 14.sp, color: const Color(0xFF9CA3AF)),
            ),
          ),
        ],
      ],
    );
  }
}
