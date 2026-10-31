import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../domain/models/item_model.dart';

/// Enterprise Item Card component with ultra-fast memory-cached images,
/// tactile tap feedback, fluid toggle animations, and resilient gesture capture.
class ItemCard extends StatefulWidget {
  final ItemModel item;
  final ValueChanged<bool> onAvailabilityChanged;
  final ValueChanged<bool>? onFsiChanged;
  final VoidCallback onEditPressed;

  const ItemCard({
    super.key,
    required this.item,
    required this.onAvailabilityChanged,
    this.onFsiChanged,
    required this.onEditPressed,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isVeg = widget.item.vegType.toLowerCase() == 'veg';

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeInOut,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onEditPressed,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radius12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Image / Gradient Thumbnail Banner (icard-img)
              SizedBox(
                height: 104.h,
                width: double.infinity,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radius12)),
                      child: widget.item.imageUrl != null && widget.item.imageUrl!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: widget.item.imageUrl!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              memCacheWidth: 320,
                              memCacheHeight: 240,
                              maxWidthDiskCache: 500,
                              maxHeightDiskCache: 500,
                              fadeInDuration: const Duration(milliseconds: 150),
                              errorListener: (_) {},
                              errorWidget: (context, url, error) => _buildGradientPlaceholder(isVeg),
                            )
                          : _buildGradientPlaceholder(isVeg),
                    ),

                    // Veg / Non-Veg Dot (veg-dot)
                    Positioned(
                      top: 6.h,
                      left: 6.w,
                      child: Container(
                        width: 15.w,
                        height: 15.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2.5.r),
                          border: Border.all(
                            color: isVeg ? const Color(0xFF16A34A) : const Color(0xFFC1272D),
                            width: 1.2.w,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          width: 7.w,
                          height: 7.h,
                          decoration: BoxDecoration(
                            color: isVeg ? const Color(0xFF16A34A) : const Color(0xFFC1272D),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),

                    // Star / Favorite Button (star-btn)
                    Positioned(
                      top: 6.h,
                      right: 6.w,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          if (widget.onFsiChanged != null) {
                            widget.onFsiChanged!(!widget.item.isFrequentlySold);
                          } else {
                            widget.onEditPressed();
                          }
                        },
                        child: Container(
                          width: 26.w,
                          height: 26.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.item.isFrequentlySold ? Icons.star_rounded : Icons.star_outline_rounded,
                            size: 14.sp,
                            color: widget.item.isFrequentlySold ? const Color(0xFFF59E0B) : const Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Info Details Body (icard-body)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.item.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF111827),
                                    height: 1.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (widget.item.hasVariants) ...[
                                SizedBox(width: 4.w),
                                Container(
                                  padding: EdgeInsets.all(2.5.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(color: const Color(0xFFFDE68A), width: 0.8),
                                  ),
                                  child: Icon(
                                    Icons.tune_rounded,
                                    size: 10.5.sp,
                                    color: const Color(0xFFD97706),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 3.h),
                          if ((widget.item.dietaryTags != null && widget.item.dietaryTags!.isNotEmpty) ||
                              (widget.item.portion != null && widget.item.portion!.trim().isNotEmpty)) ...[
                            Wrap(
                              spacing: 4.w,
                              runSpacing: 2.h,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                if (widget.item.dietaryTags != null && widget.item.dietaryTags!.isNotEmpty)
                                  ...widget.item.dietaryTags!.map((tag) {
                                    final lower = tag.trim().toLowerCase();
                                    final isSpicy = lower.contains('spicy') || lower == 's';
                                    final isJain = lower.contains('jain') || lower == 'j';
                                    final isVegan = lower.contains('vegan') || lower == 'v';
                                    final bg = isSpicy
                                        ? const Color(0xFFFEF2F2)
                                        : (isJain ? const Color(0xFFEEF2FF) : const Color(0xFFF0FDF4));
                                    final fg = isSpicy
                                        ? const Color(0xFFEF4444)
                                        : (isJain ? const Color(0xFF6366F1) : const Color(0xFF16A34A));
                                    final label = isSpicy
                                        ? 'SPICY'
                                        : (isJain ? 'JAIN' : (isVegan ? 'VEGAN' : tag.toUpperCase()));
                                    return Container(
                                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                                      decoration: BoxDecoration(
                                        color: bg,
                                        borderRadius: BorderRadius.circular(3.r),
                                      ),
                                      child: Text(
                                        label,
                                        style: GoogleFonts.poppins(
                                          fontSize: 7.5.sp,
                                          fontWeight: FontWeight.w700,
                                          color: fg,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    );
                                  }),
                                if (widget.item.portion != null && widget.item.portion!.trim().isNotEmpty)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.grid_view_rounded,
                                        size: 9.5.sp,
                                        color: const Color(0xFF9CA3AF),
                                      ),
                                      SizedBox(width: 2.5.w),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(maxWidth: 95.w),
                                        child: Text(
                                          widget.item.portion!.trim(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 9.5.sp,
                                            color: const Color(0xFF6B7280),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ],
                      ),

                      // Card Footer (icard-foot)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
                          SizedBox(height: 5.h),
                          // Row with PRICE label on left and AVAILABLE switch on right
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "PRICE (₹)",
                                style: GoogleFonts.poppins(
                                  fontSize: 8.5.sp,
                                  color: const Color(0xFF9CA3AF),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              // Availability toggle switch with label
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  widget.onAvailabilityChanged(!widget.item.isAvailable);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 180),
                                      child: Text(
                                        widget.item.isAvailable ? "AVAILABLE" : "HIDDEN",
                                        key: ValueKey('status_${widget.item.isAvailable}'),
                                        style: GoogleFonts.poppins(
                                          fontSize: 7.5.sp,
                                          color: widget.item.isAvailable
                                              ? const Color(0xFF16A34A)
                                              : const Color(0xFF9CA3AF),
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      curve: Curves.easeInOut,
                                      width: 28.w,
                                      height: 16.h,
                                      padding: EdgeInsets.all(1.5.w),
                                      decoration: BoxDecoration(
                                        color: widget.item.isAvailable
                                            ? const Color(0xFF16A34A)
                                            : const Color(0xFFD1D5DB),
                                        borderRadius: BorderRadius.circular(10.r),
                                        boxShadow: [
                                          if (widget.item.isAvailable)
                                            BoxShadow(
                                              color: const Color(0xFF16A34A).withOpacity(0.3),
                                              blurRadius: 3,
                                              offset: const Offset(0, 1),
                                            ),
                                        ],
                                      ),
                                      child: AnimatedAlign(
                                        duration: const Duration(milliseconds: 200),
                                        curve: Curves.easeOutBack,
                                        alignment: widget.item.isAvailable
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                          width: 13.w,
                                          height: 13.h,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
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
                          SizedBox(height: 2.h),
                          // Price or Price Range with full width and scale down protection
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.item.formattedPriceRange,
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientPlaceholder(bool isVeg) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isVeg
              ? const [Color(0xFFBBF7D0), Color(0xFF6EE7B7)]
              : const [Color(0xFFFECDD3), Color(0xFFFDA4AF)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.restaurant_rounded,
          size: 32.sp,
          color: (isVeg ? const Color(0xFF16A34A) : const Color(0xFFC1272D)).withOpacity(0.35),
        ),
      ),
    );
  }
}
