import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/api/endpoints.dart';
import '../../domain/models/v6_login_request.dart';
import '../../domain/models/v6_login_response.dart';

/// Contract for Remote Authentication operations
abstract class AuthRemoteDataSource {
  Future<V6LoginResponse> login(V6LoginRequest request);
  Future<void> logout();
}

/// Implementation connecting to Eresto V6 endpoints
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<V6LoginResponse> login(V6LoginRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        Endpoints.v6Login,
        data: request.toJson(),
      );

      if (response.data is Map<String, dynamic>) {
        return V6LoginResponse.fromJson(response.data as Map<String, dynamic>);
      }
      throw ApiException(message: "Invalid response format from server");
    } on DioException catch (e) {
      // In Laravel V6 API, 404 is returned on validation failures with JSON body
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        return V6LoginResponse.fromJson(e.response!.data as Map<String, dynamic>);
      }
      throw _apiClient.handleDioError(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.dio.post(Endpoints.logout);
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
    }
  }
}
