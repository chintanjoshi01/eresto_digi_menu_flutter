import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../controllers/items_controller.dart';
import '../widgets/item_card.dart';
import 'item_edit_sheet.dart';

class ItemsScreen extends GetView<ItemsController> {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final isTablet = shortestSide >= 550;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Menu Items",
          style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, size: 24.sp, color: AppColors.text),
            onPressed: () => controller.fetchItems(forceRefresh: true),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: TextField(
              onChanged: (val) => controller.searchItems(val),
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText: "Search items by name or code...",
                hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                prefixIcon: Icon(Icons.search_rounded, size: 20.sp, color: AppColors.textMuted),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radius8),
                  borderSide: BorderSide(color: AppColors.border, width: 1.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radius8),
                  borderSide: BorderSide(color: AppColors.borderLight, width: 1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radius8),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
                ),
              ),
            ),
          ),

          // 2. Category Tabs list
          Obx(() {
            final categories = controller.categoriesList;
            if (categories.isEmpty) return const SizedBox();

            return Container(
              height: 38.h,
              margin: EdgeInsets.only(bottom: 8.h),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: categories.length + 1,
                itemBuilder: (context, index) {
                  final cat = index == 0 ? '' : categories[index - 1];
                  final label = index == 0 ? 'All' : cat;
                  final isSelected = controller.selectedCategory.value == cat;

                  return GestureDetector(
                    onTap: () => controller.changeCategory(cat),
                    child: Container(
                      margin: EdgeInsets.only(right: 8.w),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(AppDimensions.radius20),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.borderLight,
                          width: 1.w,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        label,
                        style: AppTypography.bodySmall.copyWith(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),

          // 3. Grid of Items
          Expanded(
            child: controller.obx(
              (state) {
                if (state == null || state.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restaurant_rounded, size: 48.sp, color: AppColors.textMuted),
                        SizedBox(height: 12.h),
                        Text("No Items Found", style: AppTypography.bodyLarge),
                        SizedBox(height: 4.h),
                        Text("Try modifying search filters", style: AppTypography.caption),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.all(16.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isTablet ? 4 : 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: isTablet ? 0.95 : 0.85,
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
              onLoading: const Center(child: CircularProgressIndicator()),
              onError: (err) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48.sp, color: AppColors.primary),
                    SizedBox(height: 12.h),
                    Text(err ?? "Error loading items", style: AppTypography.bodyLarge),
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
      bottomNavigationBar: Container(
        height: AppDimensions.bottomNavHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: 1.h)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.dashboard_rounded, "Dashboard", isSelected: false, route: '/dashboard'),
            _buildNavItem(Icons.flatware_rounded, "Items", isSelected: true, route: '/items'),
            _buildNavItem(Icons.palette_rounded, "Themes", isSelected: false, route: '/menu'),
            _buildNavItem(Icons.qr_code_2_rounded, "Share", isSelected: false, route: '/share'),
          ],
        ),
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
            size: AppDimensions.icon24,
            color: isSelected ? AppColors.primary : AppColors.textMuted,
          ),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
