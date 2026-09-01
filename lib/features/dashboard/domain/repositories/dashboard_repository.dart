import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exception.dart';
import '../dashboard_model.dart';

abstract class DashboardRepository {
  Future<Either<ApiException, DashboardModel>> getAnalytics({
    required String period, // today | week | month
    bool forceRefresh = false,
  });
}
