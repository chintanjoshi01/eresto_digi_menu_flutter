import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints.dart';
import '../../domain/models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login({
    required String email,
    required String password,
  });
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        Endpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      
      // Laravel REST standard data unwrap
      final responseData = response.data;
      if (responseData['success'] == true) {
        return AuthModel.fromJson(responseData['data']);
      } else {
        throw Exception(responseData['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
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
