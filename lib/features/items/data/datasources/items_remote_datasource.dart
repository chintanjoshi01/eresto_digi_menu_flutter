import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints.dart';
import '../../domain/models/item_model.dart';

abstract class ItemsRemoteDataSource {
  Future<List<ItemModel>> getItems({String? category, String? search});
  Future<void> updateAvailability({required int id, required bool isAvailable});
  Future<ItemModel> updateItem({required int id, required Map<String, dynamic> data});
}

class ItemsRemoteDataSourceImpl implements ItemsRemoteDataSource {
  final ApiClient _apiClient;

  ItemsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<ItemModel>> getItems({String? category, String? search}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _apiClient.dio.get(
        Endpoints.menuItems,
        queryParameters: queryParams,
      );

      final responseData = response.data;
      if (responseData['success'] == true) {
        final list = responseData['data'] as List? ?? [];
        return list.map((json) => ItemModel.fromJson(json)).toList();
      } else {
        throw Exception(responseData['message'] ?? 'Failed to fetch items');
      }
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
    }
  }

  @override
  Future<void> updateAvailability({required int id, required bool isAvailable}) async {
    try {
      final response = await _apiClient.dio.patch(
        Endpoints.itemAvailability(id),
        data: {'is_available': isAvailable},
      );
      final responseData = response.data;
      if (responseData['success'] != true) {
        throw Exception(responseData['message'] ?? 'Failed to toggle availability');
      }
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
    }
  }

  @override
  Future<ItemModel> updateItem({required int id, required Map<String, dynamic> data}) async {
    try {
      final response = await _apiClient.dio.put(
        Endpoints.updateItem(id),
        data: data,
      );
      final responseData = response.data;
      if (responseData['success'] == true) {
        return ItemModel.fromJson(responseData['data']);
      } else {
        throw Exception(responseData['message'] ?? 'Failed to update item');
      }
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
    }
  }
}
