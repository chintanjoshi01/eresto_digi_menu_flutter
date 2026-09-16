import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/api/endpoints.dart';
import '../../../../core/storage/storage_service.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import '../../domain/models/v6_menu_items_response.dart';

abstract class ItemsRemoteDataSource {
  /// Fetch categorized menu items with dynamic price template override (v6)
  Future<List<V6MenuCategory>> getMenuCategories({int? restoId, int? ptId});

  /// Fetch single item details (v6)
  Future<V6ApiMenuItem> getItemDetails({int? restoId, required int itemId});

  /// Quick toggle for availability (is_na), FSI (is_fsi), or instant price (v6)
  Future<void> updateQuick({
    int? restoId,
    required int itemId,
    int? isNa,
    int? isFsi,
    String? itemPrice,
  });

  /// Update item image or delete existing (v6)
  Future<String?> updateImage({
    int? restoId,
    required int itemId,
    required int imageChange, // 1 = upload new, 2 = remove existing
    File? itemImage,
  });

  /// Full update of menu item (v6)
  Future<void> updateItemFull({
    int? restoId,
    required int itemId,
    required Map<String, dynamic> data,
    File? itemImage,
  });

  /// Create new menu item (v6)
  Future<V6ApiMenuItem> createItem({
    int? restoId,
    required Map<String, dynamic> data,
    File? itemImage,
  });

  /// Delete menu item with template protection (v6)
  Future<Map<String, dynamic>> deleteItem({
    int? restoId,
    required int itemId,
    int isForce = 0,
  });

  /// Legacy helper for availability toggle
  Future<void> updateAvailability({required int id, required bool isAvailable});
}

class ItemsRemoteDataSourceImpl implements ItemsRemoteDataSource {
  final ApiClient _apiClient;

  ItemsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<V6MenuCategory>> getMenuCategories({int? restoId, int? ptId}) async {
    try {
      final body = <String, dynamic>{
        'pt_id': ptId ?? 0,
      };
      if (restoId != null && restoId > 0) {
        body['resto_id'] = restoId;
      }

      final response = await _apiClient.dio.post(
        Endpoints.v6MenuItems,
        data: body,
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final parsed = V6MenuItemsResponse.fromJson(responseData);
        if (parsed.isSuccess) {
          if (parsed.baseUrl != null && parsed.baseUrl!.isNotEmpty) {
            if (Get.isRegistered<StorageService>()) {
              await Get.find<StorageService>().setTreasureUrl(parsed.baseUrl!);
            }
          }
          return parsed.data;
        } else {
          throw ApiException(
            message: parsed.message.isNotEmpty
                ? parsed.message
                : 'Failed to retrieve menu items',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ApiException(
          message: 'Invalid response format from menu items API',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
    }
  }

  @override
  Future<V6ApiMenuItem> getItemDetails({int? restoId, required int itemId}) async {
    try {
      final body = <String, dynamic>{
        'item_id': itemId,
      };
      if (restoId != null && restoId > 0) {
        body['resto_id'] = restoId;
      }

      final response = await _apiClient.dio.post(
        Endpoints.v6ItemDetails,
        data: body,
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 1) {
        final rawData = responseData['data'];
        if (rawData is Map<String, dynamic>) {
          final itemMap = (rawData['item'] is Map<String, dynamic>)
              ? rawData['item'] as Map<String, dynamic>
              : rawData;
          final imgBase = (rawData['img_base'] ??
                  rawData['base_url'] ??
                  rawData['image_base'] ??
                  itemMap['img_base'] ??
                  itemMap['base_url'] ??
                  responseData['img_base'] ??
                  responseData['base_url'])
              ?.toString();
          if (imgBase != null && imgBase.isNotEmpty) {
            if (Get.isRegistered<StorageService>()) {
              await Get.find<StorageService>().setTreasureUrl(imgBase);
            }
          }
          final effectiveImgBase = (imgBase != null && imgBase.isNotEmpty)
              ? imgBase
              : (Get.isRegistered<StorageService>() ? Get.find<StorageService>().treasureUrl : null);
          return V6ApiMenuItem.fromJson(itemMap, fallbackBaseUrl: effectiveImgBase);
        }
      }
      throw ApiException(
        message: (responseData is Map<String, dynamic> ? responseData['message'] : null) ??
            'Failed to retrieve item details',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
    }
  }

  @override
  Future<void> updateQuick({
    int? restoId,
    required int itemId,
    int? isNa,
    int? isFsi,
    String? itemPrice,
  }) async {
    try {
      final body = <String, dynamic>{
        'item_id': itemId,
      };
      if (restoId != null && restoId > 0) body['resto_id'] = restoId;
      if (isNa != null) body['is_na'] = isNa;
      if (isFsi != null) body['is_fsi'] = isFsi;
      if (itemPrice != null && itemPrice.isNotEmpty) body['item_price'] = itemPrice;

      final response = await _apiClient.dio.post(
        Endpoints.v6ItemUpdateQuick,
        data: body,
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 1) {
        return;
      } else {
        throw ApiException(
          message: responseData['message'] ?? 'Failed to quickly update item',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
    }
  }

  @override
  Future<void> updateAvailability({required int id, required bool isAvailable}) async {
    // Forward to V6 quick update: is_na = 0 (available), is_na = 1 (hidden)
    await updateQuick(
      itemId: id,
      isNa: isAvailable ? 0 : 1,
    );
  }

  @override
  Future<String?> updateImage({
    int? restoId,
    required int itemId,
    required int imageChange,
    File? itemImage,
  }) async {
    try {
      dynamic payload;
      if (imageChange == 1 && itemImage != null) {
        final fileName = itemImage.path.split(Platform.pathSeparator).last;
        payload = FormData.fromMap({
          'item_id': itemId,
          'image_change': 1,
          if (restoId != null && restoId > 0) 'resto_id': restoId,
          'item_image': await MultipartFile.fromFile(itemImage.path, filename: fileName),
        });
      } else {
        payload = {
          'item_id': itemId,
          'image_change': imageChange,
          if (restoId != null && restoId > 0) 'resto_id': restoId,
        };
      }

      final response = await _apiClient.dio.post(
        Endpoints.v6ItemUpdateImage,
        data: payload,
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 1) {
        return responseData['data']?['item_image']?.toString();
      } else {
        throw ApiException(
          message: responseData['message'] ?? 'Failed to update item image',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
    }
  }

  @override
  Future<void> updateItemFull({
    int? restoId,
    required int itemId,
    required Map<String, dynamic> data,
    File? itemImage,
  }) async {
    try {
      dynamic payload;
      final mapData = Map<String, dynamic>.from(data);
      mapData['item_id'] = itemId;
      if (restoId != null && restoId > 0) mapData['resto_id'] = restoId;

      // Standardize tax template parameter to V6 specification: item_tax_tmpl_id
      if (mapData.containsKey('tax_tmpl_mast_id') && !mapData.containsKey('item_tax_tmpl_id')) {
        mapData['item_tax_tmpl_id'] = mapData.remove('tax_tmpl_mast_id');
      }

      if (itemImage != null) {
        final fileName = itemImage.path.split(Platform.pathSeparator).last;
        mapData['item_image'] = await MultipartFile.fromFile(itemImage.path, filename: fileName);
        mapData['image_change'] ??= 1;
        payload = FormData.fromMap(mapData);
      } else {
        payload = mapData;
      }

      final response = await _apiClient.dio.post(
        Endpoints.v6ItemUpdate,
        data: payload,
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 1) {
        return;
      } else {
        throw ApiException(
          message: responseData['message'] ?? 'Failed to update item',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
    }
  }

  @override
  Future<V6ApiMenuItem> createItem({
    int? restoId,
    required Map<String, dynamic> data,
    File? itemImage,
  }) async {
    try {
      dynamic payload;
      final mapData = Map<String, dynamic>.from(data);
      if (restoId != null && restoId > 0) mapData['resto_id'] = restoId;

      // Default item_tax_tmpl_id to 1 as per V6 spec
      if (mapData.containsKey('tax_tmpl_mast_id') && !mapData.containsKey('item_tax_tmpl_id')) {
        mapData['item_tax_tmpl_id'] = mapData.remove('tax_tmpl_mast_id');
      }
      mapData['item_tax_tmpl_id'] ??= 1;

      if (itemImage != null) {
        final fileName = itemImage.path.split(Platform.pathSeparator).last;
        mapData['item_image'] = await MultipartFile.fromFile(itemImage.path, filename: fileName);
        payload = FormData.fromMap(mapData);
      } else {
        payload = mapData;
      }

      final response = await _apiClient.dio.post(
        Endpoints.v6ItemCreate,
        data: payload,
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 1 && responseData['data'] is Map<String, dynamic>) {
        return V6ApiMenuItem.fromJson(responseData['data'] as Map<String, dynamic>);
      } else {
        throw ApiException(
          message: responseData['message'] ?? 'Failed to create item',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> deleteItem({
    int? restoId,
    required int itemId,
    int isForce = 0,
  }) async {
    try {
      final body = <String, dynamic>{
        'item_id': itemId,
        'is_force': isForce,
      };
      if (restoId != null && restoId > 0) body['resto_id'] = restoId;

      final response = await _apiClient.dio.post(
        Endpoints.v6ItemDelete,
        data: body,
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        return responseData;
      } else {
        throw ApiException(
          message: 'Invalid response from delete item endpoint',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
    }
  }
}
