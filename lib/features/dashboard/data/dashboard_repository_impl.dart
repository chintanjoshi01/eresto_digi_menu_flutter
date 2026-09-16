import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/storage/database_service.dart';
import 'datasources/dashboard_remote_datasource.dart';
import '../domain/models/v6_dashboard_response.dart';
import '../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;
  // ignore: unused_field
  final DatabaseService? _dbService;

  DashboardRepositoryImpl(this._remoteDataSource, [this._dbService]);

  @override
  Future<Either<ApiException, V6DashboardData>> getDashboardData({
    bool forceRefresh = false,
  }) async {
    try {
      final response = await _remoteDataSource.getDashboardData();
      if (response.isSuccess && response.data != null) {
        return Right(response.data!);
      }

      // If status == 0 with a message from server
      return Left(ApiException(
        message: response.message.isNotEmpty
            ? response.message
            : "Failed to load dashboard data.",
        statusCode: 200,
      ));
    } on ApiException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(
        message: "An unexpected error occurred: $e",
        statusCode: 500,
      ));
    }
  }
}
