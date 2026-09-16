import 'package:get/get.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/storage/database_service.dart';
import '../../../../core/storage/storage_service.dart';
import '../data/datasources/dashboard_remote_datasource.dart';
import '../data/dashboard_repository_impl.dart';
import '../domain/repositories/dashboard_repository.dart';
import '../presentation/controllers/menu_dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImpl(
        Get.find<ApiClient>(),
        Get.isRegistered<StorageService>() ? Get.find<StorageService>() : null,
      ),
    );
    Get.lazyPut<DashboardRepository>(
      () => DashboardRepositoryImpl(
        Get.find<DashboardRemoteDataSource>(),
        Get.find<DatabaseService>(),
      ),
    );
    Get.lazyPut<MenuDashboardController>(
      () => MenuDashboardController(Get.find<DashboardRepository>()),
    );
  }
}
