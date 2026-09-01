import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

/// Component displaying active meal session schedule strip with pulsing Live status indicator.
class ActiveSessionStrip extends StatefulWidget {
  final String sessionName;
  final String sessionTime;

  const ActiveSessionStrip({
    super.key,
    required this.sessionName,
    required this.sessionTime,
  });

  @override
  State<ActiveSessionStrip> createState() => _ActiveSessionStripState();
}

class _ActiveSessionStripState extends State<ActiveSessionStrip>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Clock Badge
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(AppDimensions.radius8),
            ),
            child: Icon(
              Icons.access_time_filled_rounded,
              size: 18.sp,
              color: const Color(0xFF16A34A),
            ),
          ),
          SizedBox(width: 10.w),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.sessionName,
                  style: GoogleFonts.nunito(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  widget.sessionTime,
                  style: GoogleFonts.nunito(
                    fontSize: 11.sp,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),

          // Pulsing Live Badge
          Row(
            children: [
              FadeTransition(
                opacity: _pulseController,
                child: Container(
                  width: 6.w,
                  height: 6.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFF16A34A),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                "Live",
                style: GoogleFonts.nunito(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF16A34A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
