import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../auth/data/datasources/login_sync_datasource.dart';
import '../../../dashboard/presentation/controllers/menu_dashboard_controller.dart';

/// Enterprise Main Shell Controller managing tab state, smooth page transitions, and persistent navigation.
class MainShellController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxString restaurantName = "Trulyy Tadkaaz".obs;
  late final PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentIndex.value);
    _resolveRestaurantName();
  }

  @override
  void onReady() {
    super.onReady();
    // Cache-first background sync of master metadata (kitchen/sales cats, rate lists)
    if (Get.isRegistered<LoginSyncRepository>()) {
      Get.find<LoginSyncRepository>().syncIfNeeded(force: false);
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void _resolveRestaurantName() {
    if (Get.isRegistered<StorageService>()) {
      final storage = Get.find<StorageService>();
      if (storage.restoName.isNotEmpty) {
        restaurantName.value = storage.restoName;
        return;
      }
    }
    if (Get.isRegistered<MenuDashboardController>()) {
      final dashController = Get.find<MenuDashboardController>();
      final name = dashController.state?.restaurantName;
      if (name != null && name.isNotEmpty) {
        restaurantName.value = name;
      }
    }
  }

  void updateRestaurantName(String name) {
    if (name.isNotEmpty) {
      restaurantName.value = name;
    }
  }

  void changeTab(int index) {
    if (index >= 0 && index <= 3) {
      if (currentIndex.value != index) {
        currentIndex.value = index;
        if (pageController.hasClients) {
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
          );
        }
      }
    }
  }

  /// Handles Android system back button:
  /// Navigates to Dashboard tab if currently on another tab, otherwise allows exit.
  bool handleBackPress() {
    if (currentIndex.value != 0) {
      changeTab(0);
      return false;
    }
    return true;
  }
}
