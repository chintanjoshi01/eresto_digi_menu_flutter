import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../controllers/share_controller.dart';
import '../../domain/models/tnc_model.dart';

/// Terms & Conditions Master Bottom Sheet matching Screenshots 1, 2, and 3.
class TncSheet extends StatelessWidget {
  const TncSheet({super.key});

  static void show(BuildContext context) {
    final controller = Get.find<ShareController>();
    controller.fetchTnc();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const TncSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShareController>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Red Header Bar matching Screenshot 1
          _buildRedHeader(context, controller),

          // Scrollable Body
          Expanded(
            child: Obx(() {
              if (controller.isLoadingTnc.value && controller.tncList.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  16.w,
                  16.h,
                  16.w,
                  24.h + MediaQuery.of(context).padding.bottom,
                ),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TOP SECTION: Terms Condition Master
                    _buildMasterListSection(controller),
                    SizedBox(height: 20.h),

                    // BOTTOM SECTION: Terms & Conditions Template Editor
                    _buildTemplateEditorSection(controller),
                    SizedBox(height: 24.h),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Red Header Bar (Screenshot 1)
  // --------------------------------------------------------------------------

  Widget _buildRedHeader(BuildContext context, ShareController controller) {
    return Container(
      padding: EdgeInsets.fromLTRB(18.w, 14.h, 12.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Terms Condition Master",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Obx(
                  () => Text(
                    "${controller.restoName.value} • Customer Terms & Rules",
                    style: GoogleFonts.poppins(
                      fontSize: 11.sp,
                      color: Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close_rounded, color: Colors.white, size: 22.sp),
            splashRadius: 20.r,
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // TOP SECTION: Terms Condition Master List
  // --------------------------------------------------------------------------

  Widget _buildMasterListSection(ShareController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Terms Condition Master",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            // "+ New" Red Pill Button
            ElevatedButton.icon(
              onPressed: () => controller.startNewTnc(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
                elevation: 0,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: Icon(Icons.add_rounded, size: 14.sp),
              label: Text(
                "New",
                style: GoogleFonts.poppins(fontSize: 11.5.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),

        // List of Template Cards
        if (controller.tncList.isEmpty)
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Center(
              child: Text(
                "No terms templates found. Tap + New to create one.",
                style: GoogleFonts.poppins(fontSize: 12.sp, color: const Color(0xFF9CA3AF)),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.tncList.length,
            separatorBuilder: (_, __) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              final item = controller.tncList[index];
              return _buildTemplateCard(controller, item);
            },
          ),
      ],
    );
  }

  Widget _buildTemplateCard(ShareController controller, TncModel item) {
    final isSelected = controller.selectedTnc.value?.id == item.id && controller.isEditingTnc.value;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
          width: isSelected ? 1.8.w : 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Red Template Icon Badge
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.article_outlined,
              color: AppColors.primary,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 12.w),

          // Name and Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.tncName,
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  item.formattedDate.isNotEmpty ? item.formattedDate : "Terms Template",
                  style: GoogleFonts.poppins(
                    fontSize: 10.5.sp,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),

          // Action Icons: Duplicate, Delete, Edit
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Duplicate Icon
              IconButton(
                onPressed: () => controller.duplicateTnc(item),
                icon: Icon(Icons.copy_rounded, size: 17.sp, color: const Color(0xFF9CA3AF)),
                splashRadius: 16.r,
                tooltip: "Duplicate",
              ),
              // Delete Icon
              IconButton(
                onPressed: () => _confirmDeleteTnc(controller, item),
                icon: Icon(Icons.delete_outline_rounded, size: 18.sp, color: const Color(0xFFEF4444)),
                splashRadius: 16.r,
                tooltip: "Delete",
              ),
              // Edit Icon
              IconButton(
                onPressed: () => controller.selectTncForEdit(item),
                icon: Icon(Icons.edit_outlined, size: 18.sp, color: AppColors.primary),
                splashRadius: 16.r,
                tooltip: "Edit",
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTnc(ShareController controller, TncModel item) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        title: Text(
          "Delete Template",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          "Are you sure you want to delete '${item.tncName}'? This action cannot be undone.",
          style: GoogleFonts.poppins(fontSize: 12.5.sp, color: const Color(0xFF4B5563)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel", style: GoogleFonts.poppins(color: const Color(0xFF6B7280))),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteTnc(item);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: Text("Delete", style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // BOTTOM SECTION: Terms & Conditions Template Editor (Screenshots 1, 2, 3)
  // --------------------------------------------------------------------------

  Widget _buildTemplateEditorSection(ShareController controller) {
    final isEditing = controller.isEditingTnc.value;
    final isSaving = controller.isSavingTnc.value;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
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
          // Section Header with "Save" button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  isEditing ? "Edit Terms & Conditions" : "New Terms & Conditions",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              ElevatedButton(
                onPressed: isSaving ? null : () => controller.saveTnc(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
                  elevation: 0,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: isSaving
                    ? SizedBox(
                        width: 14.w,
                        height: 14.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        "Save",
                        style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w700),
                      ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Name Field
          Text(
            "Name",
            style: GoogleFonts.poppins(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF4B5563),
            ),
          ),
          SizedBox(height: 6.h),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: TextField(
              controller: controller.tncNameCtrl,
              style: GoogleFonts.poppins(fontSize: 13.sp, color: const Color(0xFF111827)),
              decoration: InputDecoration(
                hintText: "e.g. Standard T&C",
                hintStyle: GoogleFonts.poppins(fontSize: 12.sp, color: const Color(0xFF9CA3AF)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Terms & Condition Text header row with "+ Add Line" button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Terms & Condition Text",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4B5563),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              OutlinedButton.icon(
                onPressed: () => controller.addTncLine(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary, width: 1.2),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(Icons.add_rounded, size: 13.sp, color: AppColors.primary),
                label: Text(
                  "Add Line",
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // List of Terms Lines
          Obx(
            () => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.tncLineCtrls.length,
              separatorBuilder: (_, __) => SizedBox(height: 8.h),
              itemBuilder: (context, lineIndex) {
                final lineCtrl = controller.tncLineCtrls[lineIndex];
                return Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: TextField(
                          controller: lineCtrl,
                          style: GoogleFonts.poppins(fontSize: 12.sp, color: const Color(0xFF111827)),
                          decoration: InputDecoration(
                            hintText: "Enter condition text...",
                            hintStyle: GoogleFonts.poppins(fontSize: 11.sp, color: const Color(0xFF9CA3AF)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    // Trash can to remove line
                    IconButton(
                      onPressed: () => controller.removeTncLine(lineIndex),
                      icon: Icon(Icons.delete_outline_rounded, size: 18.sp, color: const Color(0xFF9CA3AF)),
                      splashRadius: 16.r,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
