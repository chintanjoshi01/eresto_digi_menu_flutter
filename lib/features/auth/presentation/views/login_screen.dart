import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../../core/services/app_exit_service.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/brand_progress_indicator.dart';
import '../controllers/login_controller.dart';

/// Enterprise Responsive Login Screen supporting Mobile, POS Terminals, and Desktop layouts.
class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final isTablet = shortestSide >= 550;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        AppExitService.handleDoubleBackExit();
      },
      child: Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 920.w : 380.w,
            ),
            child: Container(
              height: isTablet ? 560.h : null,
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radius16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radius16),
                child: isTablet
                    ? Row(
                        children: [
                          // --- LEFT SIDE (Brand Banner & Animated Illustration) ---
                          Expanded(
                            child: Container(
                              color: const Color(0xFFFAFAFA),
                              padding: EdgeInsets.all(36.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Brand Logo (Image.asset for .png format)
                                  Image.asset(
                                    'assets/images/eresto-pos-logo.png',
                                    height: 54.h,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => Text(
                                      "eResto",
                                      style: AppTypography.erestoWordmark.copyWith(
                                        fontSize: 32.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    "Your Menu. More Possibilities.",
                                    textAlign: TextAlign.center,
                                    style: AppTypography.taglinePrimary.copyWith(fontSize: 16.sp),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    "SCAN • EXPLORE • ORDER • GROW",
                                    textAlign: TextAlign.center,
                                    style: AppTypography.taglineSequence.copyWith(fontSize: 11.sp),
                                  ),
                                  SizedBox(height: 32.h),
                                  // Floating Animated Vector Illustration
                                  Flexible(
                                    child: TweenAnimationBuilder<double>(
                                      duration: const Duration(milliseconds: 900),
                                      tween: Tween(begin: 0.0, end: 1.0),
                                      curve: Curves.easeOutCubic,
                                      builder: (context, value, child) {
                                        return Transform.translate(
                                          offset: Offset(0, 24 * (1 - value)),
                                          child: Opacity(opacity: value, child: child),
                                        );
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/left_login.svg',
                                        height: 240.h,
                                        fit: BoxFit.contain,
                                        placeholderBuilder: (context) => Icon(
                                          Icons.restaurant_rounded,
                                          size: 100.sp,
                                          color: AppColors.primaryLight,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Divider Line
                          Container(width: 1.w, color: Colors.grey.shade200),
                          // --- RIGHT SIDE (Form Content) ---
                          Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(horizontal: 44.w, vertical: 36.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _buildAnimatedForm(context),
                              ),
                            ),
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  // Brand Logo for Mobile Layout
                                  Image.asset(
                                    'assets/images/eresto-pos-logo.png',
                                    height: 48.h,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => Text(
                                      "eResto",
                                      style: AppTypography.erestoWordmark.copyWith(
                                        color: AppColors.primary,
                                        fontSize: 28.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    "Your Menu. More Possibilities.",
                                    textAlign: TextAlign.center,
                                    style: AppTypography.taglinePrimary.copyWith(fontSize: 13.sp),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    "SCAN • EXPLORE • ORDER • GROW",
                                    textAlign: TextAlign.center,
                                    style: AppTypography.taglineSequence.copyWith(fontSize: 9.sp),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 28.h),
                            ..._buildAnimatedForm(context),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

  List<Widget> _buildAnimatedForm(BuildContext context) {
    final List<Widget> items = [
      Text(
        "Login",
        style: AppTypography.pageTitle.copyWith(
          fontSize: 26.sp,
          color: const Color(0xFF353534),
        ),
      ),
      SizedBox(height: 6.h),
      Text(
        "Please Enter Your Credentials to Login",
        style: AppTypography.subtitle.copyWith(
          fontSize: 14.sp,
          color: const Color(0xFF6A6968),
        ),
      ),
      SizedBox(height: 28.h),

      // Username / Email input field
      _buildTextField(
        controller: controller.usernameController,
        hint: "User Name",
        icon: Icons.person_outline_rounded,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          UpperCaseTextFormatter(),
        ],
      ),
      SizedBox(height: 16.h),

      // Password input field with visibility toggle
      Obx(() => _buildTextField(
            controller: controller.passwordController,
            hint: "Password",
            isPassword: true,
            obscureText: controller.isPasswordObscured.value,
            onToggleVisibility: () =>
                controller.isPasswordObscured.value = !controller.isPasswordObscured.value,
            icon: Icons.lock_outline_rounded,
          )),
      SizedBox(height: 16.h),

      // Remember Me Checkbox
      Row(
        children: [
          Obx(() => SizedBox(
                width: 20.w,
                height: 20.h,
                child: Checkbox(
                  value: controller.isRememberMe.value,
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                  onChanged: (val) => controller.isRememberMe.value = val ?? false,
                ),
              )),
          SizedBox(width: 10.w),
          Text(
            "Remember Me",
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 13.sp,
              color: const Color(0xFF353534),
            ),
          ),
        ],
      ),
      SizedBox(height: 24.h),

      // Login Button incorporating the BrandProgressIndicator loader
      SizedBox(
        width: double.infinity,
        height: 48.h,
        child: Obx(() => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radius8),
                ),
                elevation: 0,
              ),
              onPressed: controller.isLoading.value ? null : () => controller.login(),
              child: controller.isLoading.value
                  ? SizedBox(
                      width: 22.w,
                      height: 22.h,
                      child: const BrandProgressIndicator(
                        size: 22.0,
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      "Login",
                      style: AppTypography.button.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            )),
      ),
      SizedBox(height: 18.h),

      // Forgot Password link (Register action removed)
      Center(
        child: InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: () => _showForgotPasswordSheet(context),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            child: Text(
              "Forgot Your Password?",
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      SizedBox(height: 12.h),

      // In-App Legal & Privacy Policy Link (Google Play Policy Compliance)
      Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              "By signing in, you agree to our ",
              style: GoogleFonts.poppins(
                color: const Color(0xFF94A3B8),
                fontSize: 11.sp,
              ),
            ),
            InkWell(
              onTap: () => _launchWebUrl("https://eresto.in/terms"),
              child: Text(
                "Terms",
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Text(
              " & ",
              style: GoogleFonts.poppins(
                color: const Color(0xFF94A3B8),
                fontSize: 11.sp,
              ),
            ),
            InkWell(
              onTap: () => _launchWebUrl("https://eresto.in/privacy"),
              child: Text(
                "Privacy Policy",
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    ];

    // Wrap elements with staggered slide & fade animations
    return items.asMap().entries.map((entry) {
      final idx = entry.key;
      final widget = entry.value;
      return TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: 350 + (idx * 50)),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.easeOutQuad,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(18 * (1 - value), 0),
              child: child,
            ),
          );
        },
        child: widget,
      );
    }).toList();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = true,
    VoidCallback? onToggleVisibility,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? obscureText : false,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      style: AppTypography.bodyLarge.copyWith(fontSize: 15.sp, color: const Color(0xFF353534)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.bodyMedium.copyWith(color: const Color(0xFF9E9E9D), fontSize: 14.sp),
        prefixIcon: Icon(icon, size: 20.sp, color: AppColors.textMuted),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: const Color(0xFF9E9E9D),
                  size: 20.sp,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
          borderSide: const BorderSide(color: Color(0xFFC4C3C2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  void _showForgotPasswordSheet(BuildContext context) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ForgotPasswordContactSheet(),
    );
  }

  Future<void> _launchWebUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Clipboard.setData(ClipboardData(text: url));
        ToastService.showInfo("Link copied: $url");
      }
    } catch (_) {
      Clipboard.setData(ClipboardData(text: url));
      ToastService.showInfo("Link copied: $url");
    }
  }
}

/// Enterprise Support Contact Information Bottom Sheet for Password Recovery
class _ForgotPasswordContactSheet extends StatelessWidget {
  const _ForgotPasswordContactSheet();

  static const String supportPhone = "+919499740227";
  static const String supportPhoneDisplay = "+91 94997 40227";
  static const String supportWhatsApp = "919499740227";
  static const String supportEmail = "contact@eresto.in";

  Future<void> _launchCall() async {
    final uri = Uri.parse("tel:$supportPhone");
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Clipboard.setData(const ClipboardData(text: supportPhone));
        ToastService.showInfo("Support number copied: $supportPhoneDisplay");
      }
    } catch (_) {
      Clipboard.setData(const ClipboardData(text: supportPhone));
      ToastService.showInfo("Support number copied: $supportPhoneDisplay");
    }
  }

  Future<void> _launchWhatsApp() async {
    final msg = Uri.encodeComponent(
      "Hello eResto Support, I forgot my password and need assistance resetting my account.",
    );
    final uri = Uri.parse("https://wa.me/$supportWhatsApp?text=$msg");

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Clipboard.setData(const ClipboardData(text: supportPhoneDisplay));
        ToastService.showInfo("WhatsApp number copied: $supportPhoneDisplay");
      }
    } catch (e) {
      Clipboard.setData(const ClipboardData(text: supportPhoneDisplay));
      ToastService.showInfo("WhatsApp number copied: $supportPhoneDisplay");
    }
  }

  Future<void> _launchEmail() async {
    final uri = Uri.parse(
      "mailto:$supportEmail?subject=${Uri.encodeComponent("Forgot Password - eResto One")}&body=${Uri.encodeComponent("Hello eResto Support,\n\nI forgot my password and need assistance resetting my account.\n\nUsername / Restaurant Name: ")}",
    );
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Clipboard.setData(const ClipboardData(text: supportEmail));
        ToastService.showInfo("Support email copied: $supportEmail");
      }
    } catch (_) {
      Clipboard.setData(const ClipboardData(text: supportEmail));
      ToastService.showInfo("Support email copied: $supportEmail");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 14.h),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 38.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            // Header Row: Icon + Title + Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_reset_rounded,
                        color: AppColors.primary,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "Forgot Password?",
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20, color: Color(0xFF6B7280)),
                  onPressed: () => Navigator.pop(context),
                  splashRadius: 20.r,
                ),
              ],
            ),
            SizedBox(height: 6.h),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            SizedBox(height: 12.h),

            Text(
              "To protect your restaurant account and data security, password resets are processed directly by our support team. Connect via your preferred channel below:",
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: const Color(0xFF6B7280),
                height: 1.45,
              ),
            ),
            SizedBox(height: 16.h),

            // CARD 1: Support Helpline (Shared phone number for WhatsApp & Call)
            Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEEF2FF),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.support_agent_rounded,
                          color: AppColors.primary,
                          size: 22.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Support Helpline",
                              style: GoogleFonts.poppins(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                            Text(
                              supportPhoneDisplay,
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy_rounded, size: 18.sp, color: const Color(0xFF9CA3AF)),
                        onPressed: () {
                          Clipboard.setData(const ClipboardData(text: supportPhoneDisplay));
                          ToastService.showInfo("Number copied: $supportPhoneDisplay");
                        },
                        tooltip: "Copy Number",
                        splashRadius: 18.r,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      // WhatsApp Action Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _launchWhatsApp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          icon: const Icon(Icons.chat_bubble_rounded, size: 16, color: Colors.white),
                          label: Text(
                            "WhatsApp",
                            style: GoogleFonts.poppins(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      // Call Action Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _launchCall,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0284C7),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          icon: const Icon(Icons.phone_in_talk_rounded, size: 16, color: Colors.white),
                          label: Text(
                            "Call",
                            style: GoogleFonts.poppins(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // CARD 2: Email Support
            Container(
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(14.r),
                onTap: _launchEmail,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  child: Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3E8FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.mail_outline_rounded,
                          color: Color(0xFF7C3AED),
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Email Support",
                              style: GoogleFonts.poppins(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                            Text(
                              supportEmail,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          "Email",
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Back to Login Button
            SizedBox(
              width: double.infinity,
              height: 40.h,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                child: Text(
                  "Back to Login",
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
