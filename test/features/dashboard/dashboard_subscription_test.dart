import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eresto_menu/core/errors/app_error_type.dart';
import 'package:eresto_menu/core/widgets/app_error_view.dart';
import 'package:eresto_menu/features/dashboard/data/dashboard_repository_impl.dart';
import 'package:eresto_menu/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:eresto_menu/features/dashboard/domain/models/v6_dashboard_response.dart';
import 'package:eresto_menu/features/dashboard/presentation/widgets/subscription_banner.dart';

class MockDashboardRemoteDataSource implements DashboardRemoteDataSource {
  final V6DashboardResponse response;
  MockDashboardRemoteDataSource(this.response);

  @override
  Future<V6DashboardResponse> getDashboardData({String? token, String? cv}) async {
    return response;
  }
}

Widget _wrap(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    minTextAdapt: true,
    builder: (context, _) => MaterialApp(
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('Subscription Flag Tests', () {
    test('Flag 1 (Active): > 7 days remaining, normal status, no banner', () {
      final json = {
        "status": 1,
        "data": {
          "subscription": {
            "flag": 1,
            "message": "Subscription is active.",
            "validity": "2026-12-31",
            "days_left": 84,
            "ext_days": 0,
            "ext_validity": "",
          },
          "hero": {"resto_id": 85, "resto_name": "VRG Resorts", "resto_sub": "vrg", "menu_url": [], "is_published": true, "total_items": 10, "total_categories": 2, "scans_today": 0, "scans_yesterday": 0, "breakdown": []},
          "menu_sessions": [],
          "scan_data": {"peak_hour": "8 PM", "peak_scans": 0, "hourly_series": [], "weekly_series": [], "monthly_series": [], "yearly_series": []},
        },
      };

      final response = V6DashboardResponse.fromJson(json);
      expect(response.subscription, isNotNull);
      expect(response.subscription!.isActive, isTrue);
      expect(response.subscription!.isExpiringSoon, isFalse);
      expect(response.subscription!.isInGracePeriod, isFalse);
      expect(response.subscription!.isExpired, isFalse);
      expect(response.subscription!.shouldShowWarningBanner, isFalse);
      expect(response.isSubscriptionExpired, isFalse);
    });

    test('Flag 2 (Expiring Soon): 0 to 7 days remaining, warning banner active', () {
      final json = {
        "status": 1,
        "data": {
          "subscription": {
            "flag": 2,
            "message": "Your subscription will expire in 5 days.",
            "validity": "2026-10-15",
            "days_left": 5,
            "ext_days": 3,
            "ext_validity": "2026-10-18",
          },
          "hero": {"resto_id": 85, "resto_name": "VRG Resorts", "resto_sub": "vrg", "menu_url": [], "is_published": true, "total_items": 10, "total_categories": 2, "scans_today": 0, "scans_yesterday": 0, "breakdown": []},
          "menu_sessions": [],
          "scan_data": {"peak_hour": "8 PM", "peak_scans": 0, "hourly_series": [], "weekly_series": [], "monthly_series": [], "yearly_series": []},
        },
      };

      final response = V6DashboardResponse.fromJson(json);
      expect(response.subscription, isNotNull);
      expect(response.subscription!.isExpiringSoon, isTrue);
      expect(response.subscription!.shouldShowWarningBanner, isTrue);
      expect(response.subscription!.daysLeft, 5);
      expect(response.isSubscriptionExpired, isFalse);
    });

    test('Flag 3 (Grace Period): expired but within ext_days, urgent banner active', () {
      final json = {
        "status": 1,
        "data": {
          "subscription": {
            "flag": 3,
            "message": "Subscription expired. Grace period is active for 3 more days. Please renew now.",
            "validity": "2026-10-05",
            "days_left": 0,
            "ext_days": 3,
            "ext_validity": "2026-10-08",
          },
          "hero": {"resto_id": 85, "resto_name": "VRG Resorts", "resto_sub": "vrg", "menu_url": [], "is_published": true, "total_items": 10, "total_categories": 2, "scans_today": 0, "scans_yesterday": 0, "breakdown": []},
          "menu_sessions": [],
          "scan_data": {"peak_hour": "8 PM", "peak_scans": 0, "hourly_series": [], "weekly_series": [], "monthly_series": [], "yearly_series": []},
        },
      };

      final response = V6DashboardResponse.fromJson(json);
      expect(response.subscription, isNotNull);
      expect(response.subscription!.isInGracePeriod, isTrue);
      expect(response.subscription!.shouldShowWarningBanner, isTrue);
      expect(response.subscription!.extDays, 3);
      expect(response.isSubscriptionExpired, isFalse);
    });

    test('Flag 0 (Expired): validity and grace period elapsed -> repository blocks access', () async {
      final json = {
        "status": 1,
        "data": {
          "subscription": {
            "flag": 0,
            "message": "Subscription has expired. Please renew your subscription to continue using services.",
            "validity": "2026-10-01",
            "days_left": 0,
            "ext_days": 0,
            "ext_validity": "2026-10-04",
          },
          "hero": {"resto_id": 85, "resto_name": "VRG Resorts", "resto_sub": "vrg", "menu_url": [], "is_published": true, "total_items": 10, "total_categories": 2, "scans_today": 0, "scans_yesterday": 0, "breakdown": []},
          "menu_sessions": [],
          "scan_data": {"peak_hour": "8 PM", "peak_scans": 0, "hourly_series": [], "weekly_series": [], "monthly_series": [], "yearly_series": []},
        },
      };

      final response = V6DashboardResponse.fromJson(json);
      expect(response.isSubscriptionExpired, isTrue);

      final repo = DashboardRepositoryImpl(MockDashboardRemoteDataSource(response));
      final result = await repo.getDashboardData();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure.statusCode, 403);
          expect(failure.details, isA<Map>());
          expect((failure.details as Map)['subscription_expired'], isTrue);
          expect((failure.details as Map)['flag'], 0);

          final type = AppErrorClassifier.classify(failure, message: failure.message);
          expect(type, AppErrorType.subscriptionExpired);

          final visuals = AppErrorClassifier.getVisuals(type);
          expect(visuals.showOfflineModeAction, isFalse);
          expect(visuals.title, "Subscription Expired");
          expect(visuals.primaryButtonText, "Renew Subscription");
        },
        (_) => fail('Expired subscription should not return Right data'),
      );
    });

    test('Flag 4 (Live Server Expired Payload): flag 4 blocks dashboard access and classifies as subscriptionExpired', () async {
      // Exact payload captured from live moto g54 5G device logs:
      final json = {
        "status": 1,
        "data": {
          "version": null,
          "subscription": {
            "flag": 4,
            "message": "Subscription has expired. Please renew your subscription to continue using services.",
            "validity": "2025-12-31",
            "days_left": 0,
            "ext_days": 0,
            "ext_validity": "2025-12-31",
          },
          "hero": {
            "resto_id": 85,
            "resto_name": "VRG Resorts",
            "resto_sub": "vrg",
            "menu_url": ["https://pmenu.eresto.app/vrg/dine-in"],
            "is_published": true,
            "total_items": 548,
            "total_categories": 52,
            "scans_today": 14,
            "scans_yesterday": 10,
            "breakdown": [],
          },
          "menu_sessions": [],
          "scan_data": {
            "from_date": "2026-09-08",
            "to_date": "2026-10-08",
            "scans_today": 14,
            "scans_yesterday": 10,
            "daily_scans": [],
          },
        },
      };

      final response = V6DashboardResponse.fromJson(json);
      expect(response.subscription, isNotNull);
      expect(response.subscription!.isExpired, isTrue);
      expect(response.subscription!.isActive, isFalse);
      expect(response.subscription!.shouldShowWarningBanner, isFalse);
      expect(response.isSubscriptionExpired, isTrue);

      final repo = DashboardRepositoryImpl(MockDashboardRemoteDataSource(response));
      final result = await repo.getDashboardData();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure.statusCode, 403);
          expect(failure.details, isA<Map>());
          expect((failure.details as Map)['subscription_expired'], isTrue);
          expect((failure.details as Map)['flag'], 4);
          expect((failure.details as Map)['validity'], "2025-12-31");

          final type = AppErrorClassifier.classify(failure, message: failure.message);
          expect(type, AppErrorType.subscriptionExpired);

          final visuals = AppErrorClassifier.getVisuals(type);
          expect(visuals.showOfflineModeAction, isFalse);
          expect(visuals.title, "Subscription Expired");
          expect(visuals.primaryButtonText, "Renew Subscription");
        },
        (_) => fail('Flag 4 expired subscription must not return Right data'),
      );
    });

    testWidgets('SubscriptionBanner renders Flag 2 warning styling with Renew action', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      bool renewClicked = false;
      const sub = V6SubscriptionInfo(
        flag: 2,
        message: "Your subscription will expire in 4 days. Please renew now.",
        validity: "2026-10-14",
        daysLeft: 4,
        extDays: 3,
        extValidity: "2026-10-17",
      );

      await tester.pumpWidget(
        _wrap(
          SubscriptionBanner(
            subscription: sub,
            onRenew: () => renewClicked = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("4 DAYS LEFT"), findsOneWidget);
      expect(find.text("Your subscription will expire in 4 days. Please renew now."), findsOneWidget);
      expect(find.text("Renew"), findsOneWidget);

      await tester.tap(find.text("Renew"));
      await tester.pumpAndSettle();
      expect(renewClicked, isTrue);
    });

    testWidgets('SubscriptionBanner renders Flag 3 Grace Period styling with Renew Now action', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      bool renewClicked = false;
      const sub = V6SubscriptionInfo(
        flag: 3,
        message: "Subscription expired. Grace period is active for 2 more days. Please renew now.",
        validity: "2026-10-06",
        daysLeft: 0,
        extDays: 2,
        extValidity: "2026-10-08",
      );

      await tester.pumpWidget(
        _wrap(
          SubscriptionBanner(
            subscription: sub,
            onRenew: () => renewClicked = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("GRACE PERIOD"), findsOneWidget);
      expect(find.text("Subscription expired. Grace period is active for 2 more days. Please renew now."), findsOneWidget);
      expect(find.text("Renew Now"), findsOneWidget);

      await tester.tap(find.text("Renew Now"));
      await tester.pumpAndSettle();
      expect(renewClicked, isTrue);
    });

    testWidgets('AppErrorView renders Subscription Expired screen without offline mode button', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      bool renewClicked = false;
      bool offlineClicked = false;

      await tester.pumpWidget(
        _wrap(
          AppErrorView(
            errorType: AppErrorType.subscriptionExpired,
            errorMessage: "Subscription has expired. Please renew your subscription to continue using services.",
            onRenew: () => renewClicked = true,
            onOfflineMode: () => offlineClicked = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("Subscription Expired"), findsOneWidget);
      expect(find.text("Subscription has expired. Please renew your subscription to continue using services."), findsOneWidget);
      expect(find.text("Renew Subscription"), findsOneWidget);
      expect(find.text("Continue in Offline Mode"), findsNothing);
      expect(offlineClicked, isFalse);

      await tester.tap(find.text("Renew Subscription"));
      await tester.pumpAndSettle();
      expect(renewClicked, isTrue);
    });
  });
}
