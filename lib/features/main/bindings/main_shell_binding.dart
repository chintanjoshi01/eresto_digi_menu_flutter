import 'package:get/get.dart';
import '../../dashboard/bindings/dashboard_binding.dart';
import '../../items/bindings/items_binding.dart';
import '../../menu/bindings/menu_binding.dart';
import '../../share/bindings/share_binding.dart';
import '../presentation/controllers/main_shell_controller.dart';

/// Enterprise Main Shell Binding lazily providing dependencies for all primary tabs.
class MainShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainShellController>(() => MainShellController());
    DashboardBinding().dependencies();
    ItemsBinding().dependencies();
    MenuBinding().dependencies();
    ShareBinding().dependencies();
  }
}
