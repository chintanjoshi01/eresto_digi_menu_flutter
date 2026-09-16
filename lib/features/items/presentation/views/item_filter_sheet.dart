import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../controllers/items_controller.dart';

/// Enterprise Multi-Criteria Filter & Sort Bottom Sheet
class ItemFilterSheet extends StatefulWidget {
  const ItemFilterSheet({super.key});

  @override
  State<ItemFilterSheet> createState() => _ItemFilterSheetState();
}

class _ItemFilterSheetState extends State<ItemFilterSheet> {
  final controller = Get.find<ItemsController>();

  // Local working copy of filters to preview before applying
  late String _tempVegType;
  late String _tempAvailability;
  late bool _tempFsiOnly;
  late String _tempSortBy;
  late Set<String> _tempDietaryTags;

  @override
  void initState() {
    super.initState();
    _tempVegType = controller.filterVegType.value;
    _tempAvailability = controller.filterAvailability.value;
    _tempFsiOnly = controller.filterFsiOnly.value;
    _tempSortBy = controller.filterSortBy.value;
    _tempDietaryTags = Set.from(controller.selectedDietaryTags);
  }

  void _resetLocalFilters() {
    HapticFeedback.lightImpact();
    setState(() {
      _tempVegType = 'ALL';
      _tempAvailability = 'ALL';
      _tempFsiOnly = false;
      _tempSortBy = 'DEFAULT';
      _tempDietaryTags.clear();
    });
  }

  void _applyFilters() {
    HapticFeedback.mediumImpact();
    controller.filterVegType.value = _tempVegType;
    controller.filterAvailability.value = _tempAvailability;
    controller.filterFsiOnly.value = _tempFsiOnly;
    controller.filterSortBy.value = _tempSortBy;
    controller.selectedDietaryTags.assignAll(_tempDietaryTags);
    controller.filterItems();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 0.88.sh),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Draggable Top Grab Bar
          Container(
            margin: EdgeInsets.only(top: 10.h, bottom: 6.h),
            width: 44.w,
            height: 4.5.h,
            decoration: BoxDecoration(
              color: const Color(0xFFD1D5DB),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),

          // 2. Sheet Header Title & Reset
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF1F1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(Icons.tune_rounded, size: 18.sp, color: AppColors.primary),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "Filter & Sort Menu",
                      style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: _resetLocalFilters,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    "Reset All",
                    style: GoogleFonts.nunito(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE5E7EB)),

          // 3. Scrollable Filter Sections
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section A: Food Preference
                  _buildSectionTitle("FOOD PREFERENCE", Icons.restaurant_menu_rounded),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildChoiceChip(
                          label: "All Types",
                          isSelected: _tempVegType == 'ALL',
                          onTap: () => setState(() => _tempVegType = 'ALL'),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _buildChoiceChip(
                          label: "Pure Veg",
                          icon: Icons.circle,
                          iconColor: const Color(0xFF16A34A),
                          isSelected: _tempVegType == 'VEG',
                          onTap: () => setState(() => _tempVegType = 'VEG'),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _buildChoiceChip(
                          label: "Non-Veg",
                          icon: Icons.circle,
                          iconColor: const Color(0xFFDC2626),
                          isSelected: _tempVegType == 'NON_VEG',
                          onTap: () => setState(() => _tempVegType = 'NON_VEG'),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 18.h),

                  // Section B: Stock & Availability
                  _buildSectionTitle("STOCK & AVAILABILITY", Icons.inventory_2_outlined),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildChoiceChip(
                          label: "All Status",
                          isSelected: _tempAvailability == 'ALL',
                          onTap: () => setState(() => _tempAvailability = 'ALL'),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _buildChoiceChip(
                          label: "In Stock",
                          isSelected: _tempAvailability == 'AVAILABLE',
                          onTap: () => setState(() => _tempAvailability = 'AVAILABLE'),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _buildChoiceChip(
                          label: "Out of Stock",
                          isSelected: _tempAvailability == 'HIDDEN',
                          onTap: () => setState(() => _tempAvailability = 'HIDDEN'),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 18.h),

                  // Section C: Featured & Special Dietary
                  _buildSectionTitle("FEATURED & DIETARY", Icons.stars_rounded),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _buildFilterPill(
                        label: "⭐ Starred / FSI Only",
                        isSelected: _tempFsiOnly,
                        onTap: () => setState(() => _tempFsiOnly = !_tempFsiOnly),
                      ),
                      _buildFilterPill(
                        label: "Jain Compatible",
                        isSelected: _tempDietaryTags.contains('j'),
                        onTap: () => setState(() {
                          if (_tempDietaryTags.contains('j')) {
                            _tempDietaryTags.remove('j');
                          } else {
                            _tempDietaryTags.add('j');
                          }
                        }),
                      ),
                      _buildFilterPill(
                        label: "Vegan",
                        isSelected: _tempDietaryTags.contains('v'),
                        onTap: () => setState(() {
                          if (_tempDietaryTags.contains('v')) {
                            _tempDietaryTags.remove('v');
                          } else {
                            _tempDietaryTags.add('v');
                          }
                        }),
                      ),
                      _buildFilterPill(
                        label: "Spicy",
                        isSelected: _tempDietaryTags.contains('s'),
                        onTap: () => setState(() {
                          if (_tempDietaryTags.contains('s')) {
                            _tempDietaryTags.remove('s');
                          } else {
                            _tempDietaryTags.add('s');
                          }
                        }),
                      ),
                    ],
                  ),

                  SizedBox(height: 18.h),

                  // Section D: Sort Ordering
                  _buildSectionTitle("SORT MENU BY", Icons.sort_rounded),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _buildSortOption("Default", 'DEFAULT'),
                      _buildSortOption("Price: Low to High ↑", 'PRICE_ASC'),
                      _buildSortOption("Price: High to Low ↓", 'PRICE_DESC'),
                      _buildSortOption("Name: A to Z", 'NAME_ASC'),
                    ],
                  ),

                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE5E7EB)),

          // 4. Bottom Sticky Action Buttons
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 20.h),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 11.h),
                      side: const BorderSide(color: Color(0xFFD1D5DB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9.r),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.nunito(
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
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 2,
                      padding: EdgeInsets.symmetric(vertical: 11.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_rounded, size: 16.sp, color: Colors.white),
                        SizedBox(width: 6.w),
                        Text(
                          "Apply Filters",
                          style: GoogleFonts.nunito(
                            fontSize: 13.5.sp,
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
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 13.sp, color: const Color(0xFF6B7280)),
        SizedBox(width: 5.w),
        Text(
          title,
          style: GoogleFonts.nunito(
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF6B7280),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
    Color? iconColor,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFDF1F1) : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
            width: 1.5.w,
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 7.sp, color: iconColor ?? AppColors.primary),
              SizedBox(width: 4.w),
            ],
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 11.5.sp,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? AppColors.primary : const Color(0xFF4B5563),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFDF1F1) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
            width: 1.5.w,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 11.5.sp,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? AppColors.primary : const Color(0xFF4B5563),
          ),
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, String value) {
    final isSelected = _tempSortBy == value;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _tempSortBy = value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
            width: 1.5.w,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 11.5.sp,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF4B5563),
          ),
        ),
      ),
    );
  }
}
