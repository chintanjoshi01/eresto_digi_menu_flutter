import 'package:flutter_test/flutter_test.dart';
import 'package:eresto_menu/core/errors/app_error_type.dart';
import 'package:eresto_menu/features/dashboard/data/dashboard_repository_impl.dart';
import 'package:eresto_menu/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:eresto_menu/features/dashboard/domain/models/v6_dashboard_response.dart';

class MockForceUpdateRemoteDataSource implements DashboardRemoteDataSource {
  final V6DashboardResponse response;
  MockForceUpdateRemoteDataSource(this.response);

  @override
  Future<V6DashboardResponse> getDashboardData({String? token, String? cv}) async {
    return response;
  }
}

void main() {
  group('Dashboard Force Upgrade Verification', () {
    const liveBackendPayload = {
      "status": 1,
      "data": {
        "version": {
          "nv_id": 17,
          "nv": "2.0.0",
          "msg": "Please Upgrade to Latest Version of Eresto Digimenu....",
          "force": 1,
        },
        "hero": {
          "resto_id": 85,
          "resto_name": "VRG Resorts",
          "resto_sub": "vrg",
          "menu_url": ["https://pmenu.eresto.app//vrg/dine-in"],
          "is_published": true,
          "total_items": 548,
          "total_categories": 52,
          "scans_today": 10,
          "scans_yesterday": 10,
          "breakdown": [],
        },
        "menu_sessions": [],
        "scan_data": {
          "peak_hour": "8 PM",
          "peak_scans": 4,
          "hourly_series": [],
          "weekly_series": [],
          "monthly_series": [],
          "yearly_series": [],
        },
      },
    };

    test('Parses backend version payload and identifies force upgrade correctly', () {
      final response = V6DashboardResponse.fromJson(liveBackendPayload);

      expect(response.status, 1);
      expect(response.isForceUpgrade, isTrue);
      expect(response.version, isNotNull);
      expect(response.version!.nvId, 17);
      expect(response.version!.nv, '2.0.0');
      expect(response.version!.force, 1);
      expect(response.version!.isForceUpgrade, isTrue);
      expect(response.upgradeMessage, "Please Upgrade to Latest Version of Eresto Digimenu....");
      expect(response.newVersion, "2.0.0");
    });

    test('DashboardRepositoryImpl intercepts force == 1 and returns Left(ApiException)', () async {
      final response = V6DashboardResponse.fromJson(liveBackendPayload);
      final repo = DashboardRepositoryImpl(MockForceUpdateRemoteDataSource(response));

      final result = await repo.getDashboardData();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure.message, "Please Upgrade to Latest Version of Eresto Digimenu....");
          expect(failure.details, isA<Map>());
          expect((failure.details as Map)['force'], 1);
          expect((failure.details as Map)['nv'], '2.0.0');
          expect((failure.details as Map)['is_force_upgrade'], isTrue);

          // Classification must be appUpdate
          final type = AppErrorClassifier.classify(failure, message: failure.message);
          expect(type, AppErrorType.appUpdate);

          // Offline mode must be disabled in visuals
          final visuals = AppErrorClassifier.getVisuals(
            type,
            latestVersion: (failure.details as Map)['nv']?.toString(),
          );
          expect(visuals.showOfflineModeAction, isFalse);
          expect(visuals.showPlayStoreAction, isTrue);
          expect(visuals.primaryButtonText, "Update on Google Play");
          expect(visuals.tips.any((t) => t.contains("Available: v2.0.0")), isTrue);
        },
        (_) => fail('Should not return Right data when force upgrade is required'),
      );
    });
  });
}
