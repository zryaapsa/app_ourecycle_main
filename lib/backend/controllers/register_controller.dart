// backend/controllers/register_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_ourecycle_main/backend/datasources/user_datasource.dart';

class RegisterController extends GetxController {
  // Controllers untuk text fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();

  // State untuk loading
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // Fungsi yang dipanggil dari UI
  void execute(BuildContext context) async {
    // Validasi
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Semua field wajib diisi',
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
    if (!GetUtils.isEmail(emailController.text)) {
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
    if (passwordController.text.length < 8) {
      Get.snackbar(
        'Error',
        'Password minimal 8 karakter',
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

    _isLoading.value = true; // Mulai loading

    // Panggil datasource
    final result = await UserDatasource.signUp(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      phone: phoneController.text,
      address: addressController.text,
    );

    _isLoading.value = false; // Selesai loading

    result.fold(
      (errorMessage) {
        // Gagal, tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(errorMessage)),
        );
      },
      (success) {
        // Sukses, tampilkan pesan berhasil dan kembali
        Get.snackbar(
          'Berhasil',
          'Pendaftaran berhasil! Silakan login.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFE6F4EA), // hijau pastel
          colorText: Colors.green.shade900,
          snackStyle: SnackStyle.FLOATING,
          margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
          borderRadius: 12,
          borderWidth: 1,
          borderColor: Colors.green.shade200,
          boxShadows: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
          duration: const Duration(seconds: 3),
          icon: Icon(Icons.check_circle_outline, color: Colors.green.shade900),
        );
        Navigator.of(context).pop();
      },
    );
  }

  @override
  void onClose() {
    // Membersihkan controller saat halaman ditutup
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
