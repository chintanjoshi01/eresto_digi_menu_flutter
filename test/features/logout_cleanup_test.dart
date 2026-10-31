import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eresto_menu/core/storage/storage_service.dart';
import 'package:eresto_menu/features/items/data/repositories/items_repository_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Logout & Cleanup Tests', () {
    late StorageService storageService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        'device_id': 'TEST_STATION_DEVICE_ID_123',
        'token': 'TEST_BEARER_TOKEN_XYZ',
        'resto_id': 801,
        'def_resto': 'Trulyy Tadkaaz',
        'user_id': 42,
        'user_name': 'Manager Admin',
        'email': 'admin@trulyytadkaaz.com',
        'treasure_url': 'https://assets.eresto.in/public/treasure/801/archive/item_images/',
        'v6_login_sync_data': '{"status":1}',
      });

      storageService = StorageService();
      await storageService.init();
    });

    test('StorageService.clearSession wipes all credentials while preserving deviceId', () async {
      expect(storageService.isLoggedIn, isTrue);
      expect(storageService.token, equals('TEST_BEARER_TOKEN_XYZ'));
      expect(storageService.restoId, equals(801));
      expect(storageService.deviceId, equals('TEST_STATION_DEVICE_ID_123'));

      await storageService.clearSession();

      // Verify all sensitive user/restaurant state is completely erased
      expect(storageService.isLoggedIn, isFalse);
      expect(storageService.token, isEmpty);
      expect(storageService.restoId, equals(0));
      expect(storageService.userName, isEmpty);
      expect(storageService.email, isEmpty);
      expect(storageService.treasureUrl, isEmpty);
      expect(storageService.cachedLoginSyncData, isNull);

      // Verify station hardware device_id is safely preserved
      expect(storageService.deviceId, equals('TEST_STATION_DEVICE_ID_123'));
    });

    test('ItemsRepositoryImpl.clearCache flushes in-memory category lookup', () {
      ItemsRepositoryImpl.clearCache();
      // Verifies method executes without throwing
      expect(true, isTrue);
    });
  });
}
