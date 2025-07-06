import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_ourecycle_main/backend/config/app_route.dart';
import 'package:app_ourecycle_main/backend/config/appwrite.dart';

class ResetPasswordController extends GetxController {
  final String userId;
  final String secret;

  ResetPasswordController({required this.userId, required this.secret});

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isLoading = false.obs;

  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPasswordVisibility() =>
      obscureConfirmPassword.value = !obscureConfirmPassword.value;

  Future<void> confirmNewPassword() async {
    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Semua field wajib diisi');
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Password tidak cocok');
      return;
    }
    if (passwordController.text.length < 8) {
      Get.snackbar('Error', 'Password minimal 8 karakter');
      return;
    }

    isLoading.value = true;
    try {
      await Appwrite.account.updateRecovery(
        userId: userId,
        secret: secret,
        password: passwordController.text,
      );

      isLoading.value = false;
      Get.defaultDialog(
        title: 'Berhasil',
        middleText:
            'Password Anda telah berhasil diubah. Silakan login kembali.',
        textConfirm: 'OK',
        confirmTextColor: Colors.white,
        onConfirm: () => Get.offAllNamed(AppRoute.login.name),
      );
    } on AppwriteException catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Gagal',
        e.message ?? 'Link tidak valid atau sudah kedaluwarsa.',
      );
    }
  }
}
