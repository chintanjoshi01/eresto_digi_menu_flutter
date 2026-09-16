import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:get/get.dart' hide Response;

import '../errors/failures.dart';
import '../storage/storage_service.dart';
import 'api_exception.dart';
import 'endpoints.dart';

/// Enterprise ApiClient powered by Dio with connection pooling, SSL resilience,
/// bearer token authentication interceptor, and structured error classification.
class ApiClient {
  late final Dio _dio;

  ApiClient({String? baseUrl}) {
    final resolvedBaseUrl = baseUrl ??
        const String.fromEnvironment('API_BASE_URL', defaultValue: Endpoints.baseUrl);

    _dio = Dio(BaseOptions(
      baseUrl: resolvedBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Connection': 'keep-alive',
      },
    ));

    // Fix SSL Handshake & custom certificate challenges on enterprise networks (aligned with Edge)
    if (_dio.httpClientAdapter is IOHttpClientAdapter) {
      (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    // --- 1. Token & Session Interceptor ---
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
        // Handle 401 Unauthorized token invalidation
        if (e.response?.statusCode == 401) {
          if (Get.isRegistered<StorageService>()) {
            await Get.find<StorageService>().clearSession();
          }
          if (Get.currentRoute != '/login') {
            Get.offAllNamed('/login');
          }
        }
        return handler.next(e);
      },
    ));

    // --- 2. Diagnostics & Audit Tracker Interceptor ---
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.extra['request_start_time'] = DateTime.now().millisecondsSinceEpoch;
        return handler.next(options);
      },
      onResponse: (response, handler) {
        final startTime = response.requestOptions.extra['request_start_time'] as int?;
        final duration = startTime != null
            ? DateTime.now().millisecondsSinceEpoch - startTime
            : 0;

        final tx = ApiTransaction(
          url: response.requestOptions.uri.toString(),
          method: response.requestOptions.method,
          statusCode: response.statusCode,
          requestHeaders: _sanitizeHeaders(response.requestOptions.headers),
          requestBody: _sanitizePayload(response.requestOptions.data),
          responseBody: _sanitizePayload(response.data),
          durationMs: duration,
          timestamp: DateTime.now(),
        );

        lastTransaction = tx;

        final isHttpError = response.statusCode != null && (response.statusCode! < 200 || response.statusCode! >= 300);
        final isBusinessError = response.data is Map &&
            ((response.data['status'] is num && response.data['status'] != 1) ||
             response.data['error'] != null);

        if (isHttpError || isBusinessError) {
          lastFailedTransaction = tx;
        }

        return handler.next(response);
      },
      onError: (e, handler) {
        final startTime = e.requestOptions.extra['request_start_time'] as int?;
        final duration = startTime != null
            ? DateTime.now().millisecondsSinceEpoch - startTime
            : 0;

        final tx = ApiTransaction(
          url: e.requestOptions.uri.toString(),
          method: e.requestOptions.method,
          statusCode: e.response?.statusCode,
          requestHeaders: _sanitizeHeaders(e.requestOptions.headers),
          requestBody: _sanitizePayload(e.requestOptions.data),
          responseBody: _sanitizePayload(e.response?.data),
          durationMs: duration,
          timestamp: DateTime.now(),
          errorMessage: e.message ?? e.error?.toString(),
        );

        lastTransaction = tx;
        lastFailedTransaction = tx;

        return handler.next(e);
      },
    ));

    // --- 2. ADD FULL LOGGING (Request & Response) - Aligned with eresto_edge_flutter ---
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true, // <--- Log what we send
      responseHeader: false,
      responseBody: true, // <--- Log what we get back (Crucial)
      error: true,
    ));
  }

  static ApiTransaction? lastTransaction;
  static ApiTransaction? lastFailedTransaction;

  Dio get dio => _dio;

  // --- Convenience HTTP Helpers ---

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Enterprise error mapping from DioException to ApiException
  ApiException handleDioError(DioException e) {
    String msg = "Connection error. Please check your internet connection.";
    int? code = e.response?.statusCode;
    dynamic details;

    final isConnectivity = e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError;

    if (isConnectivity) {
      return ApiException(
        message: "Unable to connect to server. Please check your network.",
        statusCode: 0,
      );
    }

    if (e.response != null && e.response?.data != null) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        msg = data['message'] ?? msg;
        details = data['error'] ?? data['errors'] ?? data['data'];
      }
    } else {
      msg = e.message ?? msg;
    }

    return ApiException(message: msg, statusCode: code, details: details);
  }

  /// Map DioException or ApiException to Clean Architecture Failure
  Failure mapExceptionToFailure(dynamic error) {
    if (error is DioException) {
      final isConnectivity = error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError;

      if (isConnectivity) {
        return const NetworkFailure();
      }

      if (error.response?.statusCode == 401) {
        return const UnauthorizedFailure();
      }

      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        // Validation failure (404)
        if (data['data'] is Map && data['data']['errors'] != null) {
          final rawErrors = data['data']['errors'] as Map<String, dynamic>;
          final parsed = rawErrors.map((k, v) => MapEntry(
                k,
                (v is List) ? v.map((e) => e.toString()).toList() : [v.toString()],
              ));
          return ValidationFailure(data['message'] ?? "Validation Error", fieldErrors: parsed);
        }

        return ServerFailure(
          data['message'] ?? "Server error occurred",
          statusCode: error.response?.statusCode,
          details: data['error'] ?? data,
        );
      }

      return ServerFailure(
        error.message ?? "Server error occurred",
        statusCode: error.response?.statusCode,
      );
    } else if (error is ApiException) {
      return ServerFailure(error.message, statusCode: error.statusCode, details: error.details);
    }

    return ServerFailure(error.toString());
  }

  // --- Sanitization Utilities for Error Diagnostics ---

  static Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final sanitized = <String, dynamic>{};
    for (final entry in headers.entries) {
      final key = entry.key;
      final lowerKey = key.toLowerCase();
      if (lowerKey.contains('authorization') || lowerKey.contains('token')) {
        sanitized[key] = "Bearer ******";
      } else {
        sanitized[key] = entry.value;
      }
    }
    return sanitized;
  }

  static dynamic _sanitizePayload(dynamic data) {
    if (data == null) return null;
    if (data is Map) {
      final sanitized = <String, dynamic>{};
      for (final entry in data.entries) {
        final key = entry.key.toString();
        final lowerKey = key.toLowerCase();
        if (lowerKey.contains('password') ||
            lowerKey.contains('secret') ||
            lowerKey.contains('pin') ||
            lowerKey.contains('token')) {
          sanitized[key] = "******";
        } else {
          sanitized[key] = _sanitizePayload(entry.value);
        }
      }
      return sanitized;
    }
    if (data is List) {
      return data.map((e) => _sanitizePayload(e)).toList();
    }
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        return _sanitizePayload(decoded);
      } catch (_) {
        return data;
      }
    }
    return data;
  }
}

/// Record of an HTTP API transaction for technical diagnostic logs
class ApiTransaction {
  final String url;
  final String method;
  final int? statusCode;
  final Map<String, dynamic> requestHeaders;
  final dynamic requestBody;
  final dynamic responseBody;
  final int durationMs;
  final DateTime timestamp;
  final String? errorMessage;

  ApiTransaction({
    required this.url,
    required this.method,
    this.statusCode,
    required this.requestHeaders,
    this.requestBody,
    this.responseBody,
    required this.durationMs,
    required this.timestamp,
    this.errorMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      "timestamp": timestamp.toIso8601String(),
      "url": url,
      "method": method,
      "status_code": statusCode,
      "duration_ms": durationMs,
      "request_headers": requestHeaders,
      "request_body": requestBody,
      "response_body": responseBody,
      if (errorMessage != null) "error": errorMessage,
    };
  }
}
