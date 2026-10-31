import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/services/toast_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/share_controller.dart';
import '../../domain/models/tnc_model.dart';
import 'tnc_edit_dialog.dart';

/// Details Dialog showing the clauses of an existing Terms & Conditions template,
/// with an "Edit" button to open the editor dialog.
class TncDetailsDialog extends StatelessWidget {
  final TncModel item;

  const TncDetailsDialog({super.key, required this.item});

  static void show(BuildContext context, TncModel item) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => TncDetailsDialog(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShareController>();
    final lines = item.lines;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      elevation: 10,
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.80,
          maxWidth: 420.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dialog Header
            Container(
              padding: EdgeInsets.fromLTRB(18.w, 16.h, 12.w, 14.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                border: const Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(Icons.article_rounded, color: AppColors.primary, size: 20.sp),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.tncName,
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF111827),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          item.formattedDate.isNotEmpty
                              ? "Created: ${item.formattedDate}"
                              : "${lines.length} condition rules",
                          style: GoogleFonts.poppins(fontSize: 11.sp, color: const Color(0xFF6B7280)),
                        ),
                      ],
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

            // Clauses List
            Flexible(
              child: lines.isEmpty
                  ? Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Text(
                        "No terms text configured for this template.",
                        style: GoogleFonts.poppins(fontSize: 12.5.sp, color: const Color(0xFF9CA3AF)),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      shrinkWrap: true,
                      itemCount: lines.length,
                      separatorBuilder: (_, __) => SizedBox(height: 8.h),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: const Color(0xFFF3F4F6)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 20.w,
                                height: 20.w,
                                margin: EdgeInsets.only(top: 1.h),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE5E7EB),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "${index + 1}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF374151),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  lines[index],
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    color: const Color(0xFF1F2937),
                                    height: 1.4,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            const Divider(height: 1, color: Color(0xFFE5E7EB)),

            // Dialog Footer with Copy & Edit Buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: item.lines.join('\n')));
                      ToastService.showSuccess("Terms copied to clipboard");
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFD1D5DB)),
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    ),
                    icon: Icon(Icons.copy_rounded, size: 15.sp, color: const Color(0xFF4B5563)),
                    label: Text(
                      "Copy",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close details
                        controller.selectTncForEdit(item);
                        TncEditDialog.show(context); // Open edit dialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                        elevation: 0,
                      ),
                      icon: Icon(Icons.edit_outlined, size: 15.sp),
                      label: Text(
                        "Edit Template",
                        style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w700),
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
