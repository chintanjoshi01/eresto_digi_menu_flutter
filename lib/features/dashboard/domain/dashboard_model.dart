import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_model.freezed.dart';
part 'dashboard_model.g.dart';

@freezed
class DashboardModel with _$DashboardModel {
  const factory DashboardModel({
    required int totalScans,
    required List<int> scanChartData,
    required List<String> scanChartLabels,
    required String? activeSessionName,
    required String? activeTemplateName,
    required int totalItems,
    required int publishedItemsCount,
  }) = _DashboardModel;

  factory DashboardModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardModelFromJson(json);
}
