import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../storage/storage_service.dart';
import 'api_exception.dart';

class ApiClient {
  static const String defaultBaseUrl = "https://api.eresto.in/api/v1";
  late final Dio _dio;

  ApiClient() {
    const baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: defaultBaseUrl);

    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Inject Bearer JWT token from StorageService
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (Get.isRegistered<StorageService>()) {
          final storage = Get.find<StorageService>();
          if (storage.isLoggedIn) {
            options.headers['Authorization'] = 'Bearer ${storage.token}';
          }
        }
        return handler.next(options);
      },
      onError: (e, handler) async {
        // Handle 401 Unauthorized
        if (e.response?.statusCode == 401) {
          if (Get.isRegistered<StorageService>()) {
            await Get.find<StorageService>().clear();
          }
          // Redirect to login using GetX route
          Get.offAllNamed('/login');
        }
        return handler.next(e);
      },
    ));

    // Full Logger (in debug/log-enabled environments)
    if (Get.isLogEnable) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ));
    }
  }

  Dio get dio => _dio;

  ApiException handleDioError(DioException e) {
    String msg = "Something went wrong";
    int? code = e.response?.statusCode;
    dynamic details;

    if (e.response != null && e.response?.data != null) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        msg = data['message'] ?? msg;
        details = data['errors'] ?? data['data'];
      }
    } else {
      msg = e.message ?? msg;
    }

    return ApiException(message: msg, statusCode: code, details: details);
  }
}
