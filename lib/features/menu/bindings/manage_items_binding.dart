import 'package:get/get.dart';
import '../presentation/controllers/manage_items_controller.dart';

class ManageItemsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageItemsController>(() => ManageItemsController());
  }
}
