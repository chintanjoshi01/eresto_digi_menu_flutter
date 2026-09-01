import 'package:dartz/dartz.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/storage/database_service.dart';
import '../domain/dashboard_model.dart';
import '../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final ApiClient apiClient;
  final DatabaseService dbService;

  DashboardRepositoryImpl(this.apiClient, this.dbService);

  @override
  Future<Either<ApiException, DashboardModel>> getAnalytics({
    required String period,
    bool forceRefresh = false,
  }) async {
    // Return rich prototype metrics matching eresto_menu_mobile_v5.html specs
    final mockTopCategories = [
      const CategoryViewStat(
        rank: 1,
        name: "Mocktails",
        views: 203,
        percentage: 0.82,
        colorHex: "0xFFC1272D",
      ),
      const CategoryViewStat(
        rank: 2,
        name: "Starters",
        views: 151,
        percentage: 0.61,
        colorHex: "0xFFF59E0B",
      ),
      const CategoryViewStat(
        rank: 3,
        name: "Main Course",
        views: 119,
        percentage: 0.48,
        colorHex: "0xFF3B82F6",
      ),
      const CategoryViewStat(
        rank: 4,
        name: "Soups",
        views: 84,
        percentage: 0.34,
        colorHex: "0xFF16A34A",
      ),
    ];

    List<int> chartData;
    List<String> chartLabels;

    if (period == 'week') {
      chartData = [120, 180, 240, 310, 290, 380, 420];
      chartLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    } else if (period == 'month') {
      chartData = [1200, 1500, 1800, 2400];
      chartLabels = ['W1', 'W2', 'W3', 'W4'];
    } else {
      // today
      chartData = [12, 28, 45, 62, 50, 38, 12];
      chartLabels = ['10am', '12pm', '2pm', '4pm', '6pm', '8pm', '10pm'];
    }

    final model = DashboardModel(
      restaurantName: "Trulyy Tadkaaz",
      restaurantUrl: "menu.eresto.in/trulyy-tadkaaz",
      isPublished: true,
      totalItems: 361,
      availableItems: 323,
      hiddenItems: 38,
      qrScansToday: 247,
      qrScanDeltaPercent: 18.0,
      avgScansPerHour: 31,
      peakScans: 38,
      yesterdayScans: 209,
      scanChartData: chartData,
      scanChartLabels: chartLabels,
      unpublishedChangesCount: 3,
      unpublishedChangesSummary: "Aqua Marine hidden · 2 prices updated",
      activeSessionName: "Lunch Session",
      activeSessionTime: "10:30 – 18:30 · Dine-In menu · Customer orders on",
      topCategories: mockTopCategories,
    );

    return Right(model);
  }
}
