import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

/// Enterprise Analytics Card displaying QR scans metrics, period filters,
/// cubic curve charts via fl_chart, and summary metric footers.
class QrScanAnalyticsCard extends StatelessWidget {
  final int totalScans;
  final double deltaPercent;
  final String activePeriod;
  final ValueChanged<String> onPeriodChanged;
  final List<int> chartData;
  final List<String> chartLabels;
  final int avgScansPerHour;
  final int peakScans;
  final int yesterdayScans;
  final EdgeInsetsGeometry? margin;

  const QrScanAnalyticsCard({
    super.key,
    required this.totalScans,
    required this.deltaPercent,
    required this.activePeriod,
    required this.onPeriodChanged,
    required this.chartData,
    required this.chartLabels,
    required this.avgScansPerHour,
    required this.peakScans,
    required this.yesterdayScans,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(left: 14.w, right: 14.w, top: -28.h),
      padding: EdgeInsets.all(14.w),
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
          // Header Row: Scans Count + Period Selector Pills
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 14.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "QR Scans Today",
                        style: GoogleFonts.nunito(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    totalScans.toString(),
                    style: GoogleFonts.nunito(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                      height: 1.0,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.trending_up_rounded,
                        size: 14.sp,
                        color: const Color(0xFF16A34A),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        "↑ ${deltaPercent.toInt()}% vs yesterday",
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
              // Period Selector Pills
              Row(
                children: [
                  _buildPeriodPill("today", "Today"),
                  SizedBox(width: 4.w),
                  _buildPeriodPill("week", "Week"),
                  SizedBox(width: 4.w),
                  _buildPeriodPill("month", "Month"),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Cubic Curve Chart (fl_chart)
          SizedBox(
            height: 95.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (val) => FlLine(
                    color: const Color(0xFFF3F4F6),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: GoogleFonts.nunito(
                            fontSize: 9.sp,
                            color: Colors.grey.shade400,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 18,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < chartLabels.length) {
                          return Text(
                            chartLabels[idx],
                            style: GoogleFonts.nunito(
                              fontSize: 9.sp,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: chartData.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.toDouble());
                    }).toList(),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppColors.primary,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary.withOpacity(0.25),
                          AppColors.primary.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Bottom Metric Footer Row
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
            ),
            child: Row(
              children: [
                _buildSummaryStat("Average", "$avgScansPerHour/hr"),
                _buildSummaryDivider(),
                _buildSummaryStat("Peak Scans", peakScans.toString()),
                _buildSummaryDivider(),
                _buildSummaryStat("Yesterday", yesterdayScans.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodPill(String id, String label) {
    final isSelected = activePeriod == id;
    return GestureDetector(
      onTap: () => onPeriodChanged(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
        ),
        child: Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 11.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF4B5563),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 10.sp,
              color: const Color(0xFF9CA3AF),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryDivider() {
    return Container(
      width: 1.w,
      height: 20.h,
      color: const Color(0xFFF3F4F6),
    );
  }
}
