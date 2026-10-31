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

  /// Clears in-memory category lookup cache on logout
  static void clearCache() {
    _categoryNameToId.clear();
  }

  @override
  Map<String, int> get categoryNameToId => Map.unmodifiable(_categoryNameToId);

  ItemsRepositoryImpl(
    this._remoteDataSource,
    this._dbService,
    this._storageService,
  );

  // --------------------------------------------------------------------------
  // Private Isar Cache Helpers (Accept Non-Nullable Isar)
  // --------------------------------------------------------------------------

  static Future<List<MenuItemCollection>> _queryCachedItems(
    Isar isar, {
    String? category,
    String? search,
  }) async {
    final Isar db1 = isar;
    var query = db1.menuItemCollections.where();
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

  Future<void> _saveCategoriesToIsar(
    Isar isar,
    List<V6MenuCategory> categories,
  ) async {
    final Isar db1 = isar;
    final treasureUrl = _storageService.treasureUrl;
    final syncData = _storageService.cachedLoginSyncData;

    final existingItems = await db1.menuItemCollections.where().findAll();
    final existingMap = {for (final e in existingItems) e.remoteId: e};

    final recordsToSave = <MenuItemCollection>[];
    final seenIds = <int>{};

    for (final cat in categories) {
      final catName = cat.categoryName.trim();
      final catNameUpper = catName.toUpperCase();
      if (cat.itemCatId == -1 || catNameUpper == 'FSI') continue;
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
        final kitchenName = syncData?.getKitchenCategoryName(item.kitchenCatId);
        final salesName = syncData?.getSalesCategoryName(item.itemSalesCatId);
        final taxName = syncData?.getTaxTemplateName(item.taxTmplMastId);

        final dbRecord = item.toIsarCollection(
          categoryName: catName,
          treasureUrl: (item.baseUrl != null && item.baseUrl!.isNotEmpty)
              ? item.baseUrl
              : treasureUrl,
          kitchenCategoryName: kitchenName,
          salesCategoryName: salesName,
          taxTemplateName: taxName,
          existingRecord: existing,
        );

        recordsToSave.add(dbRecord);
      }
    }

    final idsToDelete = existingItems
        .where((e) => !seenIds.contains(e.remoteId))
        .map((e) => e.id)
        .toList();

    final Isar db2 = isar;
    await db2.writeTxn(() async {
      final Isar innerDb = db2;
      if (idsToDelete.isNotEmpty) {
        await innerDb.menuItemCollections.deleteAll(idsToDelete);
      }
      await innerDb.menuItemCollections.putAll(recordsToSave);
    });
  }

  static Future<String> _getItemCategoryFromIsar(Isar isar, int itemId) async {
    final Isar db1 = isar;
    final existing = await db1.menuItemCollections
        .filter()
        .remoteIdEqualTo(itemId)
        .findFirst();
    return existing?.itemGroup ?? '';
  }

  static Future<MenuItemCollection?> _getExistingRecordFromIsar(Isar isar, int itemId) async {
    final Isar db1 = isar;
    return await db1.menuItemCollections
        .filter()
        .remoteIdEqualTo(itemId)
        .findFirst();
  }

  static Future<void> _updateItemRecordInIsar(Isar isar, int itemId, ItemModel model) async {
    final Isar db1 = isar;
    final existing = await db1.menuItemCollections
        .filter()
        .remoteIdEqualTo(itemId)
        .findFirst();
    if (existing != null) {
      final rec = existing;
      final Isar db2 = isar;
      await db2.writeTxn(() async {
        final Isar innerDb = db2;
        rec.name = model.name;
        rec.shortCode = model.shortCode;
        rec.price = model.price;
        rec.isAvailable = model.isAvailable;
        rec.isFrequentlySold = model.isFrequentlySold;
        rec.vegType = model.vegType;
        rec.portion = model.portion;
        rec.calorificValue = model.calorificValue;
        rec.serviceTime = model.serviceTime;
        rec.ingredients = model.ingredients;
        rec.shortDescription = model.shortDescription;
        rec.itemGroup = model.itemGroup;
        rec.taxTemplate = model.taxTemplate;
        rec.kitchenCategory = model.kitchenCategory;
        rec.salesCategory = model.salesCategory;
        rec.dietaryTags = model.dietaryTags;
        rec.allergens = model.allergens;
        rec.variantsJson = model.variantsJson;
        rec.addonsJson = model.addonsJson;
        rec.specialInstructions = model.specialInstructions;
        if (model.imageUrl != null) rec.imageUrl = model.imageUrl;
        await innerDb.menuItemCollections.put(rec);
      });
    }
  }

  static Future<void> _saveItemToIsar(
    Isar isar,
    V6ApiMenuItem created,
    String catName,
    String treasureUrl,
  ) async {
    final Isar db1 = isar;
    final dbRecord = created.toIsarCollection(
      categoryName: catName,
      treasureUrl: treasureUrl,
    );
    await db1.writeTxn(() async {
      final Isar innerDb = db1;
      await innerDb.menuItemCollections.put(dbRecord);
    });
  }

  static Future<void> _deleteItemFromIsar(Isar isar, int id) async {
    final Isar db1 = isar;
    final existing = await db1.menuItemCollections.filter().remoteIdEqualTo(id).findFirst();
    if (existing != null) {
      final Isar db2 = isar;
      await db2.writeTxn(() async {
        final Isar innerDb = db2;
        await innerDb.menuItemCollections.delete(existing.id);
      });
    }
  }

  // --------------------------------------------------------------------------
  // Repository Interface Implementation
  // --------------------------------------------------------------------------

  @override
  Future<Either<ApiException, List<ItemModel>>> getItems({
    String? category,
    String? search,
    int? ptId,
    bool forceRefresh = false,
  }) async {
    // 1. OFFLINE-FIRST: Read from local Isar cache immediately if available
    if (!forceRefresh && _dbService.isReady) {
      try {
        final cachedList = await _queryCachedItems(_dbService.isar!, category: category, search: search);
        if (cachedList.isNotEmpty) {
          return Right(cachedList.map((e) => _mapToModel(e)).toList());
        }
      } catch (_) {}
    }

    // 2. Network Sync: Fetch from remote V6 endpoint
    try {
      final remoteCategories = await _remoteDataSource.getMenuCategories(
        restoId: _storageService.restoId > 0 ? _storageService.restoId : null,
        ptId: ptId,
      );

      if (remoteCategories.isNotEmpty) {
        if (_dbService.isReady) {
          try {
            await _saveCategoriesToIsar(_dbService.isar!, remoteCategories);
            final freshCached = await _queryCachedItems(_dbService.isar!, category: category, search: search);
            if (freshCached.isNotEmpty) {
              return Right(freshCached.map((e) => _mapToModel(e)).toList());
            }
          } catch (_) {
            // Fall through to direct in-memory mapping if Isar write/read fails
          }
        }

        // Direct in-memory mapping fallback if Isar is unavailable or cache query yielded empty
        final syncData = _storageService.cachedLoginSyncData;
        final remoteModels = <ItemModel>[];
        final seenIds = <int>{};
        for (final cat in remoteCategories) {
          final catName = cat.categoryName.trim();
          final catNameUpper = catName.toUpperCase();
          if (cat.itemCatId == -1 || catNameUpper == 'FSI') continue;
          if (cat.itemCatId > 0 && catNameUpper.isNotEmpty) {
            _categoryNameToId[catNameUpper] = cat.itemCatId;
          }
          for (final item in cat.items) {
            if (seenIds.contains(item.id)) continue;
            seenIds.add(item.id);
            if (item.itemCatId > 0 && catNameUpper.isNotEmpty) {
              _categoryNameToId[catNameUpper] = item.itemCatId;
            }
            final kitchenName = syncData?.getKitchenCategoryName(item.kitchenCatId);
            final salesName = syncData?.getSalesCategoryName(item.itemSalesCatId);
            final taxName = syncData?.getTaxTemplateName(item.taxTmplMastId);

            final model = item.toItemModel(
              categoryName: catName,
              treasureUrl: (item.baseUrl != null && item.baseUrl!.isNotEmpty)
                  ? item.baseUrl
                  : _storageService.treasureUrl,
              kitchenCategoryName: kitchenName,
              salesCategoryName: salesName,
              taxTemplateName: taxName,
            );
            remoteModels.add(model);
          }
        }
        return Right(remoteModels);
      }
    } catch (e) {
      if (_dbService.isReady) {
        try {
          final fallbackCached = await _queryCachedItems(_dbService.isar!, category: category, search: search);
          if (fallbackCached.isNotEmpty) {
            return Right(fallbackCached.map((e) => _mapToModel(e)).toList());
          }
        } catch (_) {}
      }
      return Left(e is ApiException ? e : ApiException(message: e.toString()));
    }

    if (_dbService.isReady) {
      try {
        final allCached = await _queryCachedItems(_dbService.isar!, category: category, search: search);
        if (allCached.isNotEmpty) {
          return Right(allCached.map((e) => _mapToModel(e)).toList());
        }
      } catch (_) {}
    }
    return const Right([]);
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

      if (catName.isEmpty && _dbService.isReady) {
        catName = await _getItemCategoryFromIsar(_dbService.isar!, itemId);
      }

      final syncData = _storageService.cachedLoginSyncData;
      final kitchenName = syncData?.getKitchenCategoryName(details.kitchenCatId);
      final salesName = syncData?.getSalesCategoryName(details.itemSalesCatId);
      final taxName = syncData?.getTaxTemplateName(details.taxTmplMastId);

      final model = details.toItemModel(
        categoryName: catName.isNotEmpty ? catName : 'GENERAL',
        treasureUrl: (details.baseUrl != null && details.baseUrl!.isNotEmpty)
            ? details.baseUrl
            : _storageService.treasureUrl,
        kitchenCategoryName: kitchenName,
        salesCategoryName: salesName,
        taxTemplateName: taxName,
      );

      if (_dbService.isReady) {
        await _updateItemRecordInIsar(_dbService.isar!, itemId, model);
      }

      return Right(model);
    } catch (e) {
      if (_dbService.isReady) {
        final existing = await _getExistingRecordFromIsar(_dbService.isar!, itemId);
        if (existing != null) {
          return Right(_mapToModel(existing));
        }
      }
      return Left(e is ApiException ? e : ApiException(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiException, void>> updateAvailability({
    required int id,
    required bool isAvailable,
  }) async {
    MenuItemCollection? existing;
    if (_dbService.isReady) {
      existing = await _getExistingRecordFromIsar(_dbService.isar!, id);
    }
    final previousVal = existing?.isAvailable ?? !isAvailable;

    // 1. Optimistic local update (0ms UI latency)
    if (_dbService.isReady && existing != null) {
      final isar = _dbService.isar!;
      final rec = existing;
      await isar.writeTxn(() async {
        final Isar innerDb = isar;
        rec.isAvailable = isAvailable;
        await innerDb.menuItemCollections.put(rec);
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
      if (_dbService.isReady && existing != null) {
        final isar = _dbService.isar!;
        final rec = existing;
        await isar.writeTxn(() async {
          final Isar innerDb = isar;
          rec.isAvailable = previousVal;
          await innerDb.menuItemCollections.put(rec);
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
    MenuItemCollection? existing;
    if (_dbService.isReady) {
      existing = await _getExistingRecordFromIsar(_dbService.isar!, id);
    }
    final previousVal = existing?.isFrequentlySold ?? !isFsi;

    // 1. Optimistic local update
    if (_dbService.isReady && existing != null) {
      final isar = _dbService.isar!;
      final rec = existing;
      await isar.writeTxn(() async {
        final Isar innerDb = isar;
        rec.isFrequentlySold = isFsi;
        await innerDb.menuItemCollections.put(rec);
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
      if (_dbService.isReady && existing != null) {
        final isar = _dbService.isar!;
        final rec = existing;
        await isar.writeTxn(() async {
          final Isar innerDb = isar;
          rec.isFrequentlySold = previousVal;
          await innerDb.menuItemCollections.put(rec);
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
    MenuItemCollection? existing;
    if (_dbService.isReady) {
      existing = await _getExistingRecordFromIsar(_dbService.isar!, id);
    }
    final previousVal = existing?.price ?? price;

    if (_dbService.isReady && existing != null) {
      final isar = _dbService.isar!;
      final rec = existing;
      await isar.writeTxn(() async {
        final Isar innerDb = isar;
        rec.price = price;
        await innerDb.menuItemCollections.put(rec);
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
      if (_dbService.isReady && existing != null) {
        final isar = _dbService.isar!;
        final rec = existing;
        await isar.writeTxn(() async {
          final Isar innerDb = isar;
          rec.price = previousVal;
          await innerDb.menuItemCollections.put(rec);
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
    try {
      await _remoteDataSource.updateItemFull(
        restoId: _storageService.restoId > 0 ? _storageService.restoId : null,
        itemId: id,
        data: data,
        itemImage: imageFile,
      );

      if (_dbService.isReady) {
        final isar = _dbService.isar!;
        final existing = await isar.menuItemCollections.filter().remoteIdEqualTo(id).findFirst();
        if (existing != null && _dbService.isReady) {
          final isarWrite = _dbService.isar!;
          final rec = existing;
          await isarWrite.writeTxn(() async {
            final Isar innerDb = isarWrite;
            if (data['item_name'] != null) rec.name = data['item_name'].toString();
            if (data['name'] != null) rec.name = data['name'].toString();
            if (data['item_price'] != null) {
              rec.price = double.tryParse(data['item_price'].toString()) ?? rec.price;
            } else if (data['price'] != null) {
              rec.price = double.tryParse(data['price'].toString()) ?? rec.price;
            }
            if (data['item_short_name'] != null) rec.shortCode = data['item_short_name'].toString();
            if (data['short_code'] != null) rec.shortCode = data['short_code'].toString();
            if (data['short_desc'] != null) rec.shortDescription = data['short_desc'].toString();
            if (data['short_description'] != null) rec.shortDescription = data['short_description'].toString();
            if (data['ingredients'] != null) rec.ingredients = data['ingredients'].toString();
            if (data['is_nonveg'] != null) {
              rec.vegType = (data['is_nonveg'] == 1 || data['is_nonveg'] == '1') ? 'non_veg' : 'veg';
            } else if (data['veg_type'] != null) {
              rec.vegType = (data['veg_type'] == 'non_veg' || data['veg_type'] == 'nv') ? 'non_veg' : 'veg';
            }
            if (data['is_available'] != null) {
              rec.isAvailable = data['is_available'] == true || data['is_available'] == 1;
            } else if (data['is_na'] != null) {
              rec.isAvailable = data['is_na'] == 0;
            }
            if (data['is_frequently_sold'] != null) {
              rec.isFrequentlySold = data['is_frequently_sold'] == true || data['is_frequently_sold'] == 1;
            } else if (data['is_fsi'] != null) {
              rec.isFrequentlySold = data['is_fsi'] == 1;
            }
            if (data.containsKey('qty') || data.containsKey('portion')) {
              final raw = (data['qty'] ?? data['portion'])?.toString().trim();
              rec.portion = (raw != null && raw.isNotEmpty) ? raw : null;
            }
            if (data['cal'] != null) rec.calorificValue = int.tryParse(data['cal'].toString());
            if (data['calorific_value'] != null) rec.calorificValue = int.tryParse(data['calorific_value'].toString());
            if (data['delivery_time'] != null) rec.serviceTime = int.tryParse(data['delivery_time'].toString());
            if (data['service_time'] != null) rec.serviceTime = int.tryParse(data['service_time'].toString());
            if (data['category_name'] != null) rec.itemGroup = data['category_name'].toString().toUpperCase();
            if (data['item_group'] != null) rec.itemGroup = data['item_group'].toString().toUpperCase();
            if (data['kitchen_category'] != null) rec.kitchenCategory = data['kitchen_category'].toString();
            if (data['sales_category'] != null) rec.salesCategory = data['sales_category'].toString();
            if (data['allergens'] != null) {
              rec.allergens = (data['allergens'] as List).map((e) => e.toString()).toList();
            } else if (data['aik'] != null) {
              rec.allergens = data['aik'].toString().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
            }
            if (data['dietary_tags'] != null) {
              rec.dietaryTags = (data['dietary_tags'] as List).map((e) => e.toString()).toList();
            } else if (data['item_att'] != null) {
              rec.dietaryTags = data['item_att'].toString().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
            }
            if (data['item_tax_tmpl_id'] != null || data['tax_tmpl_mast_id'] != null) {
              final taxId = int.tryParse((data['item_tax_tmpl_id'] ?? data['tax_tmpl_mast_id']).toString());
              if (taxId != null) {
                final taxName = _storageService.cachedLoginSyncData?.getTaxTemplateName(taxId);
                if (taxName != null) rec.taxTemplate = taxName;
              }
            } else if (data['tax_template'] != null && !data['tax_template'].toString().startsWith('[')) {
              rec.taxTemplate = data['tax_template'].toString();
            }
            if (data['vrnt_json'] != null) {
              rec.variantsJson = data['vrnt_json'].toString();
            } else if (data['aoi_json'] != null) {
              rec.addonsJson = data['aoi_json'].toString();
            }
            if (data['sp_inst'] != null) {
              try {
                final decoded = jsonDecode(data['sp_inst'].toString());
                if (decoded is List) {
                  rec.specialInstructions = decoded.map((e) => e.toString()).toList();
                }
              } catch (_) {
                rec.specialInstructions = data['sp_inst'].toString().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
              }
            }
            if (data['image_url'] != null) {
              rec.imageUrl = V6ApiMenuItem.resolveImageUrl(
                itemImage: data['image_url'].toString(),
                treasureUrl: _storageService.treasureUrl,
                restoId: _storageService.restoId,
              );
            }
            await innerDb.menuItemCollections.put(rec);
          });
          return Right(_mapToModel(rec));
        }
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
        treasureUrl: (details.baseUrl != null && details.baseUrl!.isNotEmpty)
            ? details.baseUrl
            : _storageService.treasureUrl,
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

      if (_dbService.isReady) {
        await _saveItemToIsar(_dbService.isar!, created, catName, _storageService.treasureUrl);
      }

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
    try {
      final result = await _remoteDataSource.deleteItem(
        restoId: _storageService.restoId > 0 ? _storageService.restoId : null,
        itemId: id,
        isForce: isForce,
      );

      if (result['status'] == 1 && _dbService.isReady) {
        await _deleteItemFromIsar(_dbService.isar!, id);
      }

      return Right(result);
    } catch (e) {
      return Left(e is ApiException ? e : ApiException(message: e.toString()));
    }
  }

  @override
  Future<List<String>> getCategories() async {
    if (!_dbService.isReady) {
      return _categoryNameToId.keys.toList();
    }
    final isar = _dbService.isar!;
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
