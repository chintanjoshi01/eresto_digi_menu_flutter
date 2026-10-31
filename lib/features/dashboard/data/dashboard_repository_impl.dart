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

      // 1. Mandatory App Update Check (force == 1 or 2)
      // Must take precedence over everything, even when status == 1 or data is present
      if (response.isForceUpgrade) {
        return Left(ApiException(
          message: response.upgradeMessage.isNotEmpty
              ? response.upgradeMessage
              : "Please Upgrade to Latest Version of Eresto Digimenu....",
          statusCode: 200,
          details: {
            'force': response.version?.force ?? 1,
            'nv': response.newVersion,
            'nv_id': response.version?.nvId,
            'is_force_upgrade': true,
          },
        ));
      }

      // 2. Mandatory Subscription Expired Check (flag == 0 or 4)
      // Blocks access when validity and grace period both elapsed
      if (response.isSubscriptionExpired) {
        final sub = response.subscription;
        return Left(ApiException(
          message: sub?.displayMessage ??
              "Subscription has expired. Please renew your subscription to continue using services.",
          statusCode: 403,
          details: {
            'subscription_expired': true,
            'flag': sub?.flag ?? 4,
            'validity': sub?.validity ?? '',
            'days_left': sub?.daysLeft ?? 0,
            'ext_days': sub?.extDays ?? 0,
          },
        ));
      }

      if (response.isSuccess && response.data != null) {
        // Double check data payload version info
        if (response.data!.version != null && response.data!.version!.isForceUpgrade) {
          final ver = response.data!.version!;
          return Left(ApiException(
            message: ver.msg.isNotEmpty
                ? ver.msg
                : "Please Upgrade to Latest Version of Eresto Digimenu....",
            statusCode: 200,
            details: {
              'force': ver.force,
              'nv': ver.nv,
              'nv_id': ver.nvId,
              'is_force_upgrade': true,
            },
          ));
        }

        // Double check data payload subscription info
        if (response.data!.subscription != null && response.data!.subscription!.isExpired) {
          final sub = response.data!.subscription!;
          return Left(ApiException(
            message: sub.displayMessage,
            statusCode: 403,
            details: {
              'subscription_expired': true,
              'flag': sub.flag,
              'validity': sub.validity,
              'days_left': sub.daysLeft,
              'ext_days': sub.extDays,
            },
          ));
        }

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
