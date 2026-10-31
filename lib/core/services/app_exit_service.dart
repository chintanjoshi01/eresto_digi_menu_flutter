import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

/// Enterprise Application Exit Service providing double-tap back confirmation
/// to prevent accidental closures and ensure clean application termination.
class AppExitService {
  static DateTime? _lastBackPressTime;

  /// Handles back press with standard enterprise double-back confirmation.
  /// Returns `true` if application exit was triggered, `false` if warning toast was displayed.
  static bool handleDoubleBackExit({
    String message = "Press back again to exit",
  }) {
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      HapticFeedback.lightImpact();

      toastification.show(
        type: ToastificationType.info,
        style: ToastificationStyle.minimal,
        title: Text(
          message,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 12.5.sp,
            color: Colors.white,
          ),
        ),
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 2),
        icon: const Icon(Icons.exit_to_app_rounded, color: Colors.white, size: 18),
        primaryColor: Colors.white,
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        showProgressBar: false,
        closeButtonShowType: CloseButtonShowType.none,
        closeOnClick: true,
        pauseOnHover: false,
        dragToClose: true,
      );
      return false;
    }

    _lastBackPressTime = null;
    toastification.dismissAll();
    SystemNavigator.pop();
    return true;
  }
}

/// Custom TextInputFormatter to convert all text input to uppercase in real time.
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
