import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/item_model.dart';

/// Enterprise List/Row View Card for Menu Items
class ItemRowCard extends StatefulWidget {
  final ItemModel item;
  final ValueChanged<bool> onAvailabilityChanged;
  final ValueChanged<bool>? onFsiChanged;
  final VoidCallback onEditPressed;

  const ItemRowCard({
    super.key,
    required this.item,
    required this.onAvailabilityChanged,
    this.onFsiChanged,
    required this.onEditPressed,
  });

  @override
  State<ItemRowCard> createState() => _ItemRowCardState();
}

class _ItemRowCardState extends State<ItemRowCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isVeg = widget.item.vegType.toLowerCase() == 'veg';

    return AnimatedScale(
      scale: _isPressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeInOut,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onEditPressed,
        child: Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // 1. Thumbnail Image with Veg/Non-Veg Dot
              SizedBox(
                width: 72.w,
                height: 72.h,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: widget.item.imageUrl != null && widget.item.imageUrl!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: widget.item.imageUrl!,
                              width: 72.w,
                              height: 72.h,
                              fit: BoxFit.cover,
                              memCacheWidth: 200,
                              memCacheHeight: 200,
                              maxWidthDiskCache: 400,
                              maxHeightDiskCache: 400,
                              fadeInDuration: const Duration(milliseconds: 150),
                              errorListener: (_) {},
                              errorWidget: (context, url, error) => _buildPlaceholder(isVeg),
                            )
                          : _buildPlaceholder(isVeg),
                    ),

                    // Veg / Non-Veg Dot
                    Positioned(
                      top: 4.h,
                      left: 4.w,
                      child: Container(
                        width: 13.w,
                        height: 13.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2.r),
                          border: Border.all(
                            color: isVeg ? const Color(0xFF16A34A) : const Color(0xFFC1272D),
                            width: 1.w,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          width: 5.5.w,
                          height: 5.5.h,
                          decoration: BoxDecoration(
                            color: isVeg ? const Color(0xFF16A34A) : const Color(0xFFC1272D),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 10.w),

              // 2. Middle Content Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Item Name
                    Text(
                      widget.item.name,
                      style: GoogleFonts.nunito(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 3.h),

                    // Short Code Badge & Portion Tag
                    Row(
                      children: [
                        if (widget.item.shortCode.isNotEmpty && widget.item.shortCode != widget.item.name) ...[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              widget.item.shortCode,
                              style: GoogleFonts.nunito(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF4B5563),
                              ),
                            ),
                          ),
                          SizedBox(width: 5.w),
                        ],
                        Expanded(
                          child: Text(
                            widget.item.portion ?? "1 portion",
                            style: GoogleFonts.nunito(
                              fontSize: 10.sp,
                              color: const Color(0xFF9CA3AF),
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 4.h),

                    // Price Tag
                    Text(
                      "₹ ${widget.item.price.toStringAsFixed(2)}",
                      style: GoogleFonts.nunito(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 8.w),

              // 3. Right Action Controls (Star FSI + Toggle Switch)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // FSI Star Toggle
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      if (widget.onFsiChanged != null) {
                        widget.onFsiChanged!(!widget.item.isFrequentlySold);
                      } else {
                        widget.onEditPressed();
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Icon(
                        widget.item.isFrequentlySold ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 17.sp,
                        color: widget.item.isFrequentlySold ? const Color(0xFFF59E0B) : const Color(0xFF9CA3AF),
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Availability Toggle Switch
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      widget.onAvailabilityChanged(!widget.item.isAvailable);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: Text(
                            widget.item.isAvailable ? "AVAILABLE" : "HIDDEN",
                            key: ValueKey('row_status_${widget.item.isAvailable}'),
                            style: GoogleFonts.nunito(
                              fontSize: 8.sp,
                              color: widget.item.isAvailable
                                  ? const Color(0xFF16A34A)
                                  : const Color(0xFF9CA3AF),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeInOut,
                          width: 36.w,
                          height: 19.h,
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: widget.item.isAvailable
                                ? const Color(0xFF16A34A)
                                : const Color(0xFFD1D5DB),
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              if (widget.item.isAvailable)
                                BoxShadow(
                                  color: const Color(0xFF16A34A).withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                            ],
                          ),
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutBack,
                            alignment: widget.item.isAvailable
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              width: 15.w,
                              height: 15.h,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(bool isVeg) {
    return Container(
      width: 72.w,
      height: 72.h,
      decoration: BoxDecoration(
        color: isVeg ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Icon(
          Icons.restaurant_rounded,
          size: 22.sp,
          color: (isVeg ? const Color(0xFF16A34A) : AppColors.primary).withOpacity(0.4),
        ),
      ),
    );
  }
}
