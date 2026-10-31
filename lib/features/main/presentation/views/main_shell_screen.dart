import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/services/app_exit_service.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/eresto_top_header.dart';
import '../../../../core/widgets/keep_alive_wrapper.dart';
import '../../../dashboard/presentation/controllers/menu_dashboard_controller.dart';
import '../../../dashboard/presentation/views/dashboard_screen.dart';
import '../../../items/presentation/views/items_screen.dart';
import '../../../menu/presentation/views/menu_screen.dart';
import '../../../share/presentation/views/share_screen.dart';
import '../controllers/main_shell_controller.dart';

/// Enterprise Main Shell hosting persistent top header, bottom navigation bar,
/// and smooth animated PageView of the 4 primary app tabs with KeepAlive.
class MainShellScreen extends GetView<MainShellController> {
  const MainShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final shouldExit = controller.handleBackPress();
        if (shouldExit) {
          AppExitService.handleDoubleBackExit();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.h),
          child: Obx(
            () => ErestoTopHeader(
              subtitle: controller.restaurantName.value,
            ),
          ),
        ),
        body: PageView(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            KeepAliveWrapper(child: DashboardScreen(isEmbedded: true)),
            KeepAliveWrapper(child: ItemsScreen(isEmbedded: true)),
            KeepAliveWrapper(child: MenuScreen(isEmbedded: true)),
            KeepAliveWrapper(child: ShareScreen(isEmbedded: true)),
          ],
        ),
        bottomNavigationBar: Obx(
          () {
            final dash = Get.isRegistered<MenuDashboardController>()
                ? Get.find<MenuDashboardController>()
                : null;
            final isBlocked = dash != null &&
                (dash.isForceUpdateRequired.value || dash.isSubscriptionExpired.value);
            if (isBlocked) {
              return const SizedBox.shrink();
            }
            return AppBottomNav(
              currentIndex: controller.currentIndex.value,
              onTabSelected: controller.changeTab,
            );
          },
        ),
      ),
    );
  }
}
