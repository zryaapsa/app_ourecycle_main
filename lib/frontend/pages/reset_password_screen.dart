import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_ourecycle_main/backend/controllers/reset_password_controller.dart';
import 'package:app_ourecycle_main/frontend/widgets/text_field_login.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String userId;
  final String secret;

  const ResetPasswordScreen({
    super.key,
    required this.userId,
    required this.secret,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ResetPasswordController(userId: userId, secret: secret),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Atur Password Baru')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Masukkan password baru Anda di bawah ini.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Obx(
              () => TextFieldLogin(
                controller: controller.passwordController,
                hintText: 'Password Baru',
                obscureText: controller.obscurePassword.value,
                prefixIcon: Icons.lock_outline,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscurePassword.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => TextFieldLogin(
                controller: controller.confirmPasswordController,
                hintText: 'Konfirmasi Password Baru',
                obscureText: controller.obscureConfirmPassword.value,
                prefixIcon: Icons.lock_outline,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscureConfirmPassword.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: controller.toggleConfirmPasswordVisibility,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      controller.isLoading.value
                          ? null
                          : controller.confirmNewPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Simpan Password Baru',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
