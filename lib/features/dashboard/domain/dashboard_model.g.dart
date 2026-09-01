// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryViewStatImpl _$$CategoryViewStatImplFromJson(
        Map<String, dynamic> json) =>
    _$CategoryViewStatImpl(
      rank: (json['rank'] as num).toInt(),
      name: json['name'] as String,
      views: (json['views'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
      colorHex: json['colorHex'] as String,
    );

Map<String, dynamic> _$$CategoryViewStatImplToJson(
        _$CategoryViewStatImpl instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'name': instance.name,
      'views': instance.views,
      'percentage': instance.percentage,
      'colorHex': instance.colorHex,
    };

_$DashboardModelImpl _$$DashboardModelImplFromJson(Map<String, dynamic> json) =>
    _$DashboardModelImpl(
      restaurantName: json['restaurantName'] as String,
      restaurantUrl: json['restaurantUrl'] as String,
      isPublished: json['isPublished'] as bool,
      totalItems: (json['totalItems'] as num).toInt(),
      availableItems: (json['availableItems'] as num).toInt(),
      hiddenItems: (json['hiddenItems'] as num).toInt(),
      qrScansToday: (json['qrScansToday'] as num).toInt(),
      qrScanDeltaPercent: (json['qrScanDeltaPercent'] as num).toDouble(),
      avgScansPerHour: (json['avgScansPerHour'] as num).toInt(),
      peakScans: (json['peakScans'] as num).toInt(),
      yesterdayScans: (json['yesterdayScans'] as num).toInt(),
      scanChartData: (json['scanChartData'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      scanChartLabels: (json['scanChartLabels'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      unpublishedChangesCount: (json['unpublishedChangesCount'] as num).toInt(),
      unpublishedChangesSummary: json['unpublishedChangesSummary'] as String,
      activeSessionName: json['activeSessionName'] as String,
      activeSessionTime: json['activeSessionTime'] as String,
      topCategories: (json['topCategories'] as List<dynamic>)
          .map((e) => CategoryViewStat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DashboardModelImplToJson(
        _$DashboardModelImpl instance) =>
    <String, dynamic>{
      'restaurantName': instance.restaurantName,
      'restaurantUrl': instance.restaurantUrl,
      'isPublished': instance.isPublished,
      'totalItems': instance.totalItems,
      'availableItems': instance.availableItems,
      'hiddenItems': instance.hiddenItems,
      'qrScansToday': instance.qrScansToday,
      'qrScanDeltaPercent': instance.qrScanDeltaPercent,
      'avgScansPerHour': instance.avgScansPerHour,
      'peakScans': instance.peakScans,
      'yesterdayScans': instance.yesterdayScans,
      'scanChartData': instance.scanChartData,
      'scanChartLabels': instance.scanChartLabels,
      'unpublishedChangesCount': instance.unpublishedChangesCount,
      'unpublishedChangesSummary': instance.unpublishedChangesSummary,
      'activeSessionName': instance.activeSessionName,
      'activeSessionTime': instance.activeSessionTime,
      'topCategories': instance.topCategories,
    };
