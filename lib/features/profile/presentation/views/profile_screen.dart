import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../controllers/profile_controller.dart';

/// Enterprise Profile View displaying user details, POS station metadata, and logout.
class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18.sp, color: const Color(0xFF111827)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Account & Station Profile",
          style: GoogleFonts.nunito(
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF111827),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600.w),
              child: Column(
                children: [
                  // 1. User Account Card
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.radius16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28.r,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            "CI",
                            style: GoogleFonts.nunito(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 14.w),
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
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Obx(
                                () => Text(
                                  controller.userEmail.value,
                                  style: GoogleFonts.nunito(
                                    fontSize: 11.5.sp,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6.w,
                                      height: 6.h,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF16A34A),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      "Enterprise POS Synced",
                                      style: GoogleFonts.nunito(
                                        fontSize: 9.5.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF16A34A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // 2. Restaurant Metadata Card
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.radius16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Station & Outlet Details",
                          style: GoogleFonts.nunito(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _buildDetailRow(Icons.store_rounded, "Outlet Name", controller.restaurantName.value),
                        const Divider(height: 16, color: Color(0xFFF3F4F6)),
                        _buildDetailRow(Icons.link_rounded, "Menu Domain", controller.restaurantUrl.value),
                        const Divider(height: 16, color: Color(0xFFF3F4F6)),
                        _buildDetailRow(Icons.point_of_sale_rounded, "POS Station ID", controller.posStationId.value),
                        const Divider(height: 16, color: Color(0xFFF3F4F6)),
                        _buildDetailRow(Icons.access_time_filled_rounded, "Active Session", "Lunch Session (10:30 – 18:30)"),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // 3. System Preferences
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.radius16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "System & Sync Preferences",
                          style: GoogleFonts.nunito(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _buildDetailRow(Icons.storage_rounded, "Offline Isar DB", "361 Items Cached"),
                        const Divider(height: 16, color: Color(0xFFF3F4F6)),
                        _buildDetailRow(Icons.notifications_active_rounded, "Push Alerts", "Firebase Cloud Messaging"),
                        const Divider(height: 16, color: Color(0xFFF3F4F6)),
                        _buildDetailRow(Icons.print_rounded, "Thermal Printer", "Network ESC/POS (Auto-Cut)"),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // 4. Logout Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: Obx(
                      () => ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC1272D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radius12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: controller.isLoggingOut.value ? null : () => controller.logout(),
                        icon: Icon(Icons.logout_rounded, size: 18.sp),
                        label: Text(
                          controller.isLoggingOut.value ? "Logging out..." : "Logout Account",
                          style: GoogleFonts.nunito(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: const Color(0xFF6B7280)),
        SizedBox(width: 10.w),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 12.sp,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.nunito(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}
