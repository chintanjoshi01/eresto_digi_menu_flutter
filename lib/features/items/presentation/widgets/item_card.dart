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
                          Text(
                            widget.item.name,
                            style: GoogleFonts.nunito(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF111827),
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 3.h),
                          // Portion label (icard-portion)
                          Row(
                            children: [
                              Icon(
                                Icons.grid_view_rounded,
                                size: 10.sp,
                                color: const Color(0xFF9CA3AF),
                              ),
                              SizedBox(width: 3.w),
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
                        ],
                      ),

                      // Card Footer (icard-foot)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Price column
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "PRICE (₹)",
                                style: GoogleFonts.nunito(
                                  fontSize: 9.sp,
                                  color: const Color(0xFF9CA3AF),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              Text(
                                widget.item.price.toStringAsFixed(2),
                                style: GoogleFonts.nunito(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF111827),
                                ),
                              ),
                            ],
                          ),

                          // Availability Status + Fluid iOS Spring Toggle Switch
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              widget.onAvailabilityChanged(!widget.item.isAvailable);
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10.w, 4.h, 0, 4.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 180),
                                    child: Text(
                                      widget.item.isAvailable ? "AVAILABLE" : "HIDDEN",
                                      key: ValueKey('status_${widget.item.isAvailable}'),
                                      style: GoogleFonts.nunito(
                                        fontSize: 8.5.sp,
                                        color: widget.item.isAvailable
                                            ? const Color(0xFF16A34A)
                                            : const Color(0xFF9CA3AF),
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  // Fluid Animated Toggle Switch
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 220),
                                    curve: Curves.easeInOut,
                                    width: 38.w,
                                    height: 20.h,
                                    padding: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                      color: widget.item.isAvailable
                                          ? const Color(0xFF16A34A)
                                          : const Color(0xFFD1D5DB),
                                      borderRadius: BorderRadius.circular(12.r),
                                      boxShadow: [
                                        if (widget.item.isAvailable)
                                          BoxShadow(
                                            color: const Color(0xFF16A34A).withOpacity(0.35),
                                            blurRadius: 5,
                                            offset: const Offset(0, 1.5),
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
                                        width: 16.w,
                                        height: 16.h,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 3,
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
