import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/services/toast_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/share_controller.dart';
import '../../domain/models/tnc_model.dart';

/// Unified, Enterprise Bottom Sheet for Terms & Conditions.
/// Supports both VIEW MODE (with copy & edit button) and EDIT/CREATE MODE
/// (with name field, line-by-line inputs, "+ Add Line", and save action).
class TncBottomSheet extends StatefulWidget {
  final TncModel? initialItem;
  final bool startInEditMode;

  const TncBottomSheet({
    super.key,
    this.initialItem,
    this.startInEditMode = false,
  });

  static void show(
    BuildContext context, {
    TncModel? item,
    bool startInEditMode = false,
  }) {
    final controller = Get.find<ShareController>();
    if (startInEditMode || item == null) {
      if (item != null) {
        controller.selectTncForEdit(item);
      } else {
        controller.startNewTnc();
      }
    } else {
      controller.selectTncForEdit(item);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TncBottomSheet(
        initialItem: item,
        startInEditMode: startInEditMode || item == null,
      ),
    );
  }

  @override
  State<TncBottomSheet> createState() => _TncBottomSheetState();
}

class _TncBottomSheetState extends State<TncBottomSheet> {
  final ShareController controller = Get.find<ShareController>();
  late bool isEditing;
  TncModel? currentItem;

  @override
  void initState() {
    super.initState();
    isEditing = widget.startInEditMode;
    currentItem = widget.initialItem;
  }

  void _switchToEditMode() {
    HapticFeedback.lightImpact();
    if (currentItem != null) {
      controller.selectTncForEdit(currentItem!);
    } else {
      controller.startNewTnc();
    }
    setState(() {
      isEditing = true;
    });
  }

  void _switchToViewMode() {
    HapticFeedback.lightImpact();
    setState(() {
      isEditing = false;
    });
  }

  void _copyAllRules() {
    final lines = currentItem?.lines ?? [];
    if (lines.isEmpty) return;

    final buffer = StringBuffer();
    buffer.writeln("${currentItem?.tncName ?? 'Terms & Conditions'}:");
    for (int i = 0; i < lines.length; i++) {
      buffer.writeln("${i + 1}. ${lines[i]}");
    }
    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ToastService.showSuccess("All rules copied to clipboard!");
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.86,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Column(
        children: [
          // Drag Handle
          Container(
            width: 38.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 10.h, bottom: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFD1D5DB),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header
          _buildHeader(),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),

          // Body Content
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: isEditing ? _buildEditBody() : _buildViewBody(),
            ),
          ),

          // Bottom Action Footer
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildBottomBar(),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Header
  // --------------------------------------------------------------------------
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          if (isEditing && widget.initialItem != null) ...[
            IconButton(
              onPressed: _switchToViewMode,
              icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18.sp, color: const Color(0xFF374151)),
              splashRadius: 18.r,
              tooltip: "Back to View",
            ),
            SizedBox(width: 4.w),
          ],
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: Icon(
              isEditing ? Icons.edit_note_rounded : Icons.article_outlined,
              color: AppColors.primary,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEditing
                      ? (widget.initialItem != null ? "Edit Template" : "New Template")
                      : (currentItem?.tncName ?? "Terms & Conditions"),
                  style: GoogleFonts.nunito(
                    fontSize: 15.5.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),
                Text(
                  isEditing
                      ? "Configure template name & clauses"
                      : "${currentItem?.formattedDate.isNotEmpty == true ? '${currentItem!.formattedDate} • ' : ''}${currentItem?.lines.length ?? 0} rules",
                  style: GoogleFonts.nunito(
                    fontSize: 11.5.sp,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close_rounded, size: 22.sp, color: const Color(0xFF6B7280)),
            splashRadius: 20.r,
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // View Mode Body
  // --------------------------------------------------------------------------
  Widget _buildViewBody() {
    final lines = currentItem?.lines ?? [];

    return Column(
      key: const ValueKey("view_mode"),
      children: [
        // Quick Action Bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _copyAllRules,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF374151),
                    side: const BorderSide(color: Color(0xFFD1D5DB)),
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                  ),
                  icon: const Icon(Icons.copy_rounded, size: 15),
                  label: Text(
                    "Copy All Rules",
                    style: GoogleFonts.nunito(fontSize: 12.sp, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              OutlinedButton.icon(
                onPressed: () => _confirmDelete(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFEF4444),
                  side: const BorderSide(color: Color(0xFFFCA5A5)),
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
                icon: const Icon(Icons.delete_outline_rounded, size: 16),
                label: Text(
                  "Delete",
                  style: GoogleFonts.nunito(fontSize: 12.sp, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),

        // Rules List
        Expanded(
          child: lines.isEmpty
              ? Center(
                  child: Text(
                    "No rule clauses added yet.",
                    style: GoogleFonts.nunito(fontSize: 13.sp, color: const Color(0xFF9CA3AF)),
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 16.h),
                  physics: const BouncingScrollPhysics(),
                  itemCount: lines.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    final line = lines[index];
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
                            width: 22.w,
                            height: 22.w,
                            margin: EdgeInsets.only(top: 1.h),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFEF2F2),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "${index + 1}",
                              style: GoogleFonts.nunito(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: SelectableText(
                              line,
                              style: GoogleFonts.nunito(
                                fontSize: 13.sp,
                                color: const Color(0xFF374151),
                                fontWeight: FontWeight.w600,
                                height: 1.35,
                              ),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: line));
                              ToastService.showSuccess("Clause copied!");
                            },
                            borderRadius: BorderRadius.circular(6.r),
                            child: Padding(
                              padding: EdgeInsets.all(4.w),
                              child: Icon(
                                Icons.copy_rounded,
                                size: 14.sp,
                                color: const Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // Edit / Create Mode Body
  // --------------------------------------------------------------------------
  Widget _buildEditBody() {
    return SingleChildScrollView(
      key: const ValueKey("edit_mode"),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Template Name Label
          Text(
            "Template Name *",
            style: GoogleFonts.nunito(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF374151),
            ),
          ),
          SizedBox(height: 6.h),
          TextFormField(
            controller: controller.tncNameCtrl,
            style: GoogleFonts.nunito(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
            decoration: InputDecoration(
              hintText: "Enter template name (e.g. Dine-In Rules)",
              hintStyle: GoogleFonts.nunito(fontSize: 12.5.sp, color: const Color(0xFF9CA3AF)),
              contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
            ),
          ),
          SizedBox(height: 18.h),

          // Terms & Condition Rules Label & "+ Add Line" Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Condition Clauses *",
                style: GoogleFonts.nunito(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF374151),
                ),
              ),
              InkWell(
                onTap: () => controller.addTncLine(),
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded, size: 14.sp, color: AppColors.primary),
                      SizedBox(width: 4.w),
                      Text(
                        "Add Line",
                        style: GoogleFonts.nunito(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Line by line inputs
          Obx(
            () => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.tncLineCtrls.length,
              separatorBuilder: (_, __) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                final ctrl = controller.tncLineCtrls[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 22.w,
                      height: 22.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "${index + 1}",
                        style: GoogleFonts.nunito(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextFormField(
                        controller: ctrl,
                        maxLines: null,
                        style: GoogleFonts.nunito(
                          fontSize: 12.5.sp,
                          color: const Color(0xFF1F2937),
                        ),
                        decoration: InputDecoration(
                          hintText: "Enter rule or clause text...",
                          hintStyle: GoogleFonts.nunito(fontSize: 12.sp, color: const Color(0xFF9CA3AF)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    InkWell(
                      onTap: () => controller.removeTncLine(index),
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        width: 36.w,
                        height: 38.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: 18.sp,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Bottom Action Bar
  // --------------------------------------------------------------------------
  Widget _buildBottomBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: isEditing ? _buildEditFooter() : _buildViewFooter(),
    );
  }

  Widget _buildViewFooter() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _switchToEditMode,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 13.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          elevation: 0,
        ),
        icon: const Icon(Icons.edit_rounded, size: 17),
        label: Text(
          "Edit Template",
          style: GoogleFonts.nunito(fontSize: 14.sp, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _buildEditFooter() {
    return Row(
      children: [
        if (widget.initialItem != null) ...[
          Expanded(
            flex: 1,
            child: OutlinedButton(
              onPressed: _switchToViewMode,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF4B5563),
                side: const BorderSide(color: Color(0xFFD1D5DB)),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text(
                "Cancel",
                style: GoogleFonts.nunito(fontSize: 13.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          SizedBox(width: 10.w),
        ],
        Expanded(
          flex: 2,
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isSavingTnc.value ? null : _saveTemplate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                elevation: 0,
              ),
              child: controller.isSavingTnc.value
                  ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      widget.initialItem != null ? "Save Changes" : "Create Template",
                      style: GoogleFonts.nunito(fontSize: 13.5.sp, fontWeight: FontWeight.w800),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveTemplate() async {
    final success = await controller.saveTnc();
    if (success && mounted) {
      if (widget.initialItem != null) {
        setState(() {
          currentItem = controller.selectedTnc.value;
          isEditing = false;
        });
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  void _confirmDelete() {
    final item = currentItem;
    if (item == null) return;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          "Delete Template",
          style: GoogleFonts.nunito(fontWeight: FontWeight.w800, fontSize: 16.sp),
        ),
        content: Text(
          "Are you sure you want to delete '${item.tncName}'? This action cannot be undone.",
          style: GoogleFonts.nunito(fontSize: 12.5.sp, color: const Color(0xFF4B5563)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: GoogleFonts.nunito(color: const Color(0xFF6B7280), fontWeight: FontWeight.w700),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Navigator.of(context).pop();
              controller.deleteTnc(item);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              elevation: 0,
            ),
            child: Text(
              "Delete",
              style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
