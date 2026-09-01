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

    // 2. Fetch fresh items from REST API or fallback to prototype mock data
    try {
      final remoteItems = await _remoteDataSource.getItems(category: category, search: search);
      if (remoteItems.isNotEmpty) {
        await _cacheItems(isar, remoteItems);
        return Right(remoteItems);
      }
    } catch (_) {
      // API un-reachable: fallback to prototype mock data
    }

    final mockItems = _getPrototypeMockItems();
    await _cacheItems(isar, mockItems);

    var filtered = mockItems;
    if (category != null && category.isNotEmpty) {
      filtered = filtered.where((e) => e.itemGroup.toLowerCase() == category.toLowerCase()).toList();
    }
    if (search != null && search.isNotEmpty) {
      filtered = filtered.where((e) => e.name.toLowerCase().contains(search.toLowerCase())).toList();
    }

    return Right(filtered);
  }

  Future<void> _cacheItems(Isar isar, List<ItemModel> items) async {
    await isar.writeTxn(() async {
      for (final item in items) {
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
  }

  @override
  Future<Either<ApiException, void>> updateAvailability({
    required int id,
    required bool isAvailable,
  }) async {
    final isar = _dbService.isar;
    try {
      await _remoteDataSource.updateAvailability(id: id, isAvailable: isAvailable);

      final existing = await isar.menuItemCollections.filter().remoteIdEqualTo(id).findFirst();
      if (existing != null) {
        await isar.writeTxn(() async {
          existing.isAvailable = isAvailable;
          await isar.menuItemCollections.put(existing);
        });
      }
      return const Right(null);
    } catch (_) {
      // Local fallback toggle
      final existing = await isar.menuItemCollections.filter().remoteIdEqualTo(id).findFirst();
      if (existing != null) {
        await isar.writeTxn(() async {
          existing.isAvailable = isAvailable;
          await isar.menuItemCollections.put(existing);
        });
      }
      return const Right(null);
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
      taxTemplate: dbObj.taxTemplate ?? "GST 5%",
      kitchenCategory: dbObj.kitchenCategory,
      salesCategory: dbObj.salesCategory,
      dietaryTags: dbObj.dietaryTags,
      allergens: dbObj.allergens,
      imageUrl: dbObj.imageUrl,
    );
  }

  List<ItemModel> _getPrototypeMockItems() {
    return [
      const ItemModel(
        id: 1,
        name: "Go Green",
        shortCode: "GG01",
        price: 325.00,
        isAvailable: true,
        isFrequentlySold: true,
        vegType: "Veg",
        portion: "300 ml",
        itemGroup: "Mocktails",
        taxTemplate: "GST 5%",
      ),
      const ItemModel(
        id: 2,
        name: "Aqua Marine",
        shortCode: "AM02",
        price: 345.00,
        isAvailable: true,
        isFrequentlySold: false,
        vegType: "Veg",
        portion: "300 ml",
        itemGroup: "Mocktails",
        taxTemplate: "GST 5%",
      ),
      const ItemModel(
        id: 3,
        name: "Pink Panther",
        shortCode: "PP03",
        price: 295.00,
        isAvailable: false,
        isFrequentlySold: true,
        vegType: "Veg",
        portion: "300 ml",
        itemGroup: "Mocktails",
        taxTemplate: "GST 5%",
      ),
      const ItemModel(
        id: 4,
        name: "Sunrise Splash",
        shortCode: "SS04",
        price: 280.00,
        isAvailable: true,
        isFrequentlySold: false,
        vegType: "Veg",
        portion: "300 ml",
        itemGroup: "Mocktails",
        taxTemplate: "GST 5%",
      ),
      const ItemModel(
        id: 5,
        name: "Crispy Corn",
        shortCode: "CC05",
        price: 260.00,
        isAvailable: true,
        isFrequentlySold: true,
        vegType: "Veg",
        portion: "Per Plate",
        itemGroup: "Starters",
        taxTemplate: "GST 5%",
      ),
      const ItemModel(
        id: 6,
        name: "Paneer Tikka",
        shortCode: "PT06",
        price: 340.00,
        isAvailable: true,
        isFrequentlySold: true,
        vegType: "Veg",
        portion: "8 Pcs",
        itemGroup: "Starters",
        taxTemplate: "GST 5%",
      ),
      const ItemModel(
        id: 7,
        name: "Chicken Wings",
        shortCode: "CW07",
        price: 380.00,
        isAvailable: true,
        isFrequentlySold: false,
        vegType: "Non-Veg",
        portion: "6 Pcs",
        itemGroup: "Starters",
        taxTemplate: "GST 5%",
      ),
      const ItemModel(
        id: 8,
        name: "Dal Makhani",
        shortCode: "DM08",
        price: 320.00,
        isAvailable: true,
        isFrequentlySold: true,
        vegType: "Veg",
        portion: "Per Bowl",
        itemGroup: "Main Course",
        taxTemplate: "GST 5%",
      ),
    ];
  }
}
