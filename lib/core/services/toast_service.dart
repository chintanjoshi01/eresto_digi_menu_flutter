import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        style: GoogleFonts.nunito(fontWeight: FontWeight.w700, color: Colors.black87),
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
        style: GoogleFonts.nunito(fontWeight: FontWeight.w700, color: Colors.black87),
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
        style: GoogleFonts.nunito(fontWeight: FontWeight.w700, color: Colors.black87),
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

  // Smart Error Handler (aligned with Edge)
  static void showError(String message, {String? techDetail}) {
    final lowerMsg = message.toLowerCase();
    final isTechnical = lowerMsg.contains("sql") || 
                        lowerMsg.contains("exception") || 
                        lowerMsg.contains("unknown column") || 
                        lowerMsg.contains("dio") || 
                        lowerMsg.contains("json") ||
                        lowerMsg.contains("connection") || 
                        lowerMsg.contains("something went wrong") || 
                        lowerMsg.contains("internal server error") || 
                        lowerMsg.contains("500") || 
                        message.length > 200;

    if (isTechnical) {
      _showActionableErrorDialog(message, techDetail: techDetail);
    } else {
      _showToast(message);
    }
  }

  // Standard Error Toast
  static void _showToast(String message) {
    toastification.show(
      type: ToastificationType.error,
      style: ToastificationStyle.minimal,
      title: Text(
        message,
        maxLines: 3,
        style: GoogleFonts.nunito(fontWeight: FontWeight.w700, color: Colors.black87),
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
  static void _showActionableErrorDialog(String message, {String? techDetail}) {
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
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w800,
                    fontSize: 18.sp,
                    color: const Color(0xFFAB2421),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              "An internal technical anomaly has occurred. If this persists, please share this report with support.",
              style: GoogleFonts.nunito(fontWeight: FontWeight.w600, color: Colors.grey.shade700, fontSize: 13.sp),
            ),
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                message,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.sourceCodePro(
                  fontSize: 11.sp,
                  color: Colors.grey.shade800,
                ),
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
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final Map<String, dynamic> report = {
                          "timestamp": DateTime.now().toIso8601String(),
                          "app": "Eresto Digital Menu Standalone",
                          "type": "Technical Error Report",
                          "error": message,
                          "tech_detail": techDetail ?? "N/A",
                        };
                        final tempDir = await getTemporaryDirectory();
                        final file = File('${tempDir.path}/eresto_error_report.json');
                        await file.writeAsString(jsonEncode(report));
                        await Share.shareXFiles(
                          [XFile(file.path)],
                          subject: "Eresto Menu Technical Error Report",
                        );
                      } catch (e) {
                        final transcript = techDetail != null ? "ERROR: $message\n\nDETAILS: $techDetail" : message;
                        await Share.share(transcript, subject: "Eresto Menu Technical Error Report");
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
                          style: GoogleFonts.nunito(fontWeight: FontWeight.w800),
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
