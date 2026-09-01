import 'package:get/get.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/storage/database_service.dart';
import '../data/dashboard_repository_impl.dart';
import '../domain/repositories/dashboard_repository.dart';
import '../presentation/controllers/menu_dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardRepository>(() => DashboardRepositoryImpl(Get.find<ApiClient>(), Get.find<DatabaseService>()));
    Get.lazyPut<MenuDashboardController>(() => MenuDashboardController(Get.find<DashboardRepository>()));
  }
}
