import 'package:get/get.dart';
import '../../../../core/storage/storage_service.dart';
import '../presentation/controllers/login_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController(Get.find<StorageService>()));
  }
}
