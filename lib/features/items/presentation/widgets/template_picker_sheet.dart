import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/storage/storage_service.dart';

class TemplateItemData {
  final int ptId;
  final String name;
  final String details;
  final String priceList;
  final Color color;
  final bool isSelected;

  const TemplateItemData({
    this.ptId = 0,
    required this.name,
    required this.details,
    required this.priceList,
    required this.color,
    this.isSelected = false,
  });
}

class TemplatePickerSheet extends StatefulWidget {
  final String selectedTemplate;
  final ValueChanged<TemplateItemData>? onTemplateSelected;

  const TemplatePickerSheet({
    super.key,
    this.selectedTemplate = 'Main',
    this.onTemplateSelected,
  });

  @override
  State<TemplatePickerSheet> createState() => _TemplatePickerSheetState();
}

class _TemplatePickerSheetState extends State<TemplatePickerSheet> {
  late String _currentSelected;
  late List<TemplateItemData> _templates;

  @override
  void initState() {
    super.initState();
    _currentSelected = widget.selectedTemplate;

    final storage = Get.isRegistered<StorageService>() ? Get.find<StorageService>() : null;
    final cachedPriceTemplates = storage?.priceTemplates ?? [];

    if (cachedPriceTemplates.isNotEmpty) {
      final colors = [
        const Color(0xFFC1272D),
        const Color(0xFFF59E0B),
        const Color(0xFF0284C7),
        const Color(0xFF16A34A),
        const Color(0xFF7C3AED),
      ];
      _templates = cachedPriceTemplates.asMap().entries.map((entry) {
        final idx = entry.key;
        final pt = entry.value;
        return TemplateItemData(
          ptId: pt.ptId,
          name: pt.priceTemplate,
          details: 'Tier #${pt.ptId} · Live Rate List',
          priceList: pt.priceTemplate,
          color: colors[idx % colors.length],
        );
      }).toList();
    } else {
      _templates = const [
        TemplateItemData(
          ptId: 0,
          name: 'Default Dine-In',
          details: 'Basic · Live Pricing',
          priceList: 'Default Price',
          color: Color(0xFFC1272D),
        ),
        TemplateItemData(
          ptId: 1,
          name: 'Regular Dine-In',
          details: 'Rate List #1',
          priceList: 'Regular Dine-In',
          color: Color(0xFFF59E0B),
        ),
        TemplateItemData(
          ptId: 2,
          name: 'Room Service (IRD)',
          details: 'Rate List #2',
          priceList: 'Room Service',
          color: Color(0xFF0284C7),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 10.h),
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Template",
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Items shown are scoped to the selected template",
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF3F4F6)),

          // Template Items List
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                bottom: 16.h + MediaQuery.of(context).padding.bottom,
              ),
              itemCount: _templates.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: Color(0xFFF9FAFB),
              ),
              itemBuilder: (context, index) {
                final item = _templates[index];
                final isSelected = item.name == _currentSelected;

                return InkWell(
                  onTap: () {
                    setState(() => _currentSelected = item.name);
                    if (widget.onTemplateSelected != null) {
                      widget.onTemplateSelected!(item);
                    }
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFEF9F9) : Colors.transparent,
                      border: Border(
                        left: BorderSide(
                          color: isSelected ? item.color : Colors.transparent,
                          width: 3.w,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Left Accent Color Block
                        Container(
                          width: 10.w,
                          height: 38.h,
                          decoration: BoxDecoration(
                            color: item.color,
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                        ),
                        SizedBox(width: 12.w),

                        // Title & Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF111827),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                item.details,
                                style: GoogleFonts.poppins(
                                  fontSize: 10.sp,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Price Tag & Checkmark
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildPriceListBadge(item.priceList),
                            SizedBox(height: 4.h),
                            if (isSelected)
                              Icon(
                                Icons.check_rounded,
                                size: 16.sp,
                                color: item.color,
                              )
                            else
                              Icon(
                                Icons.chevron_right_rounded,
                                size: 16.sp,
                                color: const Color(0xFFD1D5DB),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  ),
);
}

  Widget _buildPriceListBadge(String priceList) {
    Color bg = const Color(0xFFF0FDF4);
    Color fg = const Color(0xFF16A34A);

    if (priceList == 'Dine-In Price') {
      bg = const Color(0xFFEFF6FF);
      fg = const Color(0xFF0284C7);
    } else if (priceList == 'Room Price') {
      bg = const Color(0xFFF3F4F6);
      fg = const Color(0xFF374151);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        priceList,
        style: GoogleFonts.poppins(
          fontSize: 9.sp,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
