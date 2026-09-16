import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/models/v6_dashboard_response.dart';

class ActiveSessionItemData {
  final String title;
  final String channel; // "DINE-IN" or "IRD"
  final String templateAndTime;
  final String scansText;
  final String statusText;
  final bool isLive; // true for LIVE, false for UPCOMING
  final String? startsTime;

  const ActiveSessionItemData({
    required this.title,
    required this.channel,
    required this.templateAndTime,
    required this.scansText,
    required this.statusText,
    required this.isLive,
    this.startsTime,
  });
}

/// 2x2 Grid of Active Sessions matching prototype s-dash and screenshot Image 1.
class ActiveSessionGrid extends StatefulWidget {
  final List<V6SessionItem>? sessions;
  final VoidCallback? onSessionTapped;

  const ActiveSessionGrid({
    super.key,
    this.sessions,
    this.onSessionTapped,
  });

  @override
  State<ActiveSessionGrid> createState() => _ActiveSessionGridState();
}

class _ActiveSessionGridState extends State<ActiveSessionGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  static const List<ActiveSessionItemData> _fallbackSessions = [
    ActiveSessionItemData(
      title: 'Lunch',
      channel: 'DINE-IN',
      templateAndTime: 'Main · 10:30–18:30',
      scansText: '156 scans',
      statusText: 'Orders On',
      isLive: true,
    ),
    ActiveSessionItemData(
      title: 'Dinner',
      channel: 'IRD',
      templateAndTime: 'Main · 18:30–23:59',
      scansText: '91 scans',
      statusText: 'Orders On',
      isLive: true,
    ),
    ActiveSessionItemData(
      title: 'HI-TEA',
      channel: 'IRD',
      templateAndTime: 'HI-TEA · 15:00–18:00',
      scansText: '— scans',
      statusText: 'No Orders',
      isLive: true,
    ),
    ActiveSessionItemData(
      title: 'Dinner',
      channel: 'DINE-IN',
      templateAndTime: 'Main · 18:30–23:59',
      scansText: '',
      statusText: 'Orders On',
      isLive: false,
      startsTime: '18:30',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _blinkAnimation = CurvedAnimation(
      parent: _blinkController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  List<ActiveSessionItemData> _resolveItems() {
    if (widget.sessions == null || widget.sessions!.isEmpty) {
      return _fallbackSessions;
    }

    return widget.sessions!.map((s) {
      final channel = s.sessionFor.toUpperCase().contains('IRD') ? 'IRD' : 'DINE-IN';
      return ActiveSessionItemData(
        title: s.sessionName,
        channel: channel,
        templateAndTime: '${s.menuTemplateName} · ${s.timeRange}',
        scansText: s.isLive
            ? (s.todayScans > 0 ? '${s.todayScans} scans' : '— scans')
            : '',
        statusText: s.ordersBadge,
        isLive: s.isLive,
        startsTime: s.startTime,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _resolveItems();
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final rows = <Widget>[];
    for (int i = 0; i < items.length && i < 4; i += 2) {
      final first = items[i];
      final second = (i + 1 < items.length) ? items[i + 1] : null;

      if (rows.isNotEmpty) {
        rows.add(SizedBox(height: 8.h));
      }

      rows.add(
        Row(
          children: [
            Expanded(child: _buildCard(first)),
            SizedBox(width: 8.w),
            Expanded(
              child: second != null ? _buildCard(second) : const SizedBox.shrink(),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(children: rows),
    );
  }

  Widget _buildCard(ActiveSessionItemData item) {
    final isDineIn = item.channel == 'DINE-IN';
    final topBorderColor = item.isLive ? const Color(0xFF16A34A) : const Color(0xFFD97706);

    return AspectRatio(
      aspectRatio: 1.34,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onSessionTapped?.call();
            },
            borderRadius: BorderRadius.circular(12.r),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top border indicator line
                  Container(
                    height: 2.8.h,
                    color: topBorderColor,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Header Row: Status badge & Channel badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Status dot + text
                              Row(
                                children: [
                                  item.isLive
                                      ? ScaleTransition(
                                          scale: Tween<double>(begin: 0.85, end: 1.2).animate(_blinkAnimation),
                                          child: Container(
                                            width: 6.w,
                                            height: 6.h,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF16A34A),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF16A34A).withOpacity(0.55),
                                                  blurRadius: 4,
                                                  spreadRadius: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: 6.w,
                                          height: 6.h,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFD97706),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    item.isLive ? "LIVE" : "UPCOMING",
                                    style: GoogleFonts.nunito(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w800,
                                      color: item.isLive ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                              // Channel pill
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                                decoration: BoxDecoration(
                                  color: isDineIn ? const Color(0xFFFEF2F2) : const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(3.r),
                                  border: Border.all(
                                    color: isDineIn
                                        ? const Color(0xFFC1272D).withOpacity(0.35)
                                        : const Color(0xFF2563EB).withOpacity(0.35),
                                    width: 0.8,
                                  ),
                                ),
                                child: Text(
                                  item.channel,
                                  style: GoogleFonts.nunito(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w700,
                                    color: isDineIn ? const Color(0xFFC1272D) : const Color(0xFF2563EB),
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Title & Subtitle grouped cleanly
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.nunito(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w800,
                                  color: item.isLive ? const Color(0xFF111827) : const Color(0xFF6B7280),
                                  height: 1.1,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                item.templateAndTime,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.nunito(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),

                          // Footer Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (item.isLive) ...[
                                Text(
                                  item.scansText,
                                  style: GoogleFonts.nunito(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF111827),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: item.statusText == 'Orders On'
                                        ? const Color(0xFFF0FDF4)
                                        : const Color(0xFFF9FAFB),
                                    borderRadius: BorderRadius.circular(3.r),
                                  ),
                                  child: Text(
                                    item.statusText,
                                    style: GoogleFonts.nunito(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w700,
                                      color: item.statusText == 'Orders On'
                                          ? const Color(0xFF16A34A)
                                          : const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  "Orders On",
                                  style: GoogleFonts.nunito(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Starts",
                                      style: GoogleFonts.nunito(
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFD97706),
                                        height: 1,
                                      ),
                                    ),
                                    Text(
                                      item.startsTime ?? "18:30",
                                      style: GoogleFonts.nunito(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFFD97706),
                                        height: 1.1,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
        ),
      ),
    );
  }
}
