import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exception.dart';
import '../models/v6_dashboard_response.dart';

abstract class DashboardRepository {
  Future<Either<ApiException, V6DashboardData>> getDashboardData({
    bool forceRefresh = false,
  });
}
