import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/manage_items_controller.dart';
import '../widgets/menu_categories_sheet.dart';

class ManageItemsScreen extends StatefulWidget {
  const ManageItemsScreen({super.key});

  @override
  State<ManageItemsScreen> createState() => _ManageItemsScreenState();
}

class _ManageItemsScreenState extends State<ManageItemsScreen> {
  late final ManageItemsController controller;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    final tmplName = args?['templateName'] as String? ?? 'Multi Menu';
    final isMulti = args?['isMultiMenu'] as bool? ?? true;

    if (Get.isRegistered<ManageItemsController>()) {
      controller = Get.find<ManageItemsController>();
    } else {
      controller = Get.put(ManageItemsController(
        templateName: tmplName,
        isMultiMenu: isMulti,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Red Header Bar matching Image 4
            _buildCrimsonHeader(),

            // 2. Main Content based on Sub-Tabs
            Expanded(
              child: Obx(() {
                final tab = controller.activeTab.value;
                if (tab == 'select') {
                  return _buildSelectItemsTab();
                } else {
                  return _buildOrderItemsTab();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 1. CRIMSON HEADER (Matching Image 4 & Prototype)
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildCrimsonHeader() {
    return Container(
      color: const Color(0xFFC1272D),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Back · Title · Save Changes
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 8.h),
            child: Row(
              children: [
                // Circular back button
                InkWell(
                  onTap: () => Get.back(),
                  borderRadius: BorderRadius.circular(15.r),
                  child: Container(
                    width: 30.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),

                // Screen title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.templateName,
                        style: GoogleFonts.poppins(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: -0.3,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "Manage Items",
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                // Save Changes Pill Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFC1272D),
                    elevation: 2,
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.r),
                    ),
                  ),
                  onPressed: () => controller.saveChanges(),
                  icon: Icon(Icons.check_rounded, size: 14.sp, color: const Color(0xFFC1272D)),
                  label: Text(
                    "Save Changes",
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFC1272D),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Row 2: Context summary
          Obx(() {
            final mc = controller.currentMenuCategory;
            final catCount = controller.activeCatIndices.length;
            final sel = controller.selectedItemsInCurrentSection;
            final tot = controller.totalItemsInCurrentSection;

            return Padding(
              padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$catCount categories",
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      controller.isMultiMenu ? "${mc.name} $sel/$tot items" : "$sel / $tot items in menu",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    controller.isMultiMenu ? "Multi Menu" : "Single Menu",
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            );
          }),

          // Row 3: Menu Categories bar (For Multi Menu)
          if (controller.isMultiMenu) ...[
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white.withOpacity(0.15))),
              ),
              padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 6.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "MENU CATEGORIES",
                        style: GoogleFonts.poppins(
                          fontSize: 8.5.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.55),
                          letterSpacing: 0.6,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.bottomSheet(
                            MenuCategoriesSheet(controller: controller),
                            isScrollControlled: true,
                          );
                        },
                        borderRadius: BorderRadius.circular(6.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.tune_rounded, size: 10.sp, color: Colors.white),
                              SizedBox(width: 4.w),
                              Text(
                                "Manage",
                                style: GoogleFonts.poppins(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),

                  // Menu Category Pill Tabs
                  Obx(() {
                    final order = controller.menuCatOrder;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: List.generate(order.length, (pos) {
                          final mcIdx = order[pos];
                          final mc = controller.menuCategories[mcIdx];
                          final isActive = pos == controller.activeMenuCat.value;

                          int sel = 0;
                          int tot = 0;
                          for (final ci in mc.catIndices) {
                            if (ci < controller.categories.length) {
                              sel += controller.categories[ci].orderedSelected.length;
                              tot += controller.categories[ci].items.length;
                            }
                          }

                          return Padding(
                            padding: EdgeInsets.only(right: 6.w),
                            child: InkWell(
                              onTap: () => controller.setActiveMenuCategory(pos),
                              borderRadius: BorderRadius.circular(8.r),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: isActive ? Colors.white : Colors.transparent,
                                  border: Border.all(
                                    color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
                                    width: 1.2,
                                  ),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      mc.iconData,
                                      size: 15.sp,
                                      color: isActive ? mc.color : Colors.white,
                                    ),
                                    SizedBox(width: 6.w),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          mc.name,
                                          style: GoogleFonts.poppins(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w600,
                                            color: isActive ? mc.color : Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "$sel/$tot items",
                                          style: GoogleFonts.poppins(
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.w600,
                                            color: isActive ? const Color(0xFF9CA3AF) : Colors.white.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],

          // Row 4: Select / Order Sub-Tabs
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.18))),
            ),
            child: Obx(() {
              final isSelect = controller.activeTab.value == 'select';
              return Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => controller.setTab('select'),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 9.h),
                        color: isSelect ? Colors.white : Colors.white.withOpacity(0.1),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_box_outlined,
                                size: 14.sp,
                                color: isSelect ? const Color(0xFFC1272D) : Colors.white.withOpacity(0.85),
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                "Select Items",
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  fontWeight: isSelect ? FontWeight.w500 : FontWeight.w600,
                                  color: isSelect ? const Color(0xFFC1272D) : Colors.white.withOpacity(0.85),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => controller.setTab('order'),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 9.h),
                        color: !isSelect ? Colors.white : Colors.white.withOpacity(0.1),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.swap_vert_rounded,
                                size: 16.sp,
                                color: !isSelect ? const Color(0xFFC1272D) : Colors.white.withOpacity(0.85),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "Order Items",
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  fontWeight: !isSelect ? FontWeight.w500 : FontWeight.w600,
                                  color: !isSelect ? const Color(0xFFC1272D) : Colors.white.withOpacity(0.85),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 2. SELECT ITEMS TAB
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildSelectItemsTab() {
    return Obx(() {
      final selectedCatIdx = controller.selectedCatIndexForItems.value;
      if (selectedCatIdx != null) {
        return _buildCategoryItemSelectionPanel(selectedCatIdx);
      }
      return _buildCategoryListPanel();
    });
  }

  Widget _buildCategoryListPanel() {
    return Column(
      children: [
        // Search bar for categories
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded, size: 15.sp, color: const Color(0xFF9CA3AF)),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextField(
                    onChanged: (val) => controller.categorySearchQuery.value = val,
                    style: GoogleFonts.poppins(fontSize: 13.sp, color: const Color(0xFF111827)),
                    decoration: InputDecoration(
                      hintText: "Search categories…",
                      hintStyle: GoogleFonts.poppins(fontSize: 13.sp, color: const Color(0xFF9CA3AF)),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 7.h),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1, color: Color(0xFFF3F4F6)),

        // Category list
        Expanded(
          child: Obx(() {
            final indices = controller.activeCatIndices;
            final query = controller.categorySearchQuery.value.trim().toLowerCase();

            final filteredIndices = query.isEmpty
                ? indices
                : indices.where((ci) => controller.categories[ci].name.toLowerCase().contains(query)).toList();

            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: filteredIndices.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF9FAFB)),
              itemBuilder: (context, pos) {
                final catIdx = filteredIndices[pos];
                final cat = controller.categories[catIdx];
                final sel = cat.orderedSelected.length;
                final tot = cat.items.length;
                final allSelected = sel == tot;
                final noneSelected = sel == 0;
                final pct = tot > 0 ? (sel / tot) : 0.0;

                return InkWell(
                  onTap: () => controller.openCategoryForItems(catIdx),
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    child: Row(
                      children: [
                        // Position Index
                        SizedBox(
                          width: 16.w,
                          child: Text(
                            "${pos + 1}",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF9CA3AF),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),

                        // Title, completion pill, and progress line
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      cat.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF111827),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  // Status Badge Pill
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                                    decoration: BoxDecoration(
                                      color: allSelected
                                          ? const Color(0xFFF0FDF4)
                                          : noneSelected
                                              ? const Color(0xFFF9FAFB)
                                              : const Color(0xFFFEF2F2),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: allSelected
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.check_rounded, size: 10.sp, color: const Color(0xFF16A34A)),
                                              SizedBox(width: 2.w),
                                              Text(
                                                "All",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 8.5.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color(0xFF16A34A),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            noneSelected ? "None" : "$sel/$tot",
                                            style: GoogleFonts.poppins(
                                              fontSize: 8.5.sp,
                                              fontWeight: FontWeight.w500,
                                              color: noneSelected
                                                  ? const Color(0xFF9CA3AF)
                                                  : const Color(0xFFC1272D),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              // Colored Progress Indicator Line
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2.r),
                                child: Container(
                                  height: 3.h,
                                  color: const Color(0xFFF3F4F6),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: pct,
                                    child: Container(
                                      color: allSelected
                                          ? const Color(0xFF16A34A)
                                          : noneSelected
                                              ? const Color(0xFFE5E7EB)
                                              : const Color(0xFFC1272D),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),

                        // Toggle All Button
                        InkWell(
                          onTap: () => controller.toggleAllInCat(catIdx),
                          borderRadius: BorderRadius.circular(6.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: allSelected ? const Color(0xFFF0FDF4) : const Color(0xFFF9FAFB),
                              border: Border.all(
                                color: allSelected ? const Color(0xFF16A34A) : const Color(0xFFE5E7EB),
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  allSelected ? Icons.check_rounded : Icons.add_rounded,
                                  size: 11.sp,
                                  color: allSelected ? const Color(0xFF16A34A) : const Color(0xFF6B7280),
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  "All",
                                  style: GoogleFonts.poppins(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                    color: allSelected ? const Color(0xFF16A34A) : const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),

                        Icon(
                          Icons.chevron_right_rounded,
                          size: 14.sp,
                          color: const Color(0xFFD1D5DB),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 3. CATEGORY ITEM SELECTION PANEL (Drill-down checklist)
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildCategoryItemSelectionPanel(int catIdx) {
    final cat = controller.categories[catIdx];
    final indices = controller.activeCatIndices;
    final posInOrder = indices.indexOf(catIdx);
    final hasPrev = posInOrder > 0;
    final hasNext = posInOrder < indices.length - 1;

    final sel = cat.orderedSelected.length;
    final tot = cat.items.length;
    final pct = tot > 0 ? (sel / tot) : 0.0;

    return Column(
      children: [
        // Category Header Bar
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => controller.closeCategoryForItems(),
                    borderRadius: BorderRadius.circular(14.r),
                    child: Container(
                      width: 28.w,
                      height: 28.h,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.chevron_left_rounded, size: 18.sp, color: const Color(0xFF374151)),
                    ),
                  ),
                  SizedBox(width: 9.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${controller.templateName} template",
                          style: GoogleFonts.poppins(fontSize: 10.sp, color: const Color(0xFF9CA3AF)),
                        ),
                        Text(
                          cat.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // All & None batch buttons
                  InkWell(
                    onTap: () => controller.selectAllItemsInActiveCat(true),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        border: Border.all(color: const Color(0xFFC1272D), width: 1.2),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        "All",
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFC1272D),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  InkWell(
                    onTap: () => controller.selectAllItemsInActiveCat(false),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        "None",
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              // Progress bar and ratio count
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2.r),
                      child: Container(
                        height: 4.h,
                        color: const Color(0xFFF3F4F6),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: pct,
                          child: Container(color: const Color(0xFFC1272D)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "$sel / $tot",
                    style: GoogleFonts.poppins(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFC1272D),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFF3F4F6)),

        // Items Checklist
        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: cat.items.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF9FAFB)),
            itemBuilder: (context, i) {
              final itemName = cat.items[i];
              final isChecked = cat.orderedSelected.contains(i);

              return InkWell(
                onTap: () => controller.toggleItem(catIdx, i),
                child: Container(
                  color: isChecked ? const Color(0xFFFEFAFA) : Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  child: Row(
                    children: [
                      // Custom Square Checkbox
                      Container(
                        width: 20.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: isChecked ? const Color(0xFFC1272D) : Colors.white,
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(
                            color: isChecked ? const Color(0xFFC1272D) : const Color(0xFFD1D5DB),
                            width: 1.8,
                          ),
                        ),
                        child: isChecked
                            ? Icon(Icons.check_rounded, color: Colors.white, size: 13.sp)
                            : null,
                      ),
                      SizedBox(width: 12.w),

                      // Item name
                      Expanded(
                        child: Text(
                          itemName,
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: isChecked ? FontWeight.w700 : FontWeight.w500,
                            color: isChecked ? const Color(0xFF111827) : const Color(0xFF6B7280),
                          ),
                        ),
                      ),

                      // Veg / Food indicator dot
                      Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          border: Border.all(color: const Color(0xFF16A34A), width: 1.5),
                          borderRadius: BorderRadius.circular(1.5.r),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Bottom Navigation Bar (Prev / 1 of 10 / Next)
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF3F4F6),
                    foregroundColor: const Color(0xFF374151),
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  onPressed: hasPrev ? () => controller.navCategory(-1) : null,
                  icon: Icon(Icons.chevron_left_rounded, size: 14.sp),
                  label: Text(
                    hasPrev ? controller.categories[indices[posInOrder - 1]].name.split(' ').first : "Prev",
                    style: GoogleFonts.poppins(fontSize: 11.sp, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(
                width: 60.w,
                child: Text(
                  "${posInOrder + 1} / ${indices.length}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC1272D),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  onPressed: hasNext
                      ? () => controller.navCategory(1)
                      : () => controller.closeCategoryForItems(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        hasNext ? controller.categories[indices[posInOrder + 1]].name.split(' ').first : "Done",
                        style: GoogleFonts.poppins(fontSize: 11.sp, fontWeight: FontWeight.w600),
                      ),
                      if (hasNext) Icon(Icons.chevron_right_rounded, size: 14.sp),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 4. ORDER ITEMS TAB (Category & Item Reorder Panels)
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildOrderItemsTab() {
    return Obx(() {
      final orderCatIdx = controller.selectedCatIndexForOrder.value;
      if (orderCatIdx != null) {
        return _buildOrderItemReorderPanel(orderCatIdx);
      }
      return _buildCategoryOrderPanel();
    });
  }

  Widget _buildCategoryOrderPanel() {
    final mc = controller.currentMenuCategory;

    return Column(
      children: [
        // Category Order Section Header
        Container(
          width: double.infinity,
          color: const Color(0xFFF9FAFB),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.isMultiMenu
                    ? "CATEGORY ORDER · ${mc.name.toUpperCase()}"
                    : "CATEGORY ORDER",
                style: GoogleFonts.poppins(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF374151),
                  letterSpacing: 0.4,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                controller.isMultiMenu
                    ? "Reorder categories shown in this menu section"
                    : "Tap ↑↓ to reorder. Tap row to arrange items inside.",
                style: GoogleFonts.poppins(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE5E7EB)),

        // Reorderable list
        Expanded(
          child: Obx(() {
            final indices = controller.activeCatIndices;
            final n = indices.length;

            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: n,
              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF9FAFB)),
              itemBuilder: (context, pos) {
                final catIdx = indices[pos];
                final cat = controller.categories[catIdx];
                final cnt = cat.orderedSelected.length;
                final isFirst = pos == 0;
                final isLast = pos == n - 1;

                return Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  child: Row(
                    children: [
                      // 3-Bar Drag Handle
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Column(
                          children: [
                            Container(width: 14.w, height: 1.5.h, color: const Color(0xFFD1D5DB)),
                            SizedBox(height: 2.h),
                            Container(width: 14.w, height: 1.5.h, color: const Color(0xFFD1D5DB)),
                            SizedBox(height: 2.h),
                            Container(width: 14.w, height: 1.5.h, color: const Color(0xFFD1D5DB)),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),

                      // Red Number Badge
                      Container(
                        width: 22.w,
                        height: 22.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC1272D),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Center(
                          child: Text(
                            "${pos + 1}",
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),

                      // Category Title & Count (Tappable to arrange items)
                      Expanded(
                        child: InkWell(
                          onTap: () => controller.openCategoryForOrder(catIdx),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cat.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF111827),
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                "$cnt item${cnt != 1 ? 's' : ''}",
                                style: GoogleFonts.poppins(
                                  fontSize: 10.sp,
                                  color: const Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Up / Down Reorder Buttons
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: isFirst ? null : () => controller.moveCategory(pos, -1),
                            borderRadius: BorderRadius.circular(5.r),
                            child: Container(
                              width: 24.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                color: isFirst ? const Color(0xFFF9FAFB) : Colors.white,
                                border: Border.all(color: const Color(0xFFE5E7EB)),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Icon(
                                Icons.keyboard_arrow_up_rounded,
                                size: 17.sp,
                                color: isFirst ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          InkWell(
                            onTap: isLast ? null : () => controller.moveCategory(pos, 1),
                            borderRadius: BorderRadius.circular(5.r),
                            child: Container(
                              width: 24.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                color: isLast ? const Color(0xFFF9FAFB) : Colors.white,
                                border: Border.all(color: const Color(0xFFE5E7EB)),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 17.sp,
                                color: isLast ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 4.w),

                      InkWell(
                        onTap: () => controller.openCategoryForOrder(catIdx),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 14.sp,
                          color: const Color(0xFFD1D5DB),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildOrderItemReorderPanel(int catIdx) {
    final cat = controller.categories[catIdx];

    return Column(
      children: [
        // Item Order Header Bar
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => controller.closeCategoryForOrder(),
                    borderRadius: BorderRadius.circular(14.r),
                    child: Container(
                      width: 28.w,
                      height: 28.h,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.chevron_left_rounded, size: 18.sp, color: const Color(0xFF374151)),
                    ),
                  ),
                  SizedBox(width: 9.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Item order in customer menu",
                          style: GoogleFonts.poppins(fontSize: 10.sp, color: const Color(0xFF9CA3AF)),
                        ),
                        Text(
                          cat.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Text(
                      "${cat.orderedSelected.length} items",
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFC1272D),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Padding(
                padding: EdgeInsets.only(left: 37.w),
                child: Text(
                  "↑↓ to reorder · item 1 shows first to customers",
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFF3F4F6)),

        // Reorderable Items List
        Expanded(
          child: Obx(() {
            controller.hasChanges.value; // trigger reactivity
            final n = cat.orderedSelected.length;

            if (n == 0) {
              return Center(
                child: Text(
                  "No items selected for this category.\nSelect items first in the Select tab.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 12.sp, color: const Color(0xFF9CA3AF)),
                ),
              );
            }

            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: n,
              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF9FAFB)),
              itemBuilder: (context, pos) {
                final itemIdx = cat.orderedSelected[pos];
                final itemName = cat.items[itemIdx];
                final isFirst = pos == 0;
                final isLast = pos == n - 1;

                return Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  child: Row(
                    children: [
                      // 3-Bar Drag Handle
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Column(
                          children: [
                            Container(width: 14.w, height: 1.5.h, color: const Color(0xFFD1D5DB)),
                            SizedBox(height: 2.h),
                            Container(width: 14.w, height: 1.5.h, color: const Color(0xFFD1D5DB)),
                            SizedBox(height: 2.h),
                            Container(width: 14.w, height: 1.5.h, color: const Color(0xFFD1D5DB)),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),

                      // Red Number Pill
                      Container(
                        width: 20.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Center(
                          child: Text(
                            "${pos + 1}",
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFC1272D),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),

                      // Item name
                      Expanded(
                        child: Text(
                          itemName,
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF111827),
                          ),
                        ),
                      ),

                      // Veg Indicator
                      Container(
                        width: 7.w,
                        height: 7.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          border: Border.all(color: const Color(0xFF16A34A), width: 1.5),
                          borderRadius: BorderRadius.circular(1.5.r),
                        ),
                      ),
                      SizedBox(width: 10.w),

                      // Up / Down Reorder Buttons
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: isFirst ? null : () => controller.moveItem(pos, -1),
                            borderRadius: BorderRadius.circular(5.r),
                            child: Container(
                              width: 24.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                color: isFirst ? const Color(0xFFF9FAFB) : Colors.white,
                                border: Border.all(color: const Color(0xFFE5E7EB)),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Icon(
                                Icons.keyboard_arrow_up_rounded,
                                size: 17.sp,
                                color: isFirst ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          InkWell(
                            onTap: isLast ? null : () => controller.moveItem(pos, 1),
                            borderRadius: BorderRadius.circular(5.r),
                            child: Container(
                              width: 24.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                color: isLast ? const Color(0xFFF9FAFB) : Colors.white,
                                border: Border.all(color: const Color(0xFFE5E7EB)),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 17.sp,
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
      ],
    );
  }
}
