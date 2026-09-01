import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../controllers/items_controller.dart';
import '../widgets/item_card.dart';
import 'item_edit_sheet.dart';

/// Enterprise Menu Items Screen matching eresto_menu_mobile_v5.html prototype specs.
class ItemsScreen extends GetView<ItemsController> {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final isTablet = shortestSide >= 550;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Prototype Top App Header Bar
            _buildTopHeader(),

            // 2. Search Bar Box (items-search)
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 8.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
                ),
                child: TextField(
                  onChanged: (val) => controller.searchItems(val),
                  style: GoogleFonts.nunito(
                    fontSize: 13.sp,
                    color: const Color(0xFF111827),
                  ),
                  decoration: InputDecoration(
                    hintText: "Search items, short codes, description...",
                    hintStyle: GoogleFonts.nunito(
                      fontSize: 12.sp,
                      color: const Color(0xFF9CA3AF),
                    ),
                    prefixIcon: Icon(Icons.search_rounded, size: 18.sp, color: const Color(0xFF9CA3AF)),
                    suffixIcon: Icon(Icons.filter_list_rounded, size: 16.sp, color: const Color(0xFF9CA3AF)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                ),
              ),
            ),

            // 3. Horizontal Category Pills Row (cats-row)
            Obx(() {
              final categories = controller.categoriesList;
              return Container(
                height: 34.h,
                margin: EdgeInsets.only(bottom: 8.h),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  itemCount: categories.length + 1,
                  itemBuilder: (context, index) {
                    final cat = index == 0 ? '' : categories[index - 1];
                    final label = index == 0 ? 'ALL ITEMS' : cat.toUpperCase();
                    final count = index == 0 ? '361' : '${12 + index * 3}';
                    final isSelected = controller.selectedCategory.value == cat;

                    return GestureDetector(
                      onTap: () => controller.changeCategory(cat),
                      child: Container(
                        margin: EdgeInsets.only(right: 6.w),
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
                            width: 1.w,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              label,
                              style: GoogleFonts.nunito(
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? Colors.white : const Color(0xFF4B5563),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white.withOpacity(0.25)
                                    : const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                count,
                                style: GoogleFonts.nunito(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),

            // 4. Count Bar & Bulk Actions
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "All Items (361)",
                    style: GoogleFonts.nunito(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      "Bulk Available / Disable",
                      style: GoogleFonts.nunito(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF374151),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 6.h),

            // 5. Grid View of Demo Menu Items
            Expanded(
              child: controller.obx(
                (state) {
                  if (state == null || state.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.flatware_rounded, size: 48.sp, color: AppColors.textMuted),
                          SizedBox(height: 12.h),
                          Text(
                            "No Items Found",
                            style: GoogleFonts.nunito(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Try modifying search filters",
                            style: GoogleFonts.nunito(
                              fontSize: 12.sp,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: EdgeInsets.all(14.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isTablet ? 4 : 2,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.h,
                      childAspectRatio: isTablet ? 0.90 : 0.70,
                    ),
                    itemCount: state.length,
                    itemBuilder: (context, index) {
                      final item = state[index];
                      return ItemCard(
                        item: item,
                        onAvailabilityChanged: (val) => controller.toggleAvailability(item.id, val),
                        onEditPressed: () {
                          Get.bottomSheet(
                            ItemEditSheet(item: item),
                            isScrollControlled: true,
                          );
                        },
                      );
                    },
                  );
                },
                onLoading: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                onError: (err) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline_rounded, size: 48.sp, color: AppColors.primary),
                      SizedBox(height: 12.h),
                      Text(
                        err ?? "Error loading items",
                        style: GoogleFonts.nunito(fontSize: 14.sp, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                        onPressed: () => controller.fetchItems(forceRefresh: true),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
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
            _buildNavItem(Icons.flatware_rounded, "Items", isSelected: true, route: '/items'),
            _buildNavItem(Icons.palette_rounded, "Themes", isSelected: false, route: '/menu'),
            _buildNavItem(Icons.qr_code_2_rounded, "Share", isSelected: false, route: '/share'),
          ],
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
