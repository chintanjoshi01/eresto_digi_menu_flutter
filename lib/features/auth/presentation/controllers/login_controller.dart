import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/storage/storage_service.dart';

class LoginController extends GetxController {
  final StorageService _storageService;

  final usernameController = TextEditingController(text: 'admin@eresto.in');
  final passwordController = TextEditingController(text: '123456');

  final isPasswordObscured = true.obs;
  final isRememberMe = true.obs;
  final isLoading = false.obs;

  LoginController(this._storageService);

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final email = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ToastService.showWarning("Please enter your credentials");
      return;
    }

    isLoading.value = true;

    // Simulate 1.2s demo authentication delay to showcase the BrandProgressIndicator
    await Future.delayed(const Duration(milliseconds: 1200));

    // Store demo session
    await _storageService.saveToken("demo_token_eresto_2026");
    await _storageService.saveRestoId(101);

    isLoading.value = false;

    ToastService.showSuccess("Welcome to eResto DigiMenu!");
    Get.offAllNamed('/dashboard');
  }
}
