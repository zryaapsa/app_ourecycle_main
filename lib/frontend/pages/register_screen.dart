import 'package:app_ourecycle_main/backend/controllers/register_controller.dart';
import 'package:app_ourecycle_main/frontend/pages/login_screen.dart';
import 'package:app_ourecycle_main/frontend/widgets/text_field_register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final controller = Get.put(RegisterController());
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/ourecycle-logo.png', height: 100),
                const SizedBox(height: 20),
                const Text('Silakan buat akun anda', textAlign: TextAlign.center),
                const SizedBox(height: 30),

                TextFieldRegister(
                  controller: controller.nameController,
                  hintText: 'Nama Lengkap',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 16),

                TextFieldRegister(
                  controller: controller.emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),

                TextFieldRegister(
                  controller: controller.passwordController,
                  hintText: 'Password',
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                const SizedBox(height: 16),

                TextFieldRegister(
                  controller: controller.confirmPasswordController, // <-- PERBAIKAN DI SINI
                  hintText: 'Konfirmasi Password',
                  obscureText: _obscureConfirmPassword,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: _toggleConfirmPasswordVisibility,
                  ),
                ),
                const SizedBox(height: 30),

                Obx(() {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isLoading ? null : () => controller.execute(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: controller.isLoading
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                          : const Text('Daftar', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  );
                }),

                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Sudah punya akun? '),
                    GestureDetector(
                      onTap: () {
                        Get.off(() => const LoginScreen());
                      },
                      child: const Text('Masuk disini', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}