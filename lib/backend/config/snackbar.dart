// lib/backend/config/snackbar.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void showSuccess({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade50,
      colorText: Colors.green.shade900,
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      borderWidth: 1,
      borderColor: Colors.green.shade200,
      boxShadows: [
        BoxShadow(
          color: Colors.green.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      duration: const Duration(seconds: 3),
      icon: Icon(Icons.check_circle_outline, color: Colors.green.shade900),
    );
  }

  static void showError({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade50,
      colorText: Colors.red.shade900,
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      borderWidth: 1,
      borderColor: Colors.red.shade200,
      boxShadows: [
        BoxShadow(
          color: Colors.red.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      duration: const Duration(seconds: 3),
      icon: Icon(Icons.error_outline, color: Colors.red.shade900),
    );
  }
}