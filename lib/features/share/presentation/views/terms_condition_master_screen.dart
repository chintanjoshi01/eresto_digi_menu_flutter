import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../controllers/share_controller.dart';
import '../../domain/models/tnc_model.dart';
import '../widgets/tnc_bottom_sheet.dart';

/// Terms & Conditions Master Screen adhering to the standard app theme:
/// - Clean white header with only a back button and title
/// - Clean list of configured T&C templates + "+ New Template" action
/// - Tapping an item opens the unified bottom sheet in View Mode
/// - Editing and creating are seamlessly handled inside the interactive bottom sheet
class TermsConditionMasterScreen extends StatelessWidget {
  const TermsConditionMasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShareController>();

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
          "Terms & Conditions Master",
          style: GoogleFonts.nunito(
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF111827),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchTnc(),
        color: AppColors.primary,
        child: Obx(() {
          if (controller.isLoadingTnc.value && controller.tncList.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2.5),
            );
          }

          if (controller.tncList.isEmpty) {
            return _buildEmptyState(context, controller);
          }

          return ListView(
            padding: EdgeInsets.all(14.w),
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            children: [
              // Header Row: Count & "+ New Template" Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 6.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Configured Templates (${controller.tncList.length})",
                            style: GoogleFonts.nunito(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF374151),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "Tap any template to view or edit",
                            style: GoogleFonts.nunito(
                              fontSize: 11.sp,
                              color: const Color(0xFF9CA3AF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    ElevatedButton.icon(
                      onPressed: () => TncBottomSheet.show(context, startInEditMode: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                        elevation: 0,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
                      label: Text(
                        "New Template",
                        style: GoogleFonts.nunito(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),

              // Templates List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.tncList.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final item = controller.tncList[index];
                  return _buildTncCard(context, item);
                },
              ),
              SizedBox(height: 24.h),
            ],
          );
        }),
      ),
      floatingActionButton: Obx(() {
        if (controller.tncList.isEmpty) return const SizedBox.shrink();
        return FloatingActionButton.extended(
          onPressed: () => TncBottomSheet.show(context, startInEditMode: true),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 3,
          icon: const Icon(Icons.add_rounded, size: 20),
          label: Text(
            "New Template",
            style: GoogleFonts.nunito(fontSize: 13.sp, fontWeight: FontWeight.w800),
          ),
        );
      }),
    );
  }

  // --------------------------------------------------------------------------
  // Individual T&C Card (Tapping opens the View Bottom Sheet)
  // --------------------------------------------------------------------------
  Widget _buildTncCard(BuildContext context, TncModel item) {
    final linesCount = item.lines.length;
    final dateStr = item.formattedDate;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14.r),
      elevation: 0,
      child: InkWell(
        onTap: () => TncBottomSheet.show(context, item: item, startInEditMode: false),
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Red Document Icon Badge
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.article_outlined,
                  color: AppColors.primary,
                  size: 21.sp,
                ),
              ),
              SizedBox(width: 12.w),

              // Title and Date/Rule Count
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.tncName,
                      style: GoogleFonts.nunito(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF111827),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      "${dateStr.isNotEmpty ? '$dateStr • ' : ''}$linesCount ${linesCount == 1 ? 'rule' : 'rules'}",
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
              SizedBox(width: 8.w),

              // Trailing Chevron Indicator
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13.sp,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Empty State
  // --------------------------------------------------------------------------
  Widget _buildEmptyState(BuildContext context, ShareController controller) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 68.w,
              height: 68.w,
              decoration: const BoxDecoration(
                color: Color(0xFFFEF2F2),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.description_outlined, color: AppColors.primary, size: 34.sp),
            ),
            SizedBox(height: 16.h),
            Text(
              "No Terms & Conditions Found",
              style: GoogleFonts.nunito(fontSize: 16.sp, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 6.h),
            Text(
              "Create custom dining policies and house rules for your customers to see on your digital menu.",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(fontSize: 12.sp, color: const Color(0xFF6B7280)),
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: () => TncBottomSheet.show(context, startInEditMode: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                elevation: 0,
              ),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(
                "Create First Template",
                style: GoogleFonts.nunito(fontSize: 13.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
