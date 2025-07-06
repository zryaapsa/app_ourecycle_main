import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_ourecycle_main/backend/config/app_route.dart';
import 'package:app_ourecycle_main/backend/config/snackbar.dart'; // Impor AppSnackbar
import 'package:app_ourecycle_main/backend/datasources/user_datasource.dart';
import 'package:app_ourecycle_main/backend/services/session_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  Future<void> execute(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      // Ganti dengan AppSnackbar
      AppSnackbar.showError(title: 'Error', message: 'Email dan password wajib diisi.');
      return;
    }
    isLoading.value = true;
    final result = await UserDatasource.signIn(
      email: emailController.text,
      password: passwordController.text,
    );
    isLoading.value = false;

    result.fold(
      (errorMessage) {
        // Ganti dengan AppSnackbar
        AppSnackbar.showError(title: 'Login Gagal', message: errorMessage);
      },
      (user) async {
        await SessionService.saveUser(user);
        Get.offAllNamed(AppRoute.dashboard.name);
      },
    );
  }

  // --- FUNGSI LUPA PASSWORD ---
  void showForgotPasswordDialog(BuildContext context) {
    final recoveryEmailController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.lock_reset, color: Colors.green[700]),
            const SizedBox(width: 8),
            Text('Lupa Password', style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Masukkan email Anda untuk menerima link pemulihan password.'),
            const SizedBox(height: 16),
            TextField(
              controller: recoveryEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (recoveryEmailController.text.isEmail) {
                Get.back(); // Tutup dialog
                sendRecoveryEmail(recoveryEmailController.text);
              } else {
                // Ganti dengan AppSnackbar
                AppSnackbar.showError(title: 'Error', message: 'Format email tidak valid');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
            child: const Text('Kirim', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> sendRecoveryEmail(String email) async {
    isLoading.value = true;
    // Panggil datasource, bukan Appwrite langsung
    final result = await UserDatasource.createPasswordRecovery(email);
    isLoading.value = false;

    result.fold(
      (errorMessage) {
        // Ganti dengan AppSnackbar
        AppSnackbar.showError(title: 'Gagal', message: errorMessage);
      },
      (success) {
        // Ganti dengan AppSnackbar
        AppSnackbar.showSuccess(
          title: 'Berhasil',
          message: 'Link pemulihan telah dikirim ke email Anda. Silakan periksa inbox/spam.',
        );
      },
    );
  }
}