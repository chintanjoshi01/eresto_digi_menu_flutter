import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/storage/storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Enterprise Animated Splash Screen for eResto DigiMenu.
///
/// Designed to seamlessly bridge the native Android 12+ Splash Screen API
/// (windowSplashScreenBackground #F9F9F9) with a fluid Flutter brand sequence.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _logoFadeAnimation;

  late final AnimationController _taglineController;
  late final Animation<double> _taglineFadeAnimation;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Set immersive status bar matching light background #F9F9F9
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.lightBackground,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    // 1. Logo Controller: Spring Scale & Fade
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOutBack,
      ),
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // 2. Tagline Controller: Staggered Appearance
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _taglineFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _taglineController,
        curve: Curves.easeOut,
      ),
    );

    // 3. Subtle Breathing Pulse for Plate Emblem
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.035).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );

    _playSequenceAndNavigate();

    // Enterprise Fail-Safe: Guarantee departure from splash within 1100ms
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (mounted) _navigateToNext();
    });
  }

  bool _navigated = false;

  void _navigateToNext() {
    if (_navigated) return;
    _navigated = true;
    try {
      final storageService = Get.find<StorageService>();
      final hasToken = storageService.isLoggedIn;
      Get.offNamed(hasToken ? '/main' : '/login');
    } catch (_) {
      Get.offNamed('/login');
    }
  }

  Future<void> _playSequenceAndNavigate() async {
    // Start Logo Entrance
    await Future.delayed(const Duration(milliseconds: 60));
    if (!mounted || _navigated) return;
    _logoController.forward();

    // Staggered Tagline Entrance
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted || _navigated) return;
    _taglineController.forward();

    // Fluid transition to destination
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted || _navigated) return;
    _navigateToNext();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _taglineController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _navigateToNext,
        child: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                // 1. Hero Animated App Logo (eresto DigiMenu)
                ScaleTransition(
                  scale: _logoScaleAnimation,
                  child: FadeTransition(
                    opacity: _logoFadeAnimation,
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) => Transform.scale(
                        scale: _pulseAnimation.value,
                        child: child,
                      ),
                      child: Image.asset(
                        'assets/images/eresto-pos-logo.png',
                        height: 64.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // 3. Animated Brand Taglines
                FadeTransition(
                  opacity: _taglineFadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        "Your Menu. More Possibilities.",
                        textAlign: TextAlign.center,
                        style: AppTypography.taglinePrimary.copyWith(
                          fontSize: 15.sp,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "SCAN • EXPLORE • ORDER • GROW",
                        textAlign: TextAlign.center,
                        style: AppTypography.taglineSequence.copyWith(
                          fontSize: 10.sp,
                          letterSpacing: 2.2,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 4),

                // Footer version / loading indicator
                FadeTransition(
                  opacity: _taglineFadeAnimation,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: const BoxDecoration(
                            color: AppColors.erestoRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "eResto Ecosystem v1.0",
                          style: AppTypography.caption.copyWith(
                            fontSize: 11.sp,
                            color: AppColors.coolGray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
