import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/api/endpoints.dart';
import '../../../../core/models/v6_login_sync_model.dart';
import '../../../../core/storage/storage_service.dart';

abstract class LoginSyncRemoteDataSource {
  Future<V6LoginSyncResponse> getLoginSyncData({int? restoId, String? syncReq});
}

class LoginSyncRemoteDataSourceImpl implements LoginSyncRemoteDataSource {
  final ApiClient _apiClient;

  LoginSyncRemoteDataSourceImpl(this._apiClient);

  @override
  Future<V6LoginSyncResponse> getLoginSyncData({int? restoId, String? syncReq}) async {
    try {
      final body = <String, dynamic>{};
      if (restoId != null && restoId > 0) {
        body['resto_id'] = restoId;
      }
      if (syncReq != null && syncReq.isNotEmpty) {
        body['sync_req'] = syncReq;
      }

      final response = await _apiClient.dio.post(
        Endpoints.v6LoginSync,
        data: body,
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final parsed = V6LoginSyncResponse.fromJson(responseData);
        if (parsed.isSuccess) {
          return parsed;
        } else {
          throw ApiException(
            message: parsed.message.isNotEmpty
                ? parsed.message
                : 'Failed to fetch login sync data',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ApiException(
          message: 'Invalid response format from sync API',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
    }
  }
}

abstract class LoginSyncRepository {
  Future<V6LoginSyncData?> syncIfNeeded({bool force = false});
  V6LoginSyncData? get cachedData;
}

class LoginSyncRepositoryImpl implements LoginSyncRepository {
  final LoginSyncRemoteDataSource _remoteDataSource;
  final StorageService _storageService;

  LoginSyncRepositoryImpl(this._remoteDataSource, this._storageService);

  @override
  V6LoginSyncData? get cachedData => _storageService.cachedLoginSyncData;

  @override
  Future<V6LoginSyncData?> syncIfNeeded({bool force = false}) async {
    // 1. Cache-first: If valid cache exists and not forced, return immediately (ZERO network overhead)
    if (!force && _storageService.hasValidLoginSync) {
      return _storageService.cachedLoginSyncData;
    }

    // 2. Fetch fresh master metadata from remote V6 endpoint
    try {
      final response = await _remoteDataSource.getLoginSyncData(
        restoId: _storageService.restoId > 0 ? _storageService.restoId : null,
      );

      if (response.isSuccess && response.data != null) {
        await _storageService.saveLoginSyncData(response.data!.toJson());
        return _storageService.cachedLoginSyncData;
      }
    } catch (_) {
      // If network fails, return whatever is currently cached (offline resilience)
      if (_storageService.cachedLoginSyncData != null) {
        return _storageService.cachedLoginSyncData;
      }
    }

    return _storageService.cachedLoginSyncData;
  }
}
