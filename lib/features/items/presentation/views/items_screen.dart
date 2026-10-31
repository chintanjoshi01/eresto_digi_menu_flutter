import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/eresto_top_header.dart';
import '../controllers/items_controller.dart';
import '../widgets/item_card.dart';
import '../widgets/item_row_card.dart';
import 'item_edit_sheet.dart';
import 'item_filter_sheet.dart';

/// Enterprise Menu Items Screen featuring staggered card animations,
/// instant 0ms cached loading, reactive availability toggles, layout switching,
/// and smart multi-criteria filter bottom sheet.
class ItemsScreen extends StatefulWidget {
  final bool isEmbedded;

  const ItemsScreen({super.key, this.isEmbedded = false});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final controller = Get.find<ItemsController>();

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final isTablet = shortestSide >= 550;

    final content = Column(
      children: [
        if (!widget.isEmbedded)
          const ErestoTopHeader(),

        // 2. Search Bar Box (.items-search)
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 11.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(9.r),
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded, size: 16.sp, color: const Color(0xFF9CA3AF)),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextField(
                    onChanged: (val) => controller.searchItems(val),
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      color: const Color(0xFF111827),
                    ),
                    decoration: InputDecoration(
                      hintText: "Search items, short codes, description",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color: const Color(0xFF9CA3AF),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                    ),
                  ),
                ),
                // Smart Filter Bottomsheet Trigger
                Obx(() {
                  final filterCount = controller.activeFiltersCount;
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Get.bottomSheet(
                        const ItemFilterSheet(),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5.w),
                          decoration: BoxDecoration(
                            color: filterCount > 0 ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Icon(
                            Icons.filter_list_rounded,
                            size: 18.sp,
                            color: filterCount > 0 ? AppColors.primary : const Color(0xFF6B7280),
                          ),
                        ),
                        if (filterCount > 0)
                          Positioned(
                            top: -2,
                            right: -2,
                            child: Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              constraints: BoxConstraints(minWidth: 14.w, minHeight: 14.w),
                              child: Center(
                                  child: Text(
                                    filterCount.toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 8.5.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      height: 1,
                                    ),
                                  ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),

        // 4. Category Pills Row (.cats-row)
        Obx(() {
          final categories = controller.categoriesList;
          final counts = controller.categoryCounts;
          final allCount = (counts['ALL'] ?? 0).toString();

          return Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  _buildCategoryPill('ALL', allCount, controller.selectedCategory.value == ''),
                  ...categories.map((cat) {
                    final count = (counts[cat.toUpperCase()] ?? 0).toString();
                    final isSel = controller.selectedCategory.value == cat;
                    return _buildCategoryPill(cat.toUpperCase(), count, isSel);
                  }),
                ],
              ),
            ),
          );
        }),

        const Divider(height: 1, color: Color(0xFFE5E7EB)),

        // 5. Category Label & Working Layout View Switcher (Grid vs List)
        Obx(() {
          final cat = controller.selectedCategory.value;
          final displayCat = cat.isEmpty ? 'ALL ITEMS' : cat.toUpperCase();
          final count = controller.filteredItems.length;
          final isLoading = controller.status.isLoading;
          final filterCount = controller.activeFiltersCount;
          final isGrid = controller.isGridView.value;

          final countText = isLoading && count == 0
              ? "$displayCat · Loading..."
              : "$displayCat · $count ${count == 1 ? 'ITEM' : 'ITEMS'}";

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left: Category Name + Count & Active Filter Indicator
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          countText,
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF374151),
                            letterSpacing: 0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (filterCount > 0) ...[
                        SizedBox(width: 6.w),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => controller.resetFilters(),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDF1F1),
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(color: const Color(0xFFF5D0D1), width: 1.w),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Filtered ($filterCount)",
                                  style: GoogleFonts.poppins(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Icon(Icons.close_rounded, size: 10.sp, color: AppColors.primary),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Right: Layout Switcher Buttons (Grid [::] and List [=])
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Grid View Toggle Button
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => controller.toggleLayout(true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: isGrid ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(7.r),
                          border: Border.all(
                            color: isGrid ? AppColors.primary : const Color(0xFFE5E7EB),
                            width: 1.5.w,
                          ),
                          boxShadow: isGrid
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.25),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1.5),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.grid_view_rounded,
                            size: 16.sp,
                            color: isGrid ? Colors.white : const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    // List View Toggle Button
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => controller.toggleLayout(false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: !isGrid ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(7.r),
                          border: Border.all(
                            color: !isGrid ? AppColors.primary : const Color(0xFFE5E7EB),
                            width: 1.5.w,
                          ),
                          boxShadow: !isGrid
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.25),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1.5),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.view_agenda_rounded,
                            size: 16.sp,
                            color: !isGrid ? Colors.white : const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),

        // 6. High-Performance Grid or List View with Staggered Animations
        Expanded(
          child: controller.obx(
            (state) {
              if (state == null || state.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () => controller.refreshItems(),
                  color: AppColors.primary,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: 80.h),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.flatware_rounded, size: 48.sp, color: const Color(0xFF9CA3AF)),
                            SizedBox(height: 12.h),
                            Text(
                              "No Items Found",
                              style: GoogleFonts.poppins(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "Try modifying search filters or pull down to refresh",
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                            if (controller.activeFiltersCount > 0) ...[
                              SizedBox(height: 12.h),
                              TextButton.icon(
                                onPressed: () => controller.resetFilters(),
                                icon: const Icon(Icons.refresh_rounded, size: 16, color: AppColors.primary),
                                label: Text(
                                  "Reset All Filters",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Obx(() {
                final isGrid = controller.isGridView.value;

                return RefreshIndicator(
                  onRefresh: () => controller.refreshItems(),
                  color: AppColors.primary,
                  child: isGrid
                      ? GridView.builder(
                          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          addAutomaticKeepAlives: false,
                          addRepaintBoundaries: true,
                          cacheExtent: 600,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isTablet ? 4 : 2,
                            crossAxisSpacing: 10.w,
                            mainAxisSpacing: 10.h,
                            childAspectRatio: isTablet ? 0.85 : 0.68,
                          ),
                          itemCount: state.length,
                          itemBuilder: (context, index) {
                            final item = state[index];
                            return _AnimatedGridCard(
                              key: ValueKey('anim_grid_${item.id}_${item.isAvailable}'),
                              index: index,
                              child: ItemCard(
                                key: ValueKey('item_${item.id}_${item.isAvailable}_${item.isFrequentlySold}'),
                                item: item,
                                onAvailabilityChanged: (val) => controller.toggleAvailability(item.id, val),
                                onFsiChanged: (val) => controller.toggleFsi(item.id, val),
                                onEditPressed: () {
                                  Get.bottomSheet(
                                    ItemEditSheet(item: item),
                                    isScrollControlled: true,
                                  );
                                },
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          addAutomaticKeepAlives: false,
                          addRepaintBoundaries: true,
                          cacheExtent: 600,
                          itemCount: state.length,
                          itemBuilder: (context, index) {
                            final item = state[index];
                            return _AnimatedGridCard(
                              key: ValueKey('anim_row_${item.id}_${item.isAvailable}'),
                              index: index,
                              child: ItemRowCard(
                                key: ValueKey('row_${item.id}_${item.isAvailable}_${item.isFrequentlySold}'),
                                item: item,
                                onAvailabilityChanged: (val) => controller.toggleAvailability(item.id, val),
                                onFsiChanged: (val) => controller.toggleFsi(item.id, val),
                                onEditPressed: () {
                                  Get.bottomSheet(
                                    ItemEditSheet(item: item),
                                    isScrollControlled: true,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                );
              });
            },
            onLoading: Obx(() => controller.isGridView.value
                ? _buildShimmerGrid(isTablet)
                : _buildShimmerList()),
            onError: (err) => AppErrorView(
              errorMessage: err,
              onRetry: () => controller.refreshItems(),
              onRefresh: () => controller.refreshItems(),
            ),
          ),
        ),
      ],
    );

    if (widget.isEmbedded) {
      return content;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: SafeArea(child: content),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }

  Widget _buildShimmerGrid(bool isTablet) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE5E7EB),
      highlightColor: const Color(0xFFF9FAFB),
      child: GridView.builder(
        padding: EdgeInsets.all(12.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isTablet ? 4 : 2,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
          childAspectRatio: isTablet ? 0.85 : 0.68,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE5E7EB),
      highlightColor: const Color(0xFFF9FAFB),
      child: ListView.builder(
        padding: EdgeInsets.all(12.w),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 8.h),
            height: 88.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryPill(String name, String count, bool isSelected) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.selectionClick();
        controller.changeCategory(name.toUpperCase() == 'ALL' ? '' : name);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(right: 6.w),
        padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 5.5.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
            width: 1.5.w,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.28),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF4B5563),
              ),
            ),
            SizedBox(width: 4.w),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.24) : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                count,
                style: GoogleFonts.poppins(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : const Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Enterprise staggered card entry animation widget
class _AnimatedGridCard extends StatefulWidget {
  final int index;
  final Widget child;

  const _AnimatedGridCard({super.key, required this.index, required this.child});

  @override
  State<_AnimatedGridCard> createState() => _AnimatedGridCardState();
}

class _AnimatedGridCardState extends State<_AnimatedGridCard> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    // Stagger first 10 items smoothly; instant for deep scrolling items
    if (widget.index < 10) {
      Future.delayed(Duration(milliseconds: widget.index * 25), () {
        if (mounted) _animController.forward();
      });
    } else {
      _animController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: widget.child,
      ),
    );
  }
}
