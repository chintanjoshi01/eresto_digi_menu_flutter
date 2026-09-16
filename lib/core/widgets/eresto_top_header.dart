import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

/// Enterprise Top App Header Bar for eResto Digital Menu POS.
///
/// Implements [PreferredSizeWidget] using standard Flutter [AppBar] semantics
/// guaranteeing zero RenderFlex overflow across all device screens and notch sizes.
class ErestoTopHeader extends StatelessWidget implements PreferredSizeWidget {
  /// Dynamic subtitle text (e.g. restaurant name or section subtitle).
  final String subtitle;

  /// Optional leading widget (e.g. BackButton on sub-pages).
  final Widget? leading;

  /// Optional custom action widgets on the right.
  final List<Widget>? actions;

  /// Whether to show the notification bell button.
  final bool showNotification;

  /// Whether to show the user profile avatar button.
  final bool showProfile;

  /// Callback when the notification icon is tapped.
  final VoidCallback? onNotificationTap;

  /// Callback when the profile icon is tapped. Defaults to navigating to `/profile`.
  final VoidCallback? onProfileTap;

  /// Header background color.
  final Color backgroundColor;

  const ErestoTopHeader({
    super.key,
    this.subtitle = "Trulyy Tadkaaz",
    this.leading,
    this.actions,
    this.showNotification = true,
    this.showProfile = true,
    this.onNotificationTap,
    this.onProfileTap,
    this.backgroundColor = Colors.white,
  });

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 16.w,
      toolbarHeight: 56.h,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: 8.w),
          ],
          AnimatedHeaderLogo(
            height: 30.h,
          ),
        ],
      ),
      actions: [
        if (actions != null) ...actions!,
        if (showNotification) ...[
          Center(
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                if (onNotificationTap != null) onNotificationTap!();
              },
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                width: 32.w,
                height: 32.h,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 18.sp,
                  color: const Color(0xFF374151),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
        if (showProfile) ...[
          Center(
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                if (onProfileTap != null) {
                  onProfileTap!();
                } else {
                  Get.toNamed('/profile');
                }
              },
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                width: 32.w,
                height: 32.h,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ],
    );
  }
}

/// Animated Header Logo component that performs a sleek, premium entrance animation
/// on app launch (Smooth Fade + Spring Scale + Specular Light Gleam) and provides
/// subtle tactile haptic bounce feedback on tap.
class AnimatedHeaderLogo extends StatefulWidget {
  final double height;
  final VoidCallback? onTap;

  const AnimatedHeaderLogo({
    super.key,
    this.height = 30,
    this.onTap,
  });

  /// Tracks if the intro entrance animation has played in this app session
  static bool hasAnimatedOnce = false;

  @override
  State<AnimatedHeaderLogo> createState() => _AnimatedHeaderLogoState();
}

class _AnimatedHeaderLogoState extends State<AnimatedHeaderLogo>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  late final AnimationController _sheenController;
  late final Animation<double> _sheenAnimation;

  late final AnimationController _tapController;
  late final Animation<double> _tapScaleAnimation;

  bool _isSheenActive = false;

  @override
  void initState() {
    super.initState();

    // 1. Entrance Controller (Scale & Fade)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    // 2. Sheen Gleam Controller (Single light sweep)
    _sheenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _sheenAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _sheenController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _sheenController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() => _isSheenActive = false);
        }
      }
    });

    // 3. Tap Micro-Interaction Controller
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );

    _tapScaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(
        parent: _tapController,
        curve: Curves.easeInOutCubic,
      ),
    );

    // Trigger entrance if first launch of session
    if (!AnimatedHeaderLogo.hasAnimatedOnce) {
      AnimatedHeaderLogo.hasAnimatedOnce = true;
      _entranceController.forward().then((_) {
        if (mounted) {
          setState(() => _isSheenActive = true);
          _sheenController.forward(from: 0.0);
        }
      });
    } else {
      // Already animated in this session, show directly
      _entranceController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _sheenController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    HapticFeedback.lightImpact();
    _tapController.forward();
  }

  void _onTapUp(TapUpDetails _) {
    _tapController.reverse();
    _triggerSheen();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _tapController.reverse();
  }

  void _triggerSheen() {
    if (!_sheenController.isAnimating && mounted) {
      setState(() => _isSheenActive = true);
      _sheenController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final logoImage = Image.asset(
      'assets/images/eresto-pos-logo.png',
      height: widget.height,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Text(
        "eResto",
        style: GoogleFonts.nunito(
          color: AppColors.primary,
          fontSize: 18.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: Listenable.merge([_entranceController, _tapController]),
        builder: (context, child) {
          final totalScale = _scaleAnimation.value * _tapScaleAnimation.value;
          return Opacity(
            opacity: _fadeAnimation.value.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: totalScale,
              alignment: Alignment.centerLeft,
              child: child,
            ),
          );
        },
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            logoImage,
            if (_isSheenActive)
              AnimatedBuilder(
                animation: _sheenAnimation,
                builder: (context, _) {
                  return ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (Rect bounds) {
                      final val = _sheenAnimation.value;
                      return LinearGradient(
                        begin: Alignment(val - 0.7, -0.4),
                        end: Alignment(val + 0.3, 0.4),
                        colors: [
                          Colors.white.withOpacity(0.0),
                          Colors.white.withOpacity(0.55),
                          Colors.white.withOpacity(0.0),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ).createShader(bounds);
                    },
                    child: logoImage,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

