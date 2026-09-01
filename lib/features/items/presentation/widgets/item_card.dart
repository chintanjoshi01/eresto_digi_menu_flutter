import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../domain/models/item_model.dart';

/// Enterprise Item Card component matching eresto_menu_mobile_v5.html prototype specs.
class ItemCard extends StatelessWidget {
  final ItemModel item;
  final ValueChanged<bool> onAvailabilityChanged;
  final VoidCallback onEditPressed;

  const ItemCard({
    super.key,
    required this.item,
    required this.onAvailabilityChanged,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isVeg = item.vegType.toLowerCase() == 'veg';

    return GestureDetector(
      onTap: onEditPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Image / Gradient Thumbnail Banner (icard-img)
            SizedBox(
              height: 88.h,
              width: double.infinity,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radius12)),
                    child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: item.imageUrl!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => _buildGradientPlaceholder(isVeg),
                          )
                        : _buildGradientPlaceholder(isVeg),
                  ),

                  // Veg / Non-Veg Indicator Badge (veg-dot)
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

                  // Favorite / Edit Star Button (star-btn)
                  Positioned(
                    top: 6.h,
                    right: 6.w,
                    child: GestureDetector(
                      onTap: onEditPressed,
                      child: Container(
                        width: 24.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.star_outline_rounded,
                          size: 13.sp,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                  ),

                  // Hidden Status Overlay Badge (if item is hidden)
                  if (!item.isAvailable)
                    Positioned(
                      bottom: 6.h,
                      right: 6.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                        child: Text(
                          "UNAVAILABLE",
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
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
                padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 6.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: GoogleFonts.nunito(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF111827),
                            height: 1.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        // Portion label
                        Row(
                          children: [
                            Icon(
                              Icons.grid_view_rounded,
                              size: 9.sp,
                              color: const Color(0xFF9CA3AF),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                item.portion ?? "Per Unit",
                                style: GoogleFonts.nunito(
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
                                fontSize: 8.sp,
                                color: const Color(0xFF9CA3AF),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                            Text(
                              item.price.toStringAsFixed(2),
                              style: GoogleFonts.nunito(
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF111827),
                              ),
                            ),
                          ],
                        ),

                        // Availability status + Prototype toggle switch (.tog)
                        GestureDetector(
                          onTap: () => onAvailabilityChanged(!item.isAvailable),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                item.isAvailable ? "AVAILABLE" : "DISABLED",
                                style: GoogleFonts.nunito(
                                  fontSize: 7.5.sp,
                                  color: item.isAvailable
                                      ? const Color(0xFF16A34A)
                                      : const Color(0xFF9CA3AF),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              // Prototype iOS Pill Toggle Switch (.tog)
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: 34.w,
                                height: 18.h,
                                decoration: BoxDecoration(
                                  color: item.isAvailable
                                      ? const Color(0xFF16A34A)
                                      : const Color(0xFFD1D5DB),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Stack(
                                  children: [
                                    AnimatedPositioned(
                                      duration: const Duration(milliseconds: 180),
                                      curve: Curves.easeOut,
                                      left: item.isAvailable ? 18.w : 2.w,
                                      top: 2.h,
                                      child: Container(
                                        width: 14.w,
                                        height: 14.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 3,
                                              offset: const Offset(0, 1),
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
              : const [Color(0xFFFED7AA), Color(0xFFFDBA74)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.restaurant_rounded,
          size: 30.sp,
          color: (isVeg ? const Color(0xFF15803D) : const Color(0xFFC1272D)).withOpacity(0.35),
        ),
      ),
    );
  }
}
