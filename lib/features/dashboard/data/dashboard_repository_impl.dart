import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/api/endpoints.dart';
import '../../../../core/storage/database_service.dart';
import '../../../../core/storage/menu_collections.dart';
import '../domain/dashboard_model.dart';
import '../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final ApiClient _apiClient;
  final DatabaseService _dbService;

  DashboardRepositoryImpl(this._apiClient, this._dbService);

  @override
  Future<Either<ApiException, DashboardModel>> getAnalytics({
    required String period,
    bool forceRefresh = false,
  }) async {
    final isar = _dbService.isar;

    // 1. Try local cache
    final cached = await isar.dashboardAnalyticsCollections.filter().periodEqualTo(period).findFirst();
    if (cached != null && !forceRefresh) {
      final age = DateTime.now().millisecondsSinceEpoch - cached.lastUpdatedTime;
      if (age < 300000) { // 5 mins TTL
        // Get active items count and active settings from database for summary info
        final totalItems = await isar.menuItemCollections.count();
        final publishedCount = await isar.menuItemCollections.filter().isAvailableEqualTo(true).count();
        final activeSession = await isar.menuSessionCollections.filter().isActiveEqualTo(true).findFirst();
        final activeTemplate = await isar.menuTemplateCollections.filter().isActiveEqualTo(true).findFirst();

        return Right(DashboardModel(
          totalScans: cached.totalScans,
          scanChartData: cached.scanChartData,
          scanChartLabels: cached.scanChartLabels,
          activeSessionName: activeSession?.name ?? "No Session",
          activeTemplateName: activeTemplate?.name ?? "Default Theme",
          totalItems: totalItems,
          publishedItemsCount: publishedCount,
        ));
      }
    }

    // 2. Fetch remote
    try {
      final response = await _apiClient.dio.get(
        Endpoints.scanStats,
        queryParameters: {'period': period},
      );

      final responseData = response.data;
      if (responseData['success'] == true) {
        final data = responseData['data'];
        
        final totalScans = data['total_scans'] as int? ?? 0;
        final chartDataList = List<int>.from(data['chart_data'] ?? []);
        final chartLabelsList = List<String>.from(data['chart_labels'] ?? []);

        // Cache the analytics
        await isar.writeTxn(() async {
          final isarObj = cached ?? DashboardAnalyticsCollection()..period = period;
          isarObj.totalScans = totalScans;
          isarObj.scanChartData = chartDataList;
          isarObj.scanChartLabels = chartLabelsList;
          isarObj.lastUpdatedTime = DateTime.now().millisecondsSinceEpoch;
          
          await isar.dashboardAnalyticsCollections.put(isarObj);
        });

        // Summary details
        final totalItems = await isar.menuItemCollections.count();
        final publishedCount = await isar.menuItemCollections.filter().isAvailableEqualTo(true).count();
        final activeSession = await isar.menuSessionCollections.filter().isActiveEqualTo(true).findFirst();
        final activeTemplate = await isar.menuTemplateCollections.filter().isActiveEqualTo(true).findFirst();

        return Right(DashboardModel(
          totalScans: totalScans,
          scanChartData: chartDataList,
          scanChartLabels: chartLabelsList,
          activeSessionName: activeSession?.name ?? "No Session",
          activeTemplateName: activeTemplate?.name ?? "Default Theme",
          totalItems: totalItems,
          publishedItemsCount: publishedCount,
        ));
      } else {
        return Left(ApiException(message: responseData['message'] ?? 'Failed to fetch scan stats'));
      }
    } on DioException catch (e) {
      // Offline fallback: Serve cache if api fails
      if (cached != null) {
        final totalItems = await isar.menuItemCollections.count();
        final publishedCount = await isar.menuItemCollections.filter().isAvailableEqualTo(true).count();
        final activeSession = await isar.menuSessionCollections.filter().isActiveEqualTo(true).findFirst();
        final activeTemplate = await isar.menuTemplateCollections.filter().isActiveEqualTo(true).findFirst();

        return Right(DashboardModel(
          totalScans: cached.totalScans,
          scanChartData: cached.scanChartData,
          scanChartLabels: cached.scanChartLabels,
          activeSessionName: activeSession?.name ?? "No Session",
          activeTemplateName: activeTemplate?.name ?? "Default Theme",
          totalItems: totalItems,
          publishedItemsCount: publishedCount,
        ));
      }
      return Left(_apiClient.handleDioError(e));
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }
}
