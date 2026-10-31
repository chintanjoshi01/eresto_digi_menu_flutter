import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../controllers/share_controller.dart';

/// Interactive Editor Dialog for creating or updating a Terms & Conditions template,
/// featuring line-by-line inputs and "+ Add Line" functionality matching Screenshots 1, 2, and 3.
class TncEditDialog extends StatelessWidget {
  const TncEditDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const TncEditDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShareController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      elevation: 10,
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: 440.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dialog Header
            Container(
              padding: EdgeInsets.fromLTRB(18.w, 14.h, 12.w, 14.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                border: const Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34.w,
                    height: 34.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.edit_note_rounded,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Obx(
                      () => Text(
                        controller.isEditingTnc.value
                            ? "Edit Terms & Conditions"
                            : "New Terms & Conditions",
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close_rounded, color: const Color(0xFF6B7280), size: 20.sp),
                    splashRadius: 18.r,
                  ),
                ],
              ),
            ),

            // Scrollable Form Fields
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Field
                    Text(
                      "Template Name *",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF374151),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: TextField(
                        controller: controller.tncNameCtrl,
                        style: GoogleFonts.poppins(fontSize: 13.sp, color: const Color(0xFF111827)),
                        decoration: InputDecoration(
                          hintText: "e.g. T & C, Dining Policy",
                          hintStyle: GoogleFonts.poppins(fontSize: 12.sp, color: const Color(0xFF9CA3AF)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),

                    // Terms Lines Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Terms & Condition Text *",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF374151),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        // "+ Add Line" Button
                        ElevatedButton.icon(
                          onPressed: () => controller.addTncLine(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFEF2F2),
                            foregroundColor: AppColors.primary,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.r),
                              side: const BorderSide(color: AppColors.primary, width: 1.2),
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: Icon(Icons.add_rounded, size: 14.sp),
                          label: Text(
                            "Add Line",
                            style: GoogleFonts.poppins(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    // List of Condition Lines
                    Obx(
                      () => ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.tncLineCtrls.length,
                        separatorBuilder: (_, __) => SizedBox(height: 8.h),
                        itemBuilder: (context, index) {
                          final lineCtrl = controller.tncLineCtrls[index];
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
                                    maxLines: null,
                                    style: GoogleFonts.poppins(fontSize: 12.sp, color: const Color(0xFF111827)),
                                    decoration: InputDecoration(
                                      hintText: "Enter clause or policy line...",
                                      hintStyle: GoogleFonts.poppins(fontSize: 11.sp, color: const Color(0xFF9CA3AF)),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 6.w),
                              // Trash button
                              IconButton(
                                onPressed: () => controller.removeTncLine(index),
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  size: 18.sp,
                                  color: const Color(0xFF9CA3AF),
                                ),
                                splashRadius: 16.r,
                                tooltip: "Remove line",
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1, color: Color(0xFFE5E7EB)),

            // Footer Actions
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFD1D5DB)),
                        padding: EdgeInsets.symmetric(vertical: 11.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      ),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF4B5563),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    flex: 2,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isSavingTnc.value
                            ? null
                            : () async {
                                await controller.saveTnc();
                                if (!controller.isSavingTnc.value && context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 11.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                          elevation: 0,
                        ),
                        child: controller.isSavingTnc.value
                            ? SizedBox(
                                width: 16.w,
                                height: 16.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                "Save Template",
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
