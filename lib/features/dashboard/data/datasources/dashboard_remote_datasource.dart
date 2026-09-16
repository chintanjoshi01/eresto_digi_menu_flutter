import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/api/endpoints.dart';
import '../../../../core/storage/storage_service.dart';
import '../../domain/models/v6_dashboard_response.dart';

abstract class DashboardRemoteDataSource {
  Future<V6DashboardResponse> getDashboardData({String? token});
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient _apiClient;
  final StorageService? _storageService;

  DashboardRemoteDataSourceImpl(this._apiClient, [this._storageService]);

  @override
  Future<V6DashboardResponse> getDashboardData({String? token}) async {
    try {
      final resolvedToken = token ??
          (_storageService?.token.isNotEmpty == true
              ? _storageService!.token
              : (Get.isRegistered<StorageService>() ? Get.find<StorageService>().token : ''));

      // Use POST method and pass Sanctum Bearer token in headers
      final response = await _apiClient.post(
        Endpoints.v6Dashboard,
        data: const {},
        options: Options(
          headers: {
            if (resolvedToken.isNotEmpty) 'Authorization': 'Bearer $resolvedToken',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.data is Map<String, dynamic>) {
        return V6DashboardResponse.fromJson(response.data as Map<String, dynamic>);
      } else if (response.data is String) {
        return const V6DashboardResponse(
          status: 0,
          message: "Unexpected response format",
        );
      }

      return const V6DashboardResponse(
        status: 0,
        message: "Failed to parse dashboard response",
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: "Failed to load dashboard data: $e",
        statusCode: 500,
      );
    }
  }
}
