import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_ourecycle_main/backend/config/snackbar.dart'; // <-- 1. Impor AppSnackbar
import 'package:app_ourecycle_main/backend/datasources/user_datasource.dart';

class ChangePasswordController extends GetxController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isLoading = false.obs;

  void saveNewPassword() async {
    if (oldPasswordController.text.isEmpty || newPasswordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      AppSnackbar.showError(title: 'Error', message: 'Semua kolom wajib diisi.'); // <-- Diubah
      return;
    }
    if (newPasswordController.text.length < 8) {
      AppSnackbar.showError(title: 'Error', message: 'Password baru minimal 8 karakter.'); // <-- Diubah
      return;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      AppSnackbar.showError(title: 'Error', message: 'Konfirmasi password baru tidak cocok.'); // <-- Diubah
      return;
    }

    isLoading.value = true;
    final result = await UserDatasource.updatePassword(
      oldPassword: oldPasswordController.text,
      newPassword: newPasswordController.text,
    );
    isLoading.value = false;

    result.fold(
      (errorMessage) {
        AppSnackbar.showError(title: 'Gagal', message: errorMessage); // <-- Diubah
      },
      (success) {
        Get.back(); // Kembali ke halaman edit profil
        AppSnackbar.showSuccess(title: 'Berhasil', message: 'Password Anda telah berhasil diubah.'); // <-- Diubah
      },
    );
  }
}