// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardModelImpl _$$DashboardModelImplFromJson(Map<String, dynamic> json) =>
    _$DashboardModelImpl(
      totalScans: (json['totalScans'] as num).toInt(),
      scanChartData: (json['scanChartData'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      scanChartLabels: (json['scanChartLabels'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      activeSessionName: json['activeSessionName'] as String?,
      activeTemplateName: json['activeTemplateName'] as String?,
      totalItems: (json['totalItems'] as num).toInt(),
      publishedItemsCount: (json['publishedItemsCount'] as num).toInt(),
    );

Map<String, dynamic> _$$DashboardModelImplToJson(
        _$DashboardModelImpl instance) =>
    <String, dynamic>{
      'totalScans': instance.totalScans,
      'scanChartData': instance.scanChartData,
      'scanChartLabels': instance.scanChartLabels,
      'activeSessionName': instance.activeSessionName,
      'activeTemplateName': instance.activeTemplateName,
      'totalItems': instance.totalItems,
      'publishedItemsCount': instance.publishedItemsCount,
    };
