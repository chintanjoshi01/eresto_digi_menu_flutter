import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/api/endpoints.dart';
import '../../../../core/services/device_service.dart';
import '../../../../core/storage/storage_service.dart';
import '../../domain/models/v6_dashboard_response.dart';

abstract class DashboardRemoteDataSource {
  Future<V6DashboardResponse> getDashboardData({String? token, String? cv});
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient _apiClient;
  final StorageService? _storageService;

  DashboardRemoteDataSourceImpl(this._apiClient, [this._storageService]);

  @override
  Future<V6DashboardResponse> getDashboardData({String? token, String? cv}) async {
    try {
      final resolvedToken = token ??
          (_storageService?.token.isNotEmpty == true
              ? _storageService!.token
              : (Get.isRegistered<StorageService>() ? Get.find<StorageService>().token : ''));

      final storage = _storageService ?? (Get.isRegistered<StorageService>() ? Get.find<StorageService>() : null);
      final currentRestoId = storage?.restoId ?? 0;
      final resolvedCv = cv ?? DeviceService.appVersion;

      // Send cv and resto_id in the V6 dashboard request payload
      final payload = <String, dynamic>{
        'cv': resolvedCv,
        if (currentRestoId > 0) 'resto_id': currentRestoId,
      };

      // Use POST method and pass Sanctum Bearer token in headers
      final response = await _apiClient.post(
        Endpoints.v6Dashboard,
        data: payload,
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
