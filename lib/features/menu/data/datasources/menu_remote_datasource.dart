import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints.dart';
import '../../domain/models/template_model.dart';
import '../../domain/models/session_model.dart';
import '../../domain/models/channel_session_group_model.dart';

abstract class MenuRemoteDataSource {
  // --- V6 Menu Builder APIs (Official) ---
  Future<Map<String, dynamic>> getMenuBuilderData();
  Future<Map<String, dynamic>> changeTheme({required int templateId, required int themeId});
  Future<List<dynamic>> getThemesCatalog();
  Future<Map<String, dynamic>> updateChannelSession({
    required int sessionId,
    required String op,
    required Map<String, dynamic> sessionJson,
  });
  Future<Map<String, dynamic>> getSingleSession({required int sessionId});

  // --- Legacy Methods ---
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

  // --------------------------------------------------------------------------
  // V6 Menu Builder APIs (Official)
  // --------------------------------------------------------------------------

  @override
  Future<Map<String, dynamic>> getMenuBuilderData() async {
    try {
      final response = await _apiClient.dio.post(Endpoints.v6MenuBuilderData, data: {});
      final data = response.data;
      if (data != null && data['status'] == 1 && data['data'] != null) {
        return data['data'] as Map<String, dynamic>;
      } else {
        throw Exception(data?['message'] ?? 'Failed to load menu builder data');
      }
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> changeTheme({
    required int templateId,
    required int themeId,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        Endpoints.v6ChangeTheme,
        data: {
          'menu_tmpl_id': templateId,
          'theme_id': themeId,
        },
      );
      final data = response.data;
      if (data != null && data['status'] == 1) {
        return (data['data'] as Map<String, dynamic>?) ?? {};
      } else {
        throw Exception(data?['message'] ?? 'Failed to change theme');
      }
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
    }
  }

  @override
  Future<List<dynamic>> getThemesCatalog() async {
    try {
      final response = await _apiClient.dio.post(Endpoints.v6GetThemes, data: {});
      final data = response.data;
      if (data != null && data['status'] == 1 && data['data'] is List) {
        return data['data'] as List<dynamic>;
      } else {
        throw Exception(data?['message'] ?? 'Failed to load themes catalog');
      }
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> updateChannelSession({
    required int sessionId,
    required String op,
    required Map<String, dynamic> sessionJson,
  }) async {
    try {
      final payloadJson = Map<String, dynamic>.from(sessionJson);
      if (payloadJson.containsKey('start_time') && payloadJson['start_time'] != null) {
        payloadJson['start_time'] =
            SessionCardModel.formatTo24Hour(payloadJson['start_time'].toString());
      }
      if (payloadJson.containsKey('end_time') && payloadJson['end_time'] != null) {
        payloadJson['end_time'] =
            SessionCardModel.formatTo24Hour(payloadJson['end_time'].toString());
      }

      final response = await _apiClient.dio.post(
        Endpoints.v6UpdateSession,
        data: {
          'session_id': sessionId,
          'op': op,
          'session_json': payloadJson,
        },
      );
      final data = response.data;
      if (data != null && data['status'] == 1) {
        return (data['data'] as Map<String, dynamic>?) ?? {};
      } else {
        throw Exception(data?['message'] ?? 'Failed to update channel session');
      }
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getSingleSession({required int sessionId}) async {
    try {
      final response = await _apiClient.dio.post(
        Endpoints.v6GetSession,
        data: {'session_id': sessionId},
      );
      final data = response.data;
      if (data != null && data['status'] == 1) {
        return (data['data'] as Map<String, dynamic>?) ?? {};
      } else {
        throw Exception(data?['message'] ?? 'Failed to get session details');
      }
    } on DioException catch (e) {
      throw _apiClient.handleDioError(e);
    }
  }

  // --------------------------------------------------------------------------
  // Legacy / Backward Compatibility
  // --------------------------------------------------------------------------

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
