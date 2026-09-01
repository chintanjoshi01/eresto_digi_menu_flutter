import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints.dart';
import '../../domain/models/template_model.dart';
import '../../domain/models/session_model.dart';

abstract class MenuRemoteDataSource {
  Future<List<TemplateModel>> getTemplates();
  Future<TemplateModel> updateTheme({
    required int id,
    required String primaryColor,
    required String backgroundColor,
    required String textColor,
  });

  Future<List<SessionModel>> getSessions();
  Future<SessionModel> updateSession({required int id, required Map<String, dynamic> data});

  Future<void> publishMenu();
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final ApiClient _apiClient;

  MenuRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<TemplateModel>> getTemplates() async {
    try {
      final response = await _apiClient.dio.get(Endpoints.templates);
      final responseData = response.data;
      if (responseData['success'] == true) {
        final list = responseData['data'] as List? ?? [];
        return list.map((json) => TemplateModel.fromJson(json)).toList();
      } else {
        throw Exception(responseData['message'] ?? 'Failed to load templates');
      }
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
    }
  }

  @override
  Future<TemplateModel> updateTheme({
    required int id,
    required String primaryColor,
    required String backgroundColor,
    required String textColor,
  }) async {
    try {
      final response = await _apiClient.dio.patch(
        Endpoints.updateTheme(id),
        data: {
          'primary_color': primaryColor,
          'background_color': backgroundColor,
          'text_color': textColor,
        },
      );
      final responseData = response.data;
      if (responseData['success'] == true) {
        return TemplateModel.fromJson(responseData['data']);
      } else {
        throw Exception(responseData['message'] ?? 'Failed to update theme');
      }
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
    }
  }

  @override
  Future<List<SessionModel>> getSessions() async {
    try {
      final response = await _apiClient.dio.get(Endpoints.sessions);
      final responseData = response.data;
      if (responseData['success'] == true) {
        final list = responseData['data'] as List? ?? [];
        return list.map((json) => SessionModel.fromJson(json)).toList();
      } else {
        throw Exception(responseData['message'] ?? 'Failed to load sessions');
      }
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
    }
  }

  @override
  Future<SessionModel> updateSession({required int id, required Map<String, dynamic> data}) async {
    try {
      final response = await _apiClient.dio.put(Endpoints.updateSession(id), data: data);
      final responseData = response.data;
      if (responseData['success'] == true) {
        return SessionModel.fromJson(responseData['data']);
      } else {
        throw Exception(responseData['message'] ?? 'Failed to update session');
      }
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
    }
  }

  @override
  Future<void> publishMenu() async {
    try {
      final response = await _apiClient.dio.post(Endpoints.publishMenu);
      final responseData = response.data;
      if (responseData['success'] != true) {
        throw Exception(responseData['message'] ?? 'Failed to publish menu');
      }
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
    }
  }
}
