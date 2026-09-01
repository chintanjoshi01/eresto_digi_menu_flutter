import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepository;
  final StorageService _storageService;

  final userName = 'Chintan Joshi'.obs;
  final userEmail = 'admin@eresto.in'.obs;
  final userRole = 'Restaurant Owner / Admin'.obs;
  final restaurantName = 'Trulyy Tadkaaz'.obs;
  final restaurantUrl = 'menu.eresto.in/trulyy-tadkaaz'.obs;
  final posStationId = 'POS-MOTO-G54'.obs;
  final isLoggingOut = false.obs;

  ProfileController(this._authRepository, this._storageService);

  void logout() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out from eResto POS station?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC1272D),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Get.back();
              await _performLogout();
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout() async {
    isLoggingOut.value = true;
    try {
      await _authRepository.logout();
      await _storageService.clear();
      ToastService.showSuccess("Logged out successfully");
      Get.offAllNamed('/login');
    } catch (e) {
      ToastService.showError("Failed to logout: $e");
    } finally {
      isLoggingOut.value = false;
    }
  }
}
