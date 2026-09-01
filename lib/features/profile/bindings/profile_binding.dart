import 'package:get/get.dart';
import '../../../../core/storage/storage_service.dart';
import '../../auth/domain/repositories/auth_repository.dart';
import '../presentation/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        Get.find<AuthRepository>(),
        Get.find<StorageService>(),
      ),
    );
  }
}
