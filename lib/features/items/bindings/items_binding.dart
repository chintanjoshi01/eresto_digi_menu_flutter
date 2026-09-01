import 'package:get/get.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/storage/database_service.dart';
import '../data/datasources/items_remote_datasource.dart';
import '../data/repositories/items_repository_impl.dart';
import '../domain/repositories/items_repository.dart';
import '../presentation/controllers/items_controller.dart';

class ItemsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ItemsRemoteDataSource>(() => ItemsRemoteDataSourceImpl(Get.find<ApiClient>()));
    Get.lazyPut<ItemsRepository>(() => ItemsRepositoryImpl(Get.find<ItemsRemoteDataSource>(), Get.find<DatabaseService>()));
    Get.lazyPut<ItemsController>(() => ItemsController(Get.find<ItemsRepository>()));
  }
}
