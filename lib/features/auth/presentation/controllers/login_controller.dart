import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/errors/failures.dart';

import '../../../../core/services/app_update_service.dart';
import '../../../../core/services/device_service.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../data/datasources/login_sync_datasource.dart';
import '../../domain/models/v6_login_request.dart';
import '../../domain/repositories/auth_repository.dart';

/// Enterprise Login Controller managing V6 API authentication lifecycle
class LoginController extends GetxController {
  final AuthRepository _authRepository;
  final StorageService _storageService;
  final DeviceService _deviceService;
  final LoginSyncRepository? _loginSyncRepository;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordObscured = true.obs;
  final isRememberMe = true.obs;
  final isLoading = false.obs;
  final loadingMessage = "".obs;

  LoginController({
    required AuthRepository authRepository,
    required StorageService storageService,
    required DeviceService deviceService,
    LoginSyncRepository? loginSyncRepository,
  })  : _authRepository = authRepository,
        _storageService = storageService,
        _deviceService = deviceService,
        _loginSyncRepository = loginSyncRepository;

  @override
  void onInit() {
    super.onInit();
    // Pre-fill remembered username if saved (converted to uppercase)
    if (_storageService.userName.isNotEmpty) {
      usernameController.text = _storageService.userName.toUpperCase();
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final username = usernameController.text.trim().toUpperCase();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      HapticFeedback.heavyImpact();
      ToastService.showWarning("Please enter your username and password");
      return;
    }

    HapticFeedback.lightImpact();
    isLoading.value = true;
    loadingMessage.value = "Authenticating with Eresto One...";

    try {
      final request = V6LoginRequest(
        userName: username,
        password: password,
        productId: DeviceService.productId, // 9 for DigiMenu / Eresto One
        cv: DeviceService.appVersion,
        imei: _deviceService.deviceId,
        loginFrom: DeviceService.loginFrom, // 1 = Mobile
        tsf: 1,
      );

      final result = await _authRepository.login(request);

      result.fold(
        (failure) {
          HapticFeedback.heavyImpact();
          String? detail;
          if (failure is ServerFailure) {
            if (failure.details != null) {
              detail = failure.details is String
                  ? failure.details
                  : const JsonEncoder.withIndent('  ').convert(failure.details);
            } else if (failure.statusCode != null) {
              detail = "HTTP Status Code: ${failure.statusCode}";
            }
          }
          ToastService.showError(failure.message, techDetail: detail);
        },
        (response) {
          // 1. Success (status == 1)
          if (response.isSuccess) {
            HapticFeedback.mediumImpact();

            // Verify restaurant has DigiMenu module authorization (module '1')
            if (!_storageService.hasDigiMenuAccess) {
              ToastService.showWarning(
                "Restaurant account does not have permission for the DigiMenu module.",
              );
            }

            final displayName = response.data!.shortName.isNotEmpty
                ? response.data!.shortName
                : response.data!.userName;

            // Background sync of restaurant master data (kitchen, sales, instructions, templates)
            _loginSyncRepository?.syncIfNeeded(force: true);

            ToastService.showSuccess("Welcome to Eresto One, $displayName!");
            Get.offAllNamed('/dashboard');
            return;
          }

          // 2. Forced App Upgrade Required
          if (response.isForceUpgrade) {
            HapticFeedback.heavyImpact();
            AppDialog.showUpdate(
              title: "App Update Required",
              message: response.message,
              buttonText: "Update Now",
              versionTag: "Latest Version",
              isForceUpgrade: true,
              onUpdate: () {
                AppUpdateService.openPlayStore();
              },
            );
            return;
          }

          // 3. Forced Password Change (status == 9)
          if (response.isPasswordChangeRequired) {
            HapticFeedback.heavyImpact();
            ToastService.showWarning(response.message);
            return;
          }

          // 4. Validation Errors (HTTP 404 with field maps)
          if (response.validationErrors != null && response.validationErrors!.isNotEmpty) {
            HapticFeedback.heavyImpact();
            final firstError = response.validationErrors!.values.first.first;
            ToastService.showError(firstError);
            return;
          }

          // 5. Standard Error from Server
          HapticFeedback.heavyImpact();
          final detail = response.formattedErrorDetail.isNotEmpty
              ? response.formattedErrorDetail
              : null;
          ToastService.showError(
            response.displayErrorMessage,
            techDetail: detail,
          );
        },
      );
    } catch (e, stackTrace) {
      HapticFeedback.heavyImpact();
      ToastService.showError("Unexpected login error: $e", techDetail: stackTrace.toString());
    } finally {
      isLoading.value = false;
      loadingMessage.value = "";
    }
  }
}
