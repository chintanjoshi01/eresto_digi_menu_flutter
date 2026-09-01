import 'package:get/get.dart';
import '../../../../core/storage/storage_service.dart';
import '../presentation/controllers/share_controller.dart';

class ShareBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShareController>(() => ShareController(Get.find<StorageService>()));
  }
}
