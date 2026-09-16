import 'package:get/get.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/storage/storage_service.dart';
import '../data/datasources/share_remote_datasource.dart';
import '../data/repositories/share_repository_impl.dart';
import '../domain/repositories/share_repository.dart';
import '../presentation/controllers/share_controller.dart';

class ShareBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShareRemoteDataSource>(
      () => ShareRemoteDataSourceImpl(Get.find<ApiClient>()),
    );
    Get.lazyPut<ShareRepository>(
      () => ShareRepositoryImpl(Get.find<ShareRemoteDataSource>()),
    );
    Get.lazyPut<ShareController>(
      () => ShareController(
        Get.find<ShareRepository>(),
        Get.find<StorageService>(),
      ),
    );
  }
}
