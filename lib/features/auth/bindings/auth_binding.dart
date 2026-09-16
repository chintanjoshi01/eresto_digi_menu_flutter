import 'package:get/get.dart';

import '../../../core/services/device_service.dart';
import '../../../core/storage/storage_service.dart';
import '../data/datasources/login_sync_datasource.dart';
import '../domain/repositories/auth_repository.dart';
import '../presentation/controllers/login_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(
        authRepository: Get.find<AuthRepository>(),
        storageService: Get.find<StorageService>(),
        deviceService: Get.find<DeviceService>(),
        loginSyncRepository: Get.isRegistered<LoginSyncRepository>()
            ? Get.find<LoginSyncRepository>()
            : null,
      ),
    );
  }
}
