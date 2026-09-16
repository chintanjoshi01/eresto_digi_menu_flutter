import 'dart:convert';
import 'v6_auth_data.dart';

/// Enterprise V6 Login Response mapping all API outcomes
class V6LoginResponse {
  final int status;
  final String message;
  final V6AuthData? data;
  final int force;
  final String? errorCode;
  final Map<String, List<String>>? validationErrors;
  final dynamic error;
  final String? errorMsg;
  final dynamic errorDetail;
  final Map<String, dynamic>? rawResponse;

  const V6LoginResponse({
    required this.status,
    required this.message,
    this.data,
    this.force = 0,
    this.errorCode,
    this.validationErrors,
    this.error,
    this.errorMsg,
    this.errorDetail,
    this.rawResponse,
  });

  bool get isSuccess => status == 1 && data != null;
  bool get isForceUpgrade => force == 1 || force == 2 || errorCode == "UPGRADE-APP";
  bool get isPasswordChangeRequired => status == 9;

  /// User-facing display error message (appends specific error msg if available)
  String get displayErrorMessage {
    if (errorMsg != null && errorMsg!.trim().isNotEmpty && errorMsg != message) {
      return "$message: $errorMsg";
    }
    return message;
  }

  /// Formatted technical detail for logging and technician reports
  String get formattedErrorDetail {
    final buffer = StringBuffer();
    if (errorMsg != null && errorMsg!.isNotEmpty) {
      buffer.writeln("Server Error: $errorMsg");
    }
    if (errorDetail != null) {
      buffer.writeln("Stack Details:");
      if (errorDetail is List) {
        for (final frame in (errorDetail as List).take(5)) {
          if (frame is Map) {
            final file = frame['file'] ?? '';
            final line = frame['line'] ?? '';
            final func = frame['function'] ?? '';
            final cls = frame['class'] ?? '';
            final type = frame['type'] ?? '';
            buffer.writeln("  -> $cls$type$func() at $file:$line");
          } else {
            buffer.writeln("  -> $frame");
          }
        }
      } else if (errorDetail is String) {
        buffer.writeln(errorDetail);
      } else {
        buffer.writeln(const JsonEncoder.withIndent('  ').convert(errorDetail));
      }
    }
    return buffer.toString().trim();
  }

  factory V6LoginResponse.fromJson(Map<String, dynamic> json) {
    final status = (json['status'] as num?)?.toInt() ?? 0;
    final message = json['message']?.toString() ?? "Unknown Response";
    final force = (json['force'] as num?)?.toInt() ?? 0;
    final errorCode = json['error_code']?.toString();

    V6AuthData? authData;
    if (json['data'] is Map<String, dynamic>) {
      authData = V6AuthData.fromJson(json['data'] as Map<String, dynamic>);
    }

    Map<String, List<String>>? errors;
    if (json['data'] is Map && (json['data'] as Map)['errors'] is Map) {
      final errMap = (json['data'] as Map)['errors'] as Map<String, dynamic>;
      errors = errMap.map((k, v) => MapEntry(
            k,
            (v is List) ? v.map((e) => e.toString()).toList() : [v.toString()],
          ));
    }

    // Extract error object from backend (e.g. Laravel exception payload)
    final rawError = json['error'];
    String? errorMsg;
    dynamic errorDetail;

    if (rawError is Map) {
      errorMsg = rawError['msg']?.toString() ?? rawError['message']?.toString();
      final detailVal = rawError['detail'];
      if (detailVal is String && (detailVal.trim().startsWith('[') || detailVal.trim().startsWith('{'))) {
        try {
          errorDetail = jsonDecode(detailVal);
        } catch (_) {
          errorDetail = detailVal;
        }
      } else {
        errorDetail = detailVal;
      }
    } else if (rawError is String) {
      errorMsg = rawError;
    }

    return V6LoginResponse(
      status: status,
      message: message,
      data: authData,
      force: force != 0 ? force : (authData?.force ?? 0),
      errorCode: errorCode,
      validationErrors: errors,
      error: rawError,
      errorMsg: errorMsg,
      errorDetail: errorDetail,
      rawResponse: json,
    );
  }
}
