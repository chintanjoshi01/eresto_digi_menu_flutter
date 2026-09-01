import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/brand_progress_indicator.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final isTablet = shortestSide >= 550;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Center(
          child: Container(
            width: isTablet ? 900.w : 340.w,
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
                )
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
                                // Brand Logo
                                SvgPicture.asset(
                                  'assets/images/eresto-pos-logo.svg',
                                  height: 48.h,
                                  placeholderBuilder: (context) => Text(
                                    "eResto",
                                    style: GoogleFonts.nunito(
                                      color: AppColors.primary,
                                      fontSize: 32.sp,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  "Manage Resto From Mobile",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.nunito(
                                    color: Colors.grey.shade600,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
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
                                SvgPicture.asset(
                                  'assets/images/eresto-pos-logo.svg',
                                  height: 40.h,
                                  placeholderBuilder: (context) => Text(
                                    "eResto",
                                    style: GoogleFonts.nunito(
                                      color: AppColors.primary,
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  "Digital Menu Management",
                                  style: AppTypography.bodySmall,
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
    );
  }

  List<Widget> _buildAnimatedForm(BuildContext context) {
    final List<Widget> items = [
      Text(
        "Login",
        style: GoogleFonts.nunito(
          fontSize: 26.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF353534),
        ),
      ),
      SizedBox(height: 6.h),
      Text(
        "Please Enter Your Credentials to Login",
        style: GoogleFonts.nunito(
          color: const Color(0xFF6A6968),
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 28.h),

      // Username / Email input field
      _buildTextField(
        controller: controller.usernameController,
        hint: "User Name / Email",
        icon: Icons.person_outline_rounded,
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
            style: GoogleFonts.nunito(
              fontSize: 14.sp,
              color: const Color(0xFF353534),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      SizedBox(height: 24.h),

      // Login Button incorporating the BrandProgressIndicator loader from Edge
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
                      style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            )),
      ),
      SizedBox(height: 20.h),

      // Options footer links
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {},
            child: Text(
              "Forgot Your Password?",
              style: GoogleFonts.nunito(
                color: AppColors.primary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Text(
              "Register",
              style: GoogleFonts.nunito(
                color: AppColors.primary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
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
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? obscureText : false,
      style: GoogleFonts.nunito(fontSize: 15.sp, color: const Color(0xFF353534)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.nunito(color: const Color(0xFF9E9E9D), fontSize: 14.sp),
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
}
