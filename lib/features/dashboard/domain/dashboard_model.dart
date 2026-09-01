import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_model.freezed.dart';
part 'dashboard_model.g.dart';

/// Representation of top viewed category stat for dashboard analytics
@freezed
class CategoryViewStat with _$CategoryViewStat {
  const factory CategoryViewStat({
    required int rank,
    required String name,
    required int views,
    required double percentage,
    required String colorHex,
  }) = _CategoryViewStat;

  factory CategoryViewStat.fromJson(Map<String, dynamic> json) =>
      _$CategoryViewStatFromJson(json);
}

/// Comprehensive Enterprise Dashboard Analytics Entity
@freezed
class DashboardModel with _$DashboardModel {
  const factory DashboardModel({
    required String restaurantName,
    required String restaurantUrl,
    required bool isPublished,
    required int totalItems,
    required int availableItems,
    required int hiddenItems,
    required int qrScansToday,
    required double qrScanDeltaPercent,
    required String peakHour,
    required int peakScans,
    required int yesterdayScans,
    required List<int> scanChartData,
    required List<String> scanChartLabels,
    required int unpublishedChangesCount,
    required String unpublishedChangesSummary,
    required String activeSessionName,
    required String activeSessionTime,
    required List<CategoryViewStat> topCategories,
  }) = _DashboardModel;

  factory DashboardModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardModelFromJson(json);
}
