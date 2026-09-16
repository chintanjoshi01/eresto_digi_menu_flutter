import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exception.dart';
import '../models/item_model.dart';

abstract class ItemsRepository {
  /// Offline-First: returns cached Isar items immediately, syncs with V6 API in background
  Future<Either<ApiException, List<ItemModel>>> getItems({
    String? category,
    String? search,
    int? ptId,
    bool forceRefresh = false,
  });

  /// Fetch single item details from V6 API
  Future<Either<ApiException, ItemModel>> getItemDetails(int itemId);

  /// Optimistic quick toggle for stock availability (is_na)
  Future<Either<ApiException, void>> updateAvailability({
    required int id,
    required bool isAvailable,
  });

  /// Optimistic quick toggle for Frequently Sold Item (is_fsi)
  Future<Either<ApiException, void>> updateFsi({
    required int id,
    required bool isFsi,
  });

  /// Optimistic quick price override
  Future<Either<ApiException, void>> updateQuickPrice({
    required int id,
    required double price,
  });

  /// Full item update (optionally with new image file)
  Future<Either<ApiException, ItemModel>> updateItem({
    required int id,
    required Map<String, dynamic> data,
    File? imageFile,
  });

  /// Create new item
  Future<Either<ApiException, ItemModel>> createItem({
    required Map<String, dynamic> data,
    File? imageFile,
  });

  /// Delete item with template usage protection check
  Future<Either<ApiException, Map<String, dynamic>>> deleteItem({
    required int id,
    int isForce = 0,
  });

  /// Read distinct categories cached locally
  Future<List<String>> getCategories();

  /// Mapping from category name (uppercase) to server item_cat_id
  Map<String, int> get categoryNameToId;
}
