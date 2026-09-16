import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/manage_items_controller.dart';

class MenuCategoriesSheet extends StatelessWidget {
  final ManageItemsController controller;

  const MenuCategoriesSheet({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      constraints: BoxConstraints(maxHeight: 0.75.sh),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 36.w,
              height: 4.h,
              margin: EdgeInsets.only(top: 10.h, bottom: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            // Header Bar matching Image 5
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Menu Categories",
                          style: GoogleFonts.nunito(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Drag ≡ to reorder · Tap + to add new",
                          style: GoogleFonts.nunito(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC1272D),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: () => Get.back(),
                    child: Text(
                      "Done",
                      style: GoogleFonts.nunito(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),

            // Scrollable List of Menu Categories
            Flexible(
              child: Obx(() {
                final order = controller.menuCatOrder;
                return ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  itemCount: order.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF9FAFB)),
                  itemBuilder: (context, pos) {
                    final mcIdx = order[pos];
                    final mc = controller.menuCategories[mcIdx];

                    int selectedCount = 0;
                    int totalCount = 0;
                    for (final ci in mc.catIndices) {
                      if (ci < controller.categories.length) {
                        selectedCount += controller.categories[ci].orderedSelected.length;
                        totalCount += controller.categories[ci].items.length;
                      }
                    }

                    final isFirst = pos == 0;
                    final isLast = pos == order.length - 1;

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                      child: Row(
                        children: [
                          // 3-Bar Drag Handle
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Column(
                              children: [
                                Container(width: 14.w, height: 1.5.h, color: const Color(0xFFC4C9D4)),
                                SizedBox(height: 2.h),
                                Container(width: 14.w, height: 1.5.h, color: const Color(0xFFC4C9D4)),
                                SizedBox(height: 2.h),
                                Container(width: 14.w, height: 1.5.h, color: const Color(0xFFC4C9D4)),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.w),

                          // Category Icon Box
                          Container(
                            width: 28.w,
                            height: 28.h,
                            decoration: BoxDecoration(
                              color: mc.color,
                              borderRadius: BorderRadius.circular(7.r),
                            ),
                            child: Center(
                              child: Icon(
                                mc.iconData,
                                size: 15.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),

                          // Name and Subtitle Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mc.name,
                                  style: GoogleFonts.nunito(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF111827),
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  "${mc.catIndices.length} categories · $selectedCount/$totalCount items",
                                  style: GoogleFonts.nunito(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Up / Down Reorder Buttons
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: isFirst ? null : () => controller.moveMenuCategory(pos, -1),
                                borderRadius: BorderRadius.circular(4.r),
                                child: Container(
                                  width: 24.w,
                                  height: 22.h,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xFFE5E7EB)),
                                    borderRadius: BorderRadius.circular(4.r),
                                    color: isFirst ? const Color(0xFFF9FAFB) : Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.keyboard_arrow_up_rounded,
                                    size: 16.sp,
                                    color: isFirst ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              InkWell(
                                onTap: isLast ? null : () => controller.moveMenuCategory(pos, 1),
                                borderRadius: BorderRadius.circular(4.r),
                                child: Container(
                                  width: 24.w,
                                  height: 22.h,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xFFE5E7EB)),
                                    borderRadius: BorderRadius.circular(4.r),
                                    color: isLast ? const Color(0xFFF9FAFB) : Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 16.sp,
                                    color: isLast ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),

            // Add Menu Category action
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 4.h, 14.w, 14.h),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFC1272D),
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  minimumSize: Size(double.infinity, 36.h),
                ),
                onPressed: () => controller.addMenuCategory(),
                icon: const Icon(Icons.add_rounded, size: 16),
                label: Text(
                  "Add Category Section",
                  style: GoogleFonts.nunito(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
