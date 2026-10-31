import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../api/api_client.dart';
import '../services/device_service.dart';
import '../storage/storage_service.dart';
import 'encryption_service.dart';

class ToastService {
  // Shadow matching Edge app style
  static final List<BoxShadow> highModeShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 15,
      offset: const Offset(0, 5),
    )
  ];

  // Success Toast
  static void showSuccess(String message) {
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.minimal,
      title: Text(
        message,
        maxLines: 3,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.black87),
      ),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 2),
      icon: const Icon(Icons.check_circle, color: Colors.green),
      primaryColor: Colors.green,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: BorderRadius.circular(8),
      boxShadow: highModeShadow,
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.always,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
    );
  }

  // Warning Toast
  static void showWarning(String message) {
    toastification.show(
      type: ToastificationType.warning,
      style: ToastificationStyle.minimal,
      title: Text(
        message,
        maxLines: 3,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.black87),
      ),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 3),
      icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
      primaryColor: Colors.orange,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: BorderRadius.circular(8),
      boxShadow: highModeShadow,
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.always,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
    );
  }

  // Info Toast
  static void showInfo(String message) {
    toastification.show(
      type: ToastificationType.info,
      style: ToastificationStyle.minimal,
      title: Text(
        message,
        maxLines: 3,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.black87),
      ),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 2),
      icon: const Icon(Icons.info_outline, color: Color(0xFF00BFFF)),
      primaryColor: const Color(0xFF00BFFF),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: BorderRadius.circular(8),
      boxShadow: highModeShadow,
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.none,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
    );
  }

  // Smart Error Handler (aligned with Edge & Clean Architecture)
  static void showError(String message, {dynamic techDetail}) {
    final cleanMessage = _sanitizeErrorMessage(message);

    // If techDetail is a standard JSON response wrapper without technical stack trace, strip it
    dynamic cleanTechDetail = techDetail;
    if (cleanTechDetail is String && cleanTechDetail.trim().startsWith('{')) {
      try {
        final decoded = jsonDecode(cleanTechDetail);
        if (decoded is Map && decoded.containsKey('status') && decoded.containsKey('message')) {
          if (!decoded.containsKey('error_detail') && !decoded.containsKey('stack') && !decoded.containsKey('trace')) {
            cleanTechDetail = null;
          }
        }
      } catch (_) {}
    }

    final isTechnical = _isTechnicalError(cleanMessage, cleanTechDetail);

    if (isTechnical) {
      _showActionableErrorDialog(cleanMessage, techDetail: cleanTechDetail);
    } else {
      _showToast(cleanMessage);
    }
  }

  static String _sanitizeErrorMessage(String msg) {
    final trimmed = msg.trim();
    if (trimmed.startsWith('{')) {
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is Map && decoded.containsKey('message') && decoded['message'] != null) {
          return decoded['message'].toString();
        }
      } catch (_) {}
    }
    return msg;
  }

  static bool _isTechnicalError(String message, dynamic techDetail) {
    final lowerMsg = message.toLowerCase();
    final techStr = techDetail?.toString().toLowerCase() ?? '';

    // Standard business/user errors are NOT technical anomalies
    final isBusinessError = lowerMsg.contains("invalid login credentials") ||
        lowerMsg.contains("invalid credentials") ||
        lowerMsg.contains("invalid username or password") ||
        lowerMsg.contains("please enter your") ||
        lowerMsg.contains("validation error") ||
        lowerMsg.contains("permission") ||
        lowerMsg.contains("unauthorized") ||
        lowerMsg.contains("session expired");

    if (isBusinessError &&
        !techStr.contains("stack details:") &&
        !techStr.contains("at package:") &&
        !techStr.contains("at file:")) {
      return false;
    }

    // Genuine technical error indicators
    return lowerMsg.contains("sql") ||
        lowerMsg.contains("unknown column") ||
        lowerMsg.contains("dioexception") ||
        lowerMsg.contains("connection refused") ||
        lowerMsg.contains("socketexception") ||
        lowerMsg.contains("handshakeexception") ||
        lowerMsg.contains("internal server error") ||
        lowerMsg.contains("undefined variable") ||
        lowerMsg.contains("500") ||
        techStr.contains("stack details:") ||
        techStr.contains("at package:") ||
        techStr.contains("at file:") ||
        techStr.contains("dioexception") ||
        techStr.contains("sql");
  }

  // Standard Error Toast
  static void _showToast(String message) {
    toastification.show(
      type: ToastificationType.error,
      style: ToastificationStyle.minimal,
      title: Text(
        message,
        maxLines: 3,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.black87),
      ),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      icon: const Icon(Icons.error_outline, color: Colors.red),
      primaryColor: Colors.red,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: BorderRadius.circular(8),
      boxShadow: highModeShadow,
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.always,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
    );
  }

  // Actionable Technical Error Dialog
  static void _showActionableErrorDialog(String message, {dynamic techDetail}) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.report_problem_rounded, color: const Color(0xFFAB2421), size: 28.sp),
                SizedBox(width: 10.w),
                Text(
                  "Technical Error Detected",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                    color: const Color(0xFFAB2421),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              "An internal technical anomaly has occurred. If this persists, please share this report with support.",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.grey.shade700, fontSize: 13.sp),
            ),
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.sourceCodePro(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  if (techDetail != null &&
                      techDetail.toString().trim().isNotEmpty &&
                      techDetail.toString().trim() != message.trim()) ...[
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: Colors.red.shade100),
                      ),
                      child: Text(
                        techDetail is String
                            ? techDetail
                            : const JsonEncoder.withIndent('  ').convert(techDetail),
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.sourceCodePro(
                          fontSize: 10.sp,
                          color: const Color(0xFFAB2421),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      "Close",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final tx = ApiClient.lastFailedTransaction ?? ApiClient.lastTransaction;

                      dynamic resolvedDetail = techDetail;
                      if (resolvedDetail == null && tx?.responseBody != null) {
                        if (tx!.responseBody is Map) {
                          resolvedDetail = tx.responseBody['error'] ?? tx.responseBody['message'];
                        }
                      }
                      if (resolvedDetail == null && tx?.errorMessage != null) {
                        resolvedDetail = tx!.errorMessage;
                      }

                      final deviceId = Get.isRegistered<DeviceService>()
                          ? Get.find<DeviceService>().deviceId
                          : "Unknown";

                      final storage = Get.isRegistered<StorageService>()
                          ? Get.find<StorageService>()
                          : null;

                      final Map<String, dynamic> report = {
                        "report_type": "Eresto Technical Error Report",
                        "timestamp": DateTime.now().toIso8601String(),
                        "app_info": {
                          "name": "Eresto Digital Menu Standalone",
                          "package": "in.eresto.digimenu",
                          "app_version": DeviceService.appVersion,
                          "product_id": DeviceService.productId,
                          "login_from": DeviceService.loginFrom,
                        },
                        "device_info": {
                          "platform": Platform.operatingSystem,
                          "os_version": Platform.operatingSystemVersion,
                          "device_id": deviceId,
                          "locale": Platform.localeName,
                        },
                        "session_info": {
                          "is_logged_in": storage?.isLoggedIn ?? false,
                          "user_name": storage?.userName ?? "",
                          "resto_id": storage?.restoId ?? "",
                          "resto_name": storage?.restoName ?? "",
                          "role_id": storage?.roleId ?? "",
                          "subscription": storage?.subscription ?? "",
                        },
                        "error_info": {
                          "summary": message,
                          "tech_detail": resolvedDetail ?? "N/A",
                        },
                        if (tx != null) "network_transaction": tx.toJson(),
                      };

                      try {
                        // Encrypt report payload with AES-256 to protect backend stack and session details
                        final encryptedPayload = EncryptionService.encryptJson(report);

                        final Map<String, dynamic> encryptedEnvelope = {
                          "report_type": "Eresto Technical Error Report (Encrypted)",
                          "encrypted_data": encryptedPayload,
                          "version": "1.0",
                          "timestamp": DateTime.now().toIso8601String(),
                        };

                        const encoder = JsonEncoder.withIndent('  ');
                        final formattedJson = encoder.convert(encryptedEnvelope);

                        final tempDir = await getTemporaryDirectory();
                        final file = File('${tempDir.path}/eresto_error_report.enc');
                        await file.writeAsString(formattedJson);

                        await Share.shareXFiles(
                          [XFile(file.path)],
                          subject: "Digi Menu Technical Error Report (Encrypted)",
                          text: "Digi Menu Technical Error Report (Encrypted payload enclosed): $message",
                        );
                      } catch (e) {
                        final encryptedText = EncryptionService.encryptText(
                          "Timestamp: ${DateTime.now().toIso8601String()}\nError: $message\nDetails: $resolvedDetail\nAPI: ${tx?.url}",
                        );
                        await Share.share(
                          "=== DIGI MENU TECHNICAL ERROR REPORT (ENCRYPTED) ===\n$encryptedText",
                          subject: "Digi Menu Technical Error Report (Encrypted)",
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAB2421),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.share_rounded, size: 16.sp),
                        SizedBox(width: 6.w),
                        Text(
                          "Share to Tech",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
