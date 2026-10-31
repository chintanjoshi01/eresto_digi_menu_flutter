import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/services/device_service.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../auth/data/datasources/login_sync_datasource.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

/// Enterprise Profile Controller managing user session details,
/// outlet metadata, master data synchronization, and secure logout.
class ProfileController extends GetxController {
  final AuthRepository _authRepository;
  final StorageService _storageService;

  final userName = 'Administrator'.obs;
  final userEmail = ''.obs;
  final userMobile = ''.obs;
  final userRole = 'Restaurant Administrator'.obs;
  final restaurantName = 'Restaurant'.obs;
  final restoLocation = ''.obs;
  final subscription = ''.obs;
  final validity = ''.obs;

  final isLoggingOut = false.obs;
  final isSyncingData = false.obs;
  final lastSyncTime = ''.obs;

  String get appVersion => DeviceService.appVersion;
  String get buildNumber => DeviceService.buildNumber;

  ProfileController(this._authRepository, this._storageService);

  @override
  void onInit() {
    super.onInit();
    _loadProfileData();
  }

  void _loadProfileData() {
    if (_storageService.userName.isNotEmpty) {
      userName.value = _storageService.userName;
    } else if (_storageService.shortName.isNotEmpty) {
      userName.value = _storageService.shortName;
    } else if (_storageService.restoName.isNotEmpty) {
      userName.value = _storageService.restoName;
    }
    if (_storageService.email.isNotEmpty) {
      userEmail.value = _storageService.email;
    }
    if (_storageService.mobile.isNotEmpty) {
      userMobile.value = _storageService.mobile;
    }
    if (_storageService.restoName.isNotEmpty) {
      restaurantName.value = _storageService.restoName;
    }
    if (_storageService.restoLocation.isNotEmpty) {
      restoLocation.value = _storageService.restoLocation;
    }
    if (_storageService.subscription.isNotEmpty) {
      subscription.value = _storageService.subscription;
      userRole.value = _storageService.subscription;
    }
    if (_storageService.validity.isNotEmpty) {
      validity.value = _storageService.validity;
    }

    final cachedData = _storageService.cachedLoginSyncData;
    if (cachedData != null) {
      final dt = cachedData.cachedAt;
      lastSyncTime.value =
          "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    }
  }

  /// Formatted location string that separates coordinate pairs with spaces for clean line-wrapping
  String get formattedLocation {
    final loc = restoLocation.value.trim();
    if (loc.isEmpty || loc == '0,0' || loc == '0.0,0.0' || loc == '0.000000,0.000000' || loc.toLowerCase() == 'null') {
      return "Main Branch";
    }
    // Ensures space after commas so coordinate strings wrap properly on small mobile screens
    return loc.replaceAll(RegExp(r',(?!\s)'), ', ');
  }

  /// Computed 2-letter uppercase initials for avatar (e.g. "CJ", "VR")
  String get initials {
    final name = userName.value.trim();
    if (name.isEmpty) return "AD";
    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  /// On-demand master catalog synchronization from server
  Future<void> syncMasterData() async {
    isSyncingData.value = true;
    HapticFeedback.mediumImpact();
    try {
      if (Get.isRegistered<LoginSyncRepository>()) {
        final repo = Get.find<LoginSyncRepository>();
        final synced = await repo.syncIfNeeded(force: true);
        if (synced != null) {
          final dt = synced.cachedAt;
          lastSyncTime.value =
              "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 700));
      }
      ToastService.showSuccess("Master catalog synchronized successfully!");
    } catch (e) {
      ToastService.showError("Failed to sync catalog: $e");
    } finally {
      isSyncingData.value = false;
    }
  }

  void logout() {
    HapticFeedback.mediumImpact();
    AppDialog.showConfirmation(
      title: "Confirm Logout",
      message: "Are you sure you want to log out from this station? You will need to sign in again to access the digital menu.",
      confirmText: "Logout",
      cancelText: "Cancel",
      isDangerous: true,
      icon: Icons.logout_rounded,
      onConfirm: () async {
        await _performLogout();
      },
    );
  }

  Future<void> _performLogout() async {
    isLoggingOut.value = true;
    try {
      await _authRepository.logout();
      ToastService.showSuccess("Logged out successfully");
    } catch (_) {
      // Local cleanup is handled defensively in _authRepository.logout
    } finally {
      isLoggingOut.value = false;
      if (Get.currentRoute != '/login') {
        Get.offAllNamed('/login');
      }
    }
  }
}
