import 'package:dartz/dartz.dart';
import 'package:isar/isar.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/storage/database_service.dart';
import '../../../../core/storage/menu_collections.dart';
import '../../domain/models/item_model.dart';
import '../../domain/repositories/items_repository.dart';
import '../datasources/items_remote_datasource.dart';

class ItemsRepositoryImpl implements ItemsRepository {
  final ItemsRemoteDataSource _remoteDataSource;
  final DatabaseService _dbService;

  ItemsRepositoryImpl(this._remoteDataSource, this._dbService);

  @override
  Future<Either<ApiException, List<ItemModel>>> getItems({
    String? category,
    String? search,
    bool forceRefresh = false,
  }) async {
    final isar = _dbService.isar;

    // 1. Read from Isar Cache first
    if (!forceRefresh) {
      var query = isar.menuItemCollections.where();
      List<MenuItemCollection> cachedList;
      if (search != null && search.isNotEmpty) {
        cachedList = await query.filter().nameContains(search, caseSensitive: false).findAll();
      } else {
        cachedList = await query.findAll();
      }
      
      if (category != null && category.isNotEmpty) {
        cachedList = cachedList.where((item) => item.itemGroup.toLowerCase() == category.toLowerCase()).toList();
      }

      if (cachedList.isNotEmpty) {
        final models = cachedList.map((dbObj) => _mapToModel(dbObj)).toList();
        return Right(models);
      }
    }

    // 2. Fetch fresh items from REST API
    try {
      final remoteItems = await _remoteDataSource.getItems(category: category, search: search);

      // Save to Isar cache
      await isar.writeTxn(() async {
        for (final item in remoteItems) {
          final existing = await isar.menuItemCollections.filter().remoteIdEqualTo(item.id).findFirst();
          final dbObj = existing ?? MenuItemCollection()..remoteId = item.id;
          
          dbObj.name = item.name;
          dbObj.shortCode = item.shortCode;
          dbObj.price = item.price;
          dbObj.isAvailable = item.isAvailable;
          dbObj.isFrequentlySold = item.isFrequentlySold;
          dbObj.vegType = item.vegType;
          dbObj.portion = item.portion;
          dbObj.calorificValue = item.calorificValue;
          dbObj.serviceTime = item.serviceTime;
          dbObj.ingredients = item.ingredients;
          dbObj.shortDescription = item.shortDescription;
          dbObj.itemGroup = item.itemGroup;
          dbObj.taxTemplate = item.taxTemplate;
          dbObj.kitchenCategory = item.kitchenCategory;
          dbObj.salesCategory = item.salesCategory;
          dbObj.dietaryTags = item.dietaryTags;
          dbObj.allergens = item.allergens;
          dbObj.imageUrl = item.imageUrl;

          await isar.menuItemCollections.put(dbObj);
        }
      });

      return Right(remoteItems);
    } catch (e) {
      // Offline fallback: Serve cache if API fails
      final allCached = await isar.menuItemCollections.where().findAll();
      if (allCached.isNotEmpty) {
        final models = allCached.map((dbObj) => _mapToModel(dbObj)).toList();
        return Right(models);
      }
      if (e is ApiException) return Left(e);
      return Left(ApiException(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiException, void>> updateAvailability({
    required int id,
    required bool isAvailable,
  }) async {
    final isar = _dbService.isar;
    try {
      await _remoteDataSource.updateAvailability(id: id, isAvailable: isAvailable);

      // Update local Isar cache
      final existing = await isar.menuItemCollections.filter().remoteIdEqualTo(id).findFirst();
      if (existing != null) {
        await isar.writeTxn(() async {
          existing.isAvailable = isAvailable;
          await isar.menuItemCollections.put(existing);
        });
      }
      return const Right(null);
    } catch (e) {
      if (e is ApiException) return Left(e);
      return Left(ApiException(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiException, ItemModel>> updateItem({
    required int id,
    required Map<String, dynamic> data,
  }) async {
    final isar = _dbService.isar;
    try {
      final updatedItem = await _remoteDataSource.updateItem(id: id, data: data);

      // Update local Isar cache
      final existing = await isar.menuItemCollections.filter().remoteIdEqualTo(id).findFirst();
      if (existing != null) {
        await isar.writeTxn(() async {
          existing.name = updatedItem.name;
          existing.price = updatedItem.price;
          existing.shortCode = updatedItem.shortCode;
          existing.isAvailable = updatedItem.isAvailable;
          existing.isFrequentlySold = updatedItem.isFrequentlySold;
          existing.portion = updatedItem.portion;
          existing.calorificValue = updatedItem.calorificValue;
          existing.serviceTime = updatedItem.serviceTime;
          existing.ingredients = updatedItem.ingredients;
          existing.shortDescription = updatedItem.shortDescription;
          existing.imageUrl = updatedItem.imageUrl;
          await isar.menuItemCollections.put(existing);
        });
      }
      return Right(updatedItem);
    } catch (e) {
      if (e is ApiException) return Left(e);
      return Left(ApiException(message: e.toString()));
    }
  }

  ItemModel _mapToModel(MenuItemCollection dbObj) {
    return ItemModel(
      id: dbObj.remoteId,
      name: dbObj.name,
      shortCode: dbObj.shortCode,
      price: dbObj.price,
      isAvailable: dbObj.isAvailable,
      isFrequentlySold: dbObj.isFrequentlySold,
      vegType: dbObj.vegType,
      portion: dbObj.portion,
      calorificValue: dbObj.calorificValue,
      serviceTime: dbObj.serviceTime,
      ingredients: dbObj.ingredients,
      shortDescription: dbObj.shortDescription,
      itemGroup: dbObj.itemGroup,
      taxTemplate: dbObj.taxTemplate,
      kitchenCategory: dbObj.kitchenCategory,
      salesCategory: dbObj.salesCategory,
      dietaryTags: dbObj.dietaryTags,
      allergens: dbObj.allergens,
      imageUrl: dbObj.imageUrl,
    );
  }
}
