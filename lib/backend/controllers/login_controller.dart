import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_ourecycle_main/backend/config/app_route.dart';
import 'package:app_ourecycle_main/backend/config/appwrite.dart';
import 'package:app_ourecycle_main/backend/datasources/user_datasource.dart';
import 'package:app_ourecycle_main/backend/services/session_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  Future<void> execute(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Format email tidak valid',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFFFE5E5), // merah pastel
        colorText: Colors.red.shade900,
        snackStyle: SnackStyle.FLOATING,
        margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
        borderRadius: 12,
        borderWidth: 1,
        borderColor: Colors.red.shade200,
        boxShadows: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        duration: const Duration(seconds: 3),
        icon: Icon(Icons.error_outline, color: Colors.red.shade900),
      );
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
        Get.snackbar(
          'Login Gagal',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      (user) async {
        await SessionService.saveUser(user);
        Get.offAllNamed(AppRoute.dashboard.name);
      },
    );
  }

  // --- FUNGSI BARU UNTUK LUPA PASSWORD ---
  void showForgotPasswordDialog(BuildContext context) {
    final recoveryEmailController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.lock_reset, color: Colors.green[700]),
            const SizedBox(width: 8),
            Text(
              'Lupa Password',
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Masukkan email Anda untuk menerima link pemulihan password.',
              style: TextStyle(color: Colors.grey[800]),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: recoveryEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.green[700]),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green[700]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green[200]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Colors.green[700],
                ),
              ),
              cursorColor: Colors.green[700],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
            style: TextButton.styleFrom(foregroundColor: Colors.green[700]),
          ),
          ElevatedButton(
            onPressed: () {
              if (recoveryEmailController.text.isEmail) {
                Get.back(); // Tutup dialog
                sendRecoveryEmail(recoveryEmailController.text);
              } else {
                Future.delayed(Duration(milliseconds: 300), () {
                  Get.snackbar(
                    'Error',
                    'Format email tidak valid',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: const Color(0xFFFFE5E5), // merah pastel
                    colorText: Colors.red.shade900,
                    snackStyle: SnackStyle.FLOATING,
                    margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
                    borderRadius: 12,
                    borderWidth: 1,
                    borderColor: Colors.red.shade200,
                    boxShadows: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                    duration: const Duration(seconds: 3),
                    icon: Icon(Icons.error_outline, color: Colors.red.shade900),
                  );
                });
              }
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Kirim', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> sendRecoveryEmail(String email) async {
    isLoading.value = true;
    try {
      // PENTING: URL ini adalah placeholder. Lihat penjelasan di Bagian 2.
      const String recoveryUrl = 'http://localhost/reset';

      await Appwrite.account.createRecovery(email: email, url: recoveryUrl);

      isLoading.value = false;
      Get.snackbar(
        'Berhasil',
        'Link pemulihan telah dikirim ke email Anda. Silakan periksa inbox/spam.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } on AppwriteException catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.message ?? 'Gagal mengirim email pemulihan');
    }
  }
}
