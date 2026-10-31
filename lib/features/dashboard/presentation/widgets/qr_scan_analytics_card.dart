import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../domain/menu_service_stat.dart';

/// Enterprise Analytics Card matching prototype screenshot media_1789021404987.png 100%.
class QrScanAnalyticsCard extends StatelessWidget {
  final int totalScans;
  final double deltaPercent;
  final String activePeriod;
  final ValueChanged<String> onPeriodChanged;
  final String selectedMenuFilter;
  final ValueChanged<String> onMenuFilterChanged;
  final List<MenuServiceStat> menuServices;
  final List<int> chartData;
  final List<String> chartLabels;
  final String peakHour;
  final int peakScans;
  final int yesterdayScans;
  final EdgeInsetsGeometry? margin;

  const QrScanAnalyticsCard({
    super.key,
    required this.totalScans,
    required this.deltaPercent,
    required this.activePeriod,
    required this.onPeriodChanged,
    this.selectedMenuFilter = 'all',
    required this.onMenuFilterChanged,
    required this.menuServices,
    required this.chartData,
    required this.chartLabels,
    this.peakHour = "6–7 PM",
    required this.peakScans,
    required this.yesterdayScans,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    int maxVal = 0;
    int maxIdx = 0;
    for (int i = 0; i < chartData.length; i++) {
      if (chartData[i] > maxVal) {
        maxVal = chartData[i];
        maxIdx = i;
      }
    }

    return Container(
      margin: margin,
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Menu Filter Bar (Horizontally scrollable for any number of categories)
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1.5)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: menuServices.map((service) {
                  final isSelected = selectedMenuFilter == service.id;
                  return InkWell(
                    onTap: () => onMenuFilterChanged(service.id),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected ? const Color(0xFFC1272D) : Colors.transparent,
                            width: 2.w,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            service.name,
                            style: GoogleFonts.poppins(
                              fontSize: 11.sp,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? const Color(0xFFC1272D) : const Color(0xFF9CA3AF),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            service.scansCount.toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? const Color(0xFFC1272D) : const Color(0xFF374151),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // 2. Trend Subtitle + Period Selector Pills (Today / Week / Month)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 13.sp,
                      color: const Color(0xFF9CA3AF),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        "${_getPeriodLabel(activePeriod)} scan trend",
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6B7280),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 6.w),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPeriodPill("today", "Today"),
                  SizedBox(width: 3.w),
                  _buildPeriodPill("week", "Week"),
                  SizedBox(width: 3.w),
                  _buildPeriodPill("month", "Month"),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // 3. Main Metric readout (247 + ↑ 18% vs yesterday)
          Builder(
            builder: (context) {
              final isPositive = deltaPercent >= 0;
              final deltaColor = isPositive ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
              final deltaIcon = isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    totalScans.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                      height: 1.0,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Icon(deltaIcon, size: 11.sp, color: deltaColor),
                      SizedBox(width: 2.w),
                      Text(
                        "${deltaPercent.abs().toInt()}% vs yesterday",
                        style: GoogleFonts.poppins(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w500,
                          color: deltaColor,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 12.h),

          // 4. Cubic Curve Chart with Floating Tooltip Box (Peak - 38)
          Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: 94.h,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 18,
                          interval: 1.0,
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            if (idx >= 0 && idx < chartLabels.length) {
                              final isNow = chartLabels[idx].toLowerCase() == 'now';
                              return Padding(
                                padding: EdgeInsets.only(top: 4.h),
                                child: Text(
                                  chartLabels[idx],
                                  style: GoogleFonts.poppins(
                                    fontSize: 8.5.sp,
                                    color: isNow ? AppColors.primary : const Color(0xFF9CA3AF),
                                    fontWeight: isNow ? FontWeight.w600 : FontWeight.w400,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: (chartData.isNotEmpty ? (chartData.length - 1) : 0).toDouble(),
                    minY: 0,
                    maxY: (maxVal > 0 ? maxVal * 1.3 : 10).toDouble(),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          chartData.length,
                          (i) => FlSpot(i.toDouble(), chartData[i].toDouble()),
                        ),
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: AppColors.primary,
                        barWidth: 2.4.w,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            if (maxVal > 0 && index == maxIdx) {
                              return FlDotCirclePainter(
                                radius: 4.r,
                                color: Colors.white,
                                strokeWidth: 2.w,
                                strokeColor: const Color(0xFFC1272D),
                              );
                            }
                            if (maxVal > 0 && index == chartData.length - 1) {
                              return FlDotCirclePainter(
                                radius: 3.5.r,
                                color: Colors.white,
                                strokeWidth: 1.8.w,
                                strokeColor: const Color(0xFFC1272D),
                              );
                            }
                            return FlDotCirclePainter(
                              radius: 0,
                              color: Colors.transparent,
                              strokeWidth: 0,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFFC1272D).withOpacity(0.12),
                              const Color(0xFFC1272D).withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Floating Peak Tooltip Callout Box (Peak · 38)
              if (peakScans > 0)
                Positioned(
                  right: 36.w,
                  top: 2.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.5.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC1272D),
                      borderRadius: BorderRadius.circular(4.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFC1272D).withOpacity(0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      "Peak · $peakScans",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 8.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _getPeriodLabel(String period) {
    if (period == 'week') return "This week's";
    if (period == 'month') return "This month's";
    return "Today's";
  }

  Widget _buildPeriodPill(String id, String label) {
    final isSelected = activePeriod == id;
    return InkWell(
      onTap: () => onPeriodChanged(id),
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC1272D) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? const Color(0xFFC1272D) : const Color(0xFFE5E7EB),
            width: 1.5.w,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 9.5.sp,
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
