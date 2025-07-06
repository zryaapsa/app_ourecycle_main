import 'package:app_ourecycle_main/backend/config/snackbar.dart'; // <-- 1. Impor AppSnackbar
import 'package:app_ourecycle_main/backend/datasources/user_datasource.dart';
import 'package:app_ourecycle_main/frontend/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  // Controllers untuk text fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  void execute(BuildContext context) async {
    // Validasi baru
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      AppSnackbar.showError(title: 'Error', message: 'Semua kolom wajib diisi.'); // <-- Diubah
      return;
    }
    if (!GetUtils.isEmail(emailController.text)) {
      AppSnackbar.showError(title: 'Error', message: 'Format email tidak valid.'); // <-- Diubah
      return;
    }
    if (passwordController.text.length < 8) {
      AppSnackbar.showError(title: 'Error', message: 'Password minimal 8 karakter.'); // <-- Diubah
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      AppSnackbar.showError(title: 'Error', message: 'Konfirmasi password tidak cocok.'); // <-- Diubah
      return;
    }

    _isLoading.value = true;

    // Panggil datasource dengan parameter yang lebih sedikit
    final result = await UserDatasource.signUp(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
    );

    _isLoading.value = false;

    result.fold(
      (errorMessage) {
        AppSnackbar.showError(title: 'Gagal', message: errorMessage); // <-- Diubah
      },
      (success) {
        AppSnackbar.showSuccess(title: 'Berhasil', message: 'Pendaftaran berhasil! Silakan login.'); // <-- Diubah
        // Kembali ke halaman login setelah berhasil
        Get.off(() => const LoginScreen());
      },
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}