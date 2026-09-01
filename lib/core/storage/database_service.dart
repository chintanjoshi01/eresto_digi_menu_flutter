import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'menu_collections.dart';

class DatabaseService extends GetxService {
  late final Isar isar;

  Future<DatabaseService> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [
        MenuItemCollectionSchema,
        MenuTemplateCollectionSchema,
        MenuSessionCollectionSchema,
        DashboardAnalyticsCollectionSchema,
      ],
      directory: dir.path,
    );
    return this;
  }
}
