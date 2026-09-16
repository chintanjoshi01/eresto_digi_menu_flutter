import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:isar/isar.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/storage/database_service.dart';
import '../../../../core/storage/menu_collections.dart';
import '../../../../core/storage/storage_service.dart';
import '../../domain/models/item_model.dart';
import '../../domain/models/v6_menu_items_response.dart';
import '../../domain/repositories/items_repository.dart';
import '../datasources/items_remote_datasource.dart';

class ItemsRepositoryImpl implements ItemsRepository {
  final ItemsRemoteDataSource _remoteDataSource;
  final DatabaseService _dbService;
  final StorageService _storageService;

  static final Map<String, int> _categoryNameToId = {};

  @override
  Map<String, int> get categoryNameToId => Map.unmodifiable(_categoryNameToId);

  ItemsRepositoryImpl(
    this._remoteDataSource,
    this._dbService,
    this._storageService,
  );

  @override
  Future<Either<ApiException, List<ItemModel>>> getItems({
    String? category,
    String? search,
    int? ptId,
    bool forceRefresh = false,
  }) async {
    final isar = _dbService.isar;

    // 1. OFFLINE-FIRST: Read from local Isar cache immediately
    if (!forceRefresh) {
      final cachedList = await _queryCachedItems(isar, category: category, search: search);
      if (cachedList.isNotEmpty) {
        return Right(cachedList.map((e) => _mapToModel(e)).toList());
      }
    }

    // 2. Network Sync: Fetch from remote V6 endpoint
    try {
      final remoteCategories = await _remoteDataSource.getMenuCategories(
        restoId: _storageService.restoId > 0 ? _storageService.restoId : null,
        ptId: ptId,
      );

      if (remoteCategories.isNotEmpty) {
        await _cacheCategoriesAndItems(isar, remoteCategories);
        final freshCached = await _queryCachedItems(isar, category: category, search: search);
        return Right(freshCached.map((e) => _mapToModel(e)).toList());
      }
    } catch (e) {
      // Remote failed: check if we have any cached records to serve
      final fallbackCached = await _queryCachedItems(isar, category: category, search: search);
      if (fallbackCached.isNotEmpty) {
        return Right(fallbackCached.map((e) => _mapToModel(e)).toList());
      }
      return Left(e is ApiException ? e : ApiException(message: e.toString()));
    }

    // Final fallback
    final allCached = await _queryCachedItems(isar, category: category, search: search);
    return Right(allCached.map((e) => _mapToModel(e)).toList());
  }

  @override
  Future<Either<ApiException, ItemModel>> getItemDetails(int itemId) async {
    try {
      final details = await _remoteDataSource.getItemDetails(
        restoId: _storageService.restoId > 0 ? _storageService.restoId : null,
        itemId: itemId,
      );

      String catName = '';
      if (details.itemCatId > 0) {
        for (final entry in _categoryNameToId.entries) {
          if (entry.value == details.itemCatId) {
            catName = entry.key;
            break;
          }
        }
      }

      if (catName.isEmpty) {
        final existing = await _dbService.isar.menuItemCollections
            .filter()
            .remoteIdEqualTo(itemId)
            .findFirst();
        catName = existing?.itemGroup ?? 'GENERAL';
      }

      final syncData = _storageService.cachedLoginSyncData;
      final kitchenName = syncData?.getKitchenCategoryName(details.kitchenCatId);
      final salesName = syncData?.getSalesCategoryName(details.itemSalesCatId);
      final taxName = syncData?.getTaxTemplateName(details.taxTmplMastId);

      final model = details.toItemModel(
        categoryName: catName.isNotEmpty ? catName : 'GENERAL',
        treasureUrl: _storageService.treasureUrl,
        kitchenCategoryName: kitchenName,
        salesCategoryName: salesName,
        taxTemplateName: taxName,
      );

      final isar = _dbService.isar;
      final existing = await isar.menuItemCollections
          .filter()
          .remoteIdEqualTo(itemId)
          .findFirst();
      if (existing != null) {
        await isar.writeTxn(() async {
          existing.name = model.name;
          existing.shortCode = model.shortCode;
          existing.price = model.price;
          existing.isAvailable = model.isAvailable;
          existing.isFrequentlySold = model.isFrequentlySold;
          existing.vegType = model.vegType;
          existing.portion = model.portion;
          existing.calorificValue = model.calorificValue;
          existing.serviceTime = model.serviceTime;
          existing.ingredients = model.ingredients;
          existing.shortDescription = model.shortDescription;
          existing.itemGroup = model.itemGroup;
          existing.taxTemplate = model.taxTemplate;
          existing.kitchenCategory = model.kitchenCategory;
          existing.salesCategory = model.salesCategory;
          existing.dietaryTags = model.dietaryTags;
          existing.allergens = model.allergens;
          existing.variantsJson = model.variantsJson;
          existing.addonsJson = model.addonsJson;
          existing.specialInstructions = model.specialInstructions;
          if (model.imageUrl != null) existing.imageUrl = model.imageUrl;
          await isar.menuItemCollections.put(existing);
        });
      }

      return Right(model);
    } catch (e) {
      final existing = await _dbService.isar.menuItemCollections
          .filter()
          .remoteIdEqualTo(itemId)
          .findFirst();
      if (existing != null) {
        return Right(_mapToModel(existing));
      }
      return Left(e is ApiException ? e : ApiException(message: e.toString()));
    }
  }

  Future<List<MenuItemCollection>> _queryCachedItems(
    Isar isar, {
    String? category,
    String? search,
  }) async {
    var query = isar.menuItemCollections.where();
    List<MenuItemCollection> list;
    if (search != null && search.trim().isNotEmpty) {
      list = await query.filter().nameContains(search.trim(), caseSensitive: false).findAll();
    } else {
      list = await query.findAll();
    }

    if (category != null && category.trim().isNotEmpty) {
      list = list.where((item) => item.itemGroup.toUpperCase() == category.trim().toUpperCase()).toList();
    }

    return list;
  }

  Future<void> _cacheCategoriesAndItems(
    Isar isar,
    List<V6MenuCategory> categories,
  ) async {
    final treasureUrl = _storageService.treasureUrl;
    final syncData = _storageService.cachedLoginSyncData;

    // 1. Fetch all existing records in ONE fast query before opening writeTxn (prevents Isar worker deadlock)
    final existingItems = await isar.menuItemCollections.where().findAll();
    final existingMap = {for (final e in existingItems) e.remoteId: e};

    // 2. Prepare all records in memory with duplicate prevention
    final recordsToSave = <MenuItemCollection>[];
    final seenIds = <int>{};

    for (final cat in categories) {
      final catName = cat.categoryName.trim();
      final catNameUpper = catName.toUpperCase();
      // Exclude virtual FSI category (-1) from storing as separate category
      if (cat.itemCatId == -1 || catNameUpper == 'FSI') {
        continue;
      }
      if (cat.itemCatId > 0 && catNameUpper.isNotEmpty) {
        _categoryNameToId[catNameUpper] = cat.itemCatId;
      }

      for (final item in cat.items) {
        if (seenIds.contains(item.id)) continue;
        seenIds.add(item.id);

        if (item.itemCatId > 0 && catNameUpper.isNotEmpty) {
          _categoryNameToId[catNameUpper] = item.itemCatId;
        }

        final existing = existingMap[item.id];

        // Resolve kitchen, sales categories, and tax template from cached login sync data
        final kitchenName = syncData?.getKitchenCategoryName(item.kitchenCatId);
        final salesName = syncData?.getSalesCategoryName(item.itemSalesCatId);
        final taxName = syncData?.getTaxTemplateName(item.taxTmplMastId);

        final dbRecord = item.toIsarCollection(
          categoryName: catName,
          treasureUrl: treasureUrl,
          kitchenCategoryName: kitchenName,
          salesCategoryName: salesName,
          taxTemplateName: taxName,
          existingRecord: existing,
        );

        recordsToSave.add(dbRecord);
      }
    }

    // Identify stale / orphaned records in local Isar that no longer exist in server menu
    final idsToDelete = existingItems
        .where((e) => !seenIds.contains(e.remoteId))
        .map((e) => e.id)
        .toList();

    // 3. Batch write all records in ONE atomic transaction
    await isar.writeTxn(() async {
      if (idsToDelete.isNotEmpty) {
        await isar.menuItemCollections.deleteAll(idsToDelete);
      }
      await isar.menuItemCollections.putAll(recordsToSave);
    });
  }



  @override
  Future<Either<ApiException, void>> updateAvailability({
    required int id,
    required bool isAvailable,
  }) async {
    final isar = _dbService.isar;
    final existing = await isar.menuItemCollections.filter().remoteIdEqualTo(id).findFirst();
    final previousVal = existing?.isAvailable ?? !isAvailable;

    // 1. Optimistic local update (0ms UI latency)
    if (existing != null) {
      await isar.writeTxn(() async {
        existing.isAvailable = isAvailable;
        await isar.menuItemCollections.put(existing);
      });
    }

    // 2. Dispatch V6 remote call in background
    try {
      await _remoteDataSource.updateQuick(
        restoId: _storageService.restoId > 0 ? _storageService.restoId : null,
        itemId: id,
        isNa: isAvailable ? 0 : 1,
      );
      return const Right(null);
    } catch (e) {
      // 3. Rollback on failure
      if (existing != null) {
        await isar.writeTxn(() async {
          existing.isAvailable = previousVal;
          await isar.menuItemCollections.put(existing);
        });
      }
      return Left(e is ApiException ? e : ApiException(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiException, void>> updateFsi({
    required int id,
    required bool isFsi,
  }) async {
    final isar = _dbService.isar;
    final existing = await isar.menuItemCollections.filter().remoteIdEqualTo(id).findFirst();
    final previousVal = existing?.isFrequentlySold ?? !isFsi;

    // 1. Optimistic local update
    if (existing != null) {
      await isar.writeTxn(() async {
        existing.isFrequentlySold = isFsi;
        await isar.menuItemCollections.put(existing);
      });
    }

    // 2. Remote call
    try {
      await _remoteDataSource.updateQuick(
        restoId: _storageService.restoId > 0 ? _storageService.restoId : null,
        itemId: id,
        isFsi: isFsi ? 1 : 0,
      );
      return const Right(null);
    } catch (e) {
      // 3. Rollback on failure
      if (existing != null) {
        await isar.writeTxn(() async {
          existing.isFrequentlySold = previousVal;
          await isar.menuItemCollections.put(existing);
        });
      }
      return Left(e is ApiException ? e : ApiException(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiException, void>> updateQuickPrice({
    required int id,
    required double price,
  }) async {
    final isar = _dbService.isar;
    final existing = await isar.menuItemCollections.filter().remoteIdEqualTo(id).findFirst();
    final previousVal = existing?.price ?? price;

    if (existing != null) {
      await isar.writeTxn(() async {
        existing.price = price;
        await isar.menuItemCollections.put(existing);
      });
    }

    try {
      await _remoteDataSource.updateQuick(
        restoId: _storageService.restoId > 0 ? _storageService.restoId : null,
        itemId: id,
        itemPrice: price.toStringAsFixed(2),
      );
      return const Right(null);
    } catch (e) {
      if (existing != null) {
        await isar.writeTxn(() async {
          existing.price = previousVal;
          await isar.menuItemCollections.put(existing);
        });
      }
      return Left(e is ApiException ? e : ApiException(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiException, ItemModel>> updateItem({
    required int id,
    required Map<String, dynamic> data,
    File? imageFile,
  }) async {
    final isar = _dbService.isar;
    try {
      await _remoteDataSource.updateItemFull(
        restoId: _storageService.restoId > 0 ? _storageService.restoId : null,
        itemId: id,
        data: data,
        itemImage: imageFile,
      );

      final existing = await isar.menuItemCollections.filter().remoteIdEqualTo(id).findFirst();
      if (existing != null) {
        await isar.writeTxn(() async {
          if (data['item_name'] != null) existing.name = data['item_name'].toString();
          if (data['name'] != null) existing.name = data['name'].toString();
          if (data['item_price'] != null) {
            existing.price = double.tryParse(data['item_price'].toString()) ?? existing.price;
          } else if (data['price'] != null) {
            existing.price = double.tryParse(data['price'].toString()) ?? existing.price;
          }
          if (data['item_short_name'] != null) existing.shortCode = data['item_short_name'].toString();
          if (data['short_code'] != null) existing.shortCode = data['short_code'].toString();
          if (data['short_desc'] != null) existing.shortDescription = data['short_desc'].toString();
          if (data['short_description'] != null) existing.shortDescription = data['short_description'].toString();
          if (data['ingredients'] != null) existing.ingredients = data['ingredients'].toString();
          if (data['is_nonveg'] != null) {
            existing.vegType = (data['is_nonveg'] == 1 || data['is_nonveg'] == '1') ? 'non_veg' : 'veg';
          } else if (data['veg_type'] != null) {
            existing.vegType = (data['veg_type'] == 'non_veg' || data['veg_type'] == 'nv') ? 'non_veg' : 'veg';
          }
          if (data['is_available'] != null) {
            existing.isAvailable = data['is_available'] == true || data['is_available'] == 1;
          } else if (data['is_na'] != null) {
            existing.isAvailable = data['is_na'] == 0;
          }
          if (data['is_frequently_sold'] != null) {
            existing.isFrequentlySold = data['is_frequently_sold'] == true || data['is_frequently_sold'] == 1;
          } else if (data['is_fsi'] != null) {
            existing.isFrequentlySold = data['is_fsi'] == 1;
          }
          if (data['portion'] != null) existing.portion = data['portion'].toString();
          if (data['cal'] != null) existing.calorificValue = int.tryParse(data['cal'].toString());
          if (data['calorific_value'] != null) existing.calorificValue = int.tryParse(data['calorific_value'].toString());
          if (data['delivery_time'] != null) existing.serviceTime = int.tryParse(data['delivery_time'].toString());
          if (data['service_time'] != null) existing.serviceTime = int.tryParse(data['service_time'].toString());
          if (data['category_name'] != null) existing.itemGroup = data['category_name'].toString().toUpperCase();
          if (data['item_group'] != null) existing.itemGroup = data['item_group'].toString().toUpperCase();
          if (data['kitchen_category'] != null) existing.kitchenCategory = data['kitchen_category'].toString();
          if (data['sales_category'] != null) existing.salesCategory = data['sales_category'].toString();
          if (data['allergens'] != null) {
            existing.allergens = (data['allergens'] as List).map((e) => e.toString()).toList();
          } else if (data['aik'] != null) {
            existing.allergens = data['aik'].toString().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
          }
          if (data['dietary_tags'] != null) {
            existing.dietaryTags = (data['dietary_tags'] as List).map((e) => e.toString()).toList();
          } else if (data['item_att'] != null) {
            existing.dietaryTags = data['item_att'].toString().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
          }
          if (data['item_tax_tmpl_id'] != null || data['tax_tmpl_mast_id'] != null) {
            final taxId = int.tryParse((data['item_tax_tmpl_id'] ?? data['tax_tmpl_mast_id']).toString());
            if (taxId != null) {
              final taxName = _storageService.cachedLoginSyncData?.getTaxTemplateName(taxId);
              if (taxName != null) existing.taxTemplate = taxName;
            }
          } else if (data['tax_template'] != null && !data['tax_template'].toString().startsWith('[')) {
            existing.taxTemplate = data['tax_template'].toString();
          }
          if (data['vrnt_json'] != null) {
            existing.variantsJson = data['vrnt_json'].toString();
          } else if (data['vrnt'] != null) {
            existing.variantsJson = data['vrnt'].toString();
          }
          if (data['aoi_json'] != null) {
            existing.addonsJson = data['aoi_json'].toString();
          } else if (data['aoi'] != null) {
            existing.addonsJson = data['aoi'].toString();
          }
          if (data['sp_inst'] != null) {
            try {
              final decoded = jsonDecode(data['sp_inst'].toString());
              if (decoded is List) {
                existing.specialInstructions = decoded.map((e) => e.toString()).toList();
              }
            } catch (_) {
              existing.specialInstructions = data['sp_inst'].toString().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
            }
          }
          if (data['image_url'] != null) {
            existing.imageUrl = V6ApiMenuItem.resolveImageUrl(
              itemImage: data['image_url'].toString(),
              treasureUrl: _storageService.treasureUrl,
              restoId: _storageService.restoId,
            );
          }
          await isar.menuItemCollections.put(existing);
        });
        return Right(_mapToModel(existing));
      }

      // Re-fetch item details from V6 API
      final details = await _remoteDataSource.getItemDetails(
        restoId: _storageService.restoId > 0 ? _storageService.restoId : null,
        itemId: id,
      );
      final syncData = _storageService.cachedLoginSyncData;
      final kitchenName = syncData?.getKitchenCategoryName(details.kitchenCatId);
      final salesName = syncData?.getSalesCategoryName(details.itemSalesCatId);
      final taxName = syncData?.getTaxTemplateName(details.taxTmplMastId);

      final model = details.toItemModel(
        categoryName: data['category_name']?.toString() ?? 'STARTERS',
        treasureUrl: _storageService.treasureUrl,
        kitchenCategoryName: kitchenName,
        salesCategoryName: salesName,
        taxTemplateName: taxName,
      );
      return Right(model);
    } catch (e) {
      return Left(e is ApiException ? e : ApiException(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiException, ItemModel>> createItem({
    required Map<String, dynamic> data,
    File? imageFile,
  }) async {
    final isar = _dbService.isar;
    try {
      final created = await _remoteDataSource.createItem(
        restoId: _storageService.restoId > 0 ? _storageService.restoId : null,
        data: data,
        itemImage: imageFile,
      );

      final catName = data['category_name']?.toString() ?? 'MAIN';
      final model = created.toItemModel(
        categoryName: catName,
        treasureUrl: _storageService.treasureUrl,
      );

      // Cache into local Isar DB
      final dbRecord = created.toIsarCollection(
        categoryName: catName,
        treasureUrl: _storageService.treasureUrl,
      );
      await isar.writeTxn(() async {
        await isar.menuItemCollections.put(dbRecord);
      });

      return Right(model);
    } catch (e) {
      return Left(e is ApiException ? e : ApiException(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> deleteItem({
    required int id,
    int isForce = 0,
  }) async {
    final isar = _dbService.isar;
    try {
      final result = await _remoteDataSource.deleteItem(
        restoId: _storageService.restoId > 0 ? _storageService.restoId : null,
        itemId: id,
        isForce: isForce,
      );

      // If deletion succeeded on server (status == 1), remove from local Isar cache
      if (result['status'] == 1) {
        final existing = await isar.menuItemCollections.filter().remoteIdEqualTo(id).findFirst();
        if (existing != null) {
          await isar.writeTxn(() async {
            await isar.menuItemCollections.delete(existing.id);
          });
        }
      }

      return Right(result);
    } catch (e) {
      return Left(e is ApiException ? e : ApiException(message: e.toString()));
    }
  }

  @override
  Future<List<String>> getCategories() async {
    final isar = _dbService.isar;
    final all = await isar.menuItemCollections.where().findAll();
    final set = <String>{};
    for (final item in all) {
      if (item.itemGroup.isNotEmpty) {
        set.add(item.itemGroup.toUpperCase());
      }
    }
    return set.toList();
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
      imageUrl: V6ApiMenuItem.resolveImageUrl(
        itemImage: dbObj.imageUrl,
        treasureUrl: _storageService.treasureUrl,
        restoId: _storageService.restoId,
      ),
      variantsJson: dbObj.variantsJson,
      addonsJson: dbObj.addonsJson,
      specialInstructions: dbObj.specialInstructions,
    );
  }
}
