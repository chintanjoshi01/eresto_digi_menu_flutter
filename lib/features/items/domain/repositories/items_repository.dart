import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exception.dart';
import '../models/item_model.dart';

abstract class ItemsRepository {
  Future<Either<ApiException, List<ItemModel>>> getItems({
    String? category,
    String? search,
    bool forceRefresh = false,
  });
  Future<Either<ApiException, void>> updateAvailability({
    required int id,
    required bool isAvailable,
  });
  Future<Either<ApiException, ItemModel>> updateItem({
    required int id,
    required Map<String, dynamic> data,
  });
}
