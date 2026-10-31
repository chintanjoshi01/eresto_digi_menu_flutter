import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';
import '../storage/storage_service.dart';

/// Enterprise Device Service managing persistent device hardware/installation identity
/// and client environment metadata without invasive runtime permissions.
class DeviceService extends GetxService {
  final StorageService _storageService;
  late String _deviceId;
  static String appVersion = "1.1.4"; // Default matching pubspec.yaml version
  static String buildNumber = "10";
  static const int productId = 9; // 9 = Eresto One / DigiMenu
  static const int loginFrom = 1; // 1 = Mobile

  DeviceService(this._storageService);

  Future<DeviceService> init() async {
    _deviceId = _storageService.deviceId;
    if (_deviceId.isEmpty) {
      _deviceId = const Uuid().v4();
      await _storageService.saveDeviceId(_deviceId);
    }

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (packageInfo.version.isNotEmpty) {
        appVersion = packageInfo.version;
      }
      if (packageInfo.buildNumber.isNotEmpty) {
        buildNumber = packageInfo.buildNumber;
      }
    } catch (_) {
      // In tests or headless execution, platform channels may be unavailable
    }

    return this;
  }

  /// Persistent unique device/client identifier passed to `IMEI` parameter
  String get deviceId => _deviceId;
}
