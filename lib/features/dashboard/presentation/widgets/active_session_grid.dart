import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/v6_dashboard_response.dart';

class ActiveSessionItemData {
  final int id;
  final String title;
  final String channel; // Raw slug e.g. "dine-in", "ird", "cat2", "cat3", etc.
  final String channelLabel; // Formatted display label e.g. "Dine-IN", "IRD", "Cat2", etc.
  final String templateAndTime;
  final String scansText;
  final String statusText;
  final bool isLive; // true for LIVE, false for UPCOMING
  final String? startsTime;
  final V6SessionItem? rawSession;

  const ActiveSessionItemData({
    this.id = 0,
    required this.title,
    required this.channel,
    required this.channelLabel,
    required this.templateAndTime,
    required this.scansText,
    required this.statusText,
    required this.isLive,
    this.startsTime,
    this.rawSession,
  });
}

/// 2x2 Grid of Active Live Sessions with Option C 'View More' support.
class ActiveSessionGrid extends StatefulWidget {
  final List<V6SessionItem>? sessions;
  final void Function(ActiveSessionItemData item)? onSessionTapped;
  final VoidCallback? onViewMoreTapped;

  const ActiveSessionGrid({
    super.key,
    this.sessions,
    this.onSessionTapped,
    this.onViewMoreTapped,
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
      id: 1,
      title: 'Lunch',
      channel: 'dine-in',
      channelLabel: 'Dine-IN',
      templateAndTime: 'Main · 10:30–18:30',
      scansText: '156 scans',
      statusText: 'Orders On',
      isLive: true,
    ),
    ActiveSessionItemData(
      id: 2,
      title: 'Dinner',
      channel: 'ird',
      channelLabel: 'IRD',
      templateAndTime: 'Main · 18:30–23:59',
      scansText: '91 scans',
      statusText: 'Orders On',
      isLive: true,
    ),
    ActiveSessionItemData(
      id: 3,
      title: 'HI-TEA',
      channel: 'ird',
      channelLabel: 'IRD',
      templateAndTime: 'HI-TEA · 15:00–18:00',
      scansText: '— scans',
      statusText: 'No Orders',
      isLive: true,
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
      return _fallbackSessions.where((s) => s.isLive).toList();
    }

    // Strictly show ONLY LIVE sessions
    return widget.sessions!
        .where((s) => s.isLive)
        .map((s) {
          final channelSlug = s.sessionFor.toLowerCase().trim();
          final channelLabel = s.menuType.isNotEmpty
              ? s.menuType
              : (s.sessionFor.toUpperCase());

          return ActiveSessionItemData(
            id: s.id,
            title: s.sessionName,
            channel: channelSlug,
            channelLabel: channelLabel,
            templateAndTime: '${s.menuTemplateName} · ${s.timeRange}',
            scansText: s.isLive
                ? (s.todayScans > 0 ? '${s.todayScans} scans' : '— scans')
                : '',
            statusText: s.ordersBadge,
            isLive: s.isLive,
            startsTime: s.startTime,
            rawSession: s,
          );
        }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final liveItems = _resolveItems();
    if (liveItems.isEmpty) {
      return _buildNoActiveSessions();
    }

    // Option C: If more than 4, show 4 in 2x2 grid and show View More below
    final hasMore = liveItems.length > 4;
    final displayedItems = hasMore ? liveItems.take(4).toList() : liveItems;
    final remainingItems = hasMore ? liveItems.skip(4).toList() : <ActiveSessionItemData>[];

    final rows = <Widget>[];
    for (int i = 0; i < displayedItems.length; i += 2) {
      final first = displayedItems[i];
      final second = (i + 1 < displayedItems.length) ? displayedItems[i + 1] : null;

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
      child: Column(
        children: [
          ...rows,
          if (hasMore) ...[
            SizedBox(height: 8.h),
            _buildViewMoreCard(context, remainingItems.length, remainingItems),
          ],
        ],
      ),
    );
  }

  Widget _buildViewMoreCard(
    BuildContext context,
    int remainingCount,
    List<ActiveSessionItemData> remainingItems,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openRemainingSessionsSheet(context, remainingItems),
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  "+$remainingCount more live",
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF15803D),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  "Tap to view remaining session${remainingCount > 1 ? 's' : ''}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF374151),
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Icon(
                Icons.keyboard_arrow_up_rounded,
                size: 18.sp,
                color: const Color(0xFF6B7280),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openRemainingSessionsSheet(
    BuildContext context,
    List<ActiveSessionItemData> remainingItems,
  ) {
    HapticFeedback.lightImpact();
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.70,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 10.h, bottom: 8.h),
                  width: 38.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              // Header Row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Active Live Sessions",
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            "● ${remainingItems.length} more",
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF15803D),
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, size: 20.sp, color: const Color(0xFF6B7280)),
                      onPressed: () => Get.back(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Text(
                      "Tap any session to view & edit in Menu tab",
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10.h),
              const Divider(height: 1, color: Color(0xFFE5E7EB)),
              SizedBox(height: 12.h),

              // Remaining cards displayed in 2-column grid identical to dashboard
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    12.w,
                    4.h,
                    12.w,
                    16.h + MediaQuery.of(context).padding.bottom,
                  ),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      for (int i = 0; i < remainingItems.length; i += 2) ...[
                        if (i > 0) SizedBox(height: 8.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildCard(
                                remainingItems[i],
                                onTapped: () {
                                  Get.back();
                                  widget.onSessionTapped?.call(remainingItems[i]);
                                },
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: (i + 1 < remainingItems.length)
                                  ? _buildCard(
                                      remainingItems[i + 1],
                                      onTapped: () {
                                        Get.back();
                                        widget.onSessionTapped?.call(remainingItems[i + 1]);
                                      },
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildNoActiveSessions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onViewMoreTapped?.call();
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFF3F4F6)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.schedule_rounded, size: 18.sp, color: AppColors.primary),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "No Active Sessions Now",
                        style: GoogleFonts.poppins(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "Tap to check schedules and manage channels",
                        style: GoogleFonts.poppins(
                          fontSize: 10.5.sp,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, size: 18.sp, color: const Color(0xFF9CA3AF)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(ActiveSessionItemData item, {VoidCallback? onTapped}) {
    final channelSlug = item.channel.toLowerCase();
    Color channelColor = const Color(0xFFC1272D); // default Dine-in red
    Color channelBg = const Color(0xFFFEF2F2);
    if (channelSlug.contains('ird')) {
      channelColor = const Color(0xFF2563EB); // blue
      channelBg = const Color(0xFFEFF6FF);
    } else if (channelSlug.contains('takeaway')) {
      channelColor = const Color(0xFFD97706); // amber
      channelBg = const Color(0xFFFFFBEB);
    } else if (channelSlug.contains('delivery')) {
      channelColor = const Color(0xFF059669); // green
      channelBg = const Color(0xFFECFDF5);
    } else if (channelSlug.startsWith('cat')) {
      channelColor = const Color(0xFF7C3AED); // purple for categories
      channelBg = const Color(0xFFF5F3FF);
    }
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
              if (onTapped != null) {
                onTapped();
              } else {
                widget.onSessionTapped?.call(item);
              }
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
                                    style: GoogleFonts.poppins(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w600,
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
                                  color: channelBg,
                                  borderRadius: BorderRadius.circular(3.r),
                                  border: Border.all(
                                    color: channelColor.withOpacity(0.35),
                                    width: 0.8,
                                  ),
                                ),
                                child: Text(
                                  item.channelLabel,
                                  style: GoogleFonts.poppins(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w600,
                                    color: channelColor,
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
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: item.isLive ? const Color(0xFF111827) : const Color(0xFF6B7280),
                                  height: 1.1,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                item.templateAndTime,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w400,
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
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
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
                                    style: GoogleFonts.poppins(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w500,
                                      color: item.statusText == 'Orders On'
                                          ? const Color(0xFF16A34A)
                                          : const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  "Orders On",
                                  style: GoogleFonts.poppins(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Starts",
                                      style: GoogleFonts.poppins(
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFFD97706),
                                        height: 1,
                                      ),
                                    ),
                                    Text(
                                      item.startsTime ?? "18:30",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
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
