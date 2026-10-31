import 'package:flutter_test/flutter_test.dart';
import 'package:eresto_menu/core/errors/app_error_type.dart';
import 'package:eresto_menu/core/errors/failures.dart';
import 'package:eresto_menu/core/api/api_exception.dart';
import 'package:eresto_menu/core/services/app_update_service.dart';

void main() {
  group('AppErrorClassifier Tests', () {
    test('Correctly classifies App Update messages', () {
      final type1 = AppErrorClassifier.classify(
        null,
        message: "Please update the app to the latest version.",
      );
      expect(type1, AppErrorType.appUpdate);

      final type2 = AppErrorClassifier.classify(
        null,
        message: "Please Update Your App with Latest Version from Google Play Store.",
      );
      expect(type2, AppErrorType.appUpdate);

      final type3 = AppErrorClassifier.classify(
        const AppUpgradeRequiredFailure("Upgrade required"),
      );
      expect(type3, AppErrorType.appUpdate);

      expect(
        AppUpdateService.isUpdateRequiredMessage("Please update the app to the latest version."),
        isTrue,
      );
    });

    test('Correctly classifies Network & Connectivity errors', () {
      final type1 = AppErrorClassifier.classify(
        null,
        message: "SocketException: Failed host lookup 'new.eresto.app'",
      );
      expect(type1, AppErrorType.network);

      final type2 = AppErrorClassifier.classify(
        const NetworkFailure(),
      );
      expect(type2, AppErrorType.network);

      final type3 = AppErrorClassifier.classify(
        null,
        message: "Connection timeout while requesting data",
      );
      expect(type3, AppErrorType.network);
    });

    test('Correctly classifies Maintenance errors', () {
      final type1 = AppErrorClassifier.classify(
        null,
        message: "eResto is currently undergoing scheduled maintenance",
      );
      expect(type1, AppErrorType.maintenance);

      final type2 = AppErrorClassifier.classify(
        ApiException(message: "Service Unavailable", statusCode: 503),
      );
      expect(type2, AppErrorType.maintenance);
    });

    test('Correctly classifies Unauthorized / Session Expired errors', () {
      final type1 = AppErrorClassifier.classify(
        null,
        message: "Unauthenticated.",
      );
      expect(type1, AppErrorType.unauthorized);

      final type2 = AppErrorClassifier.classify(
        ApiException(message: "Unauthorized", statusCode: 401),
      );
      expect(type2, AppErrorType.unauthorized);

      final type3 = AppErrorClassifier.classify(
        const UnauthorizedFailure(),
      );
      expect(type3, AppErrorType.unauthorized);
    });

    test('Correctly classifies Server Error (500) and PHP backend crash errors', () {
      final type1 = AppErrorClassifier.classify(
        null,
        message: 'Class "App\\Http\\Controllers\\Api\\v6\\MiscHelper" not found',
      );
      expect(type1, AppErrorType.serverError);

      final type2 = AppErrorClassifier.classify(
        ApiException(message: "Internal Server Error", statusCode: 500),
      );
      expect(type2, AppErrorType.serverError);
    });

    test('Generates correct visual metadata for App Update', () {
      final visuals = AppErrorClassifier.getVisuals(
        AppErrorType.appUpdate,
        customMessage: "Please update the app to the latest version.",
        currentVersion: "1.1.4",
      );

      expect(visuals.title, "App Update Required");
      expect(visuals.primaryButtonText, "Update on Google Play");
      expect(visuals.showPlayStoreAction, isTrue);
      expect(visuals.showOfflineModeAction, isFalse);
      expect(visuals.tips.any((t) => t.contains("1.1.4")), isTrue);
    });
  });
}
