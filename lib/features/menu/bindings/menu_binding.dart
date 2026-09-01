import 'package:get/get.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/storage/database_service.dart';
import '../data/datasources/menu_remote_datasource.dart';
import '../data/repositories/menu_repository_impl.dart';
import '../domain/repositories/menu_repository.dart';
import '../presentation/controllers/menu_theme_controller.dart';

class MenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenuRemoteDataSource>(() => MenuRemoteDataSourceImpl(Get.find<ApiClient>()));
    Get.lazyPut<MenuRepository>(() => MenuRepositoryImpl(Get.find<MenuRemoteDataSource>(), Get.find<DatabaseService>()));
    Get.lazyPut<MenuThemeController>(() => MenuThemeController(Get.find<MenuRepository>()));
  }
}
