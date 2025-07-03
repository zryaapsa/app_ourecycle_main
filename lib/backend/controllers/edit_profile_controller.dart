import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_ourecycle_main/backend/datasources/user_datasource.dart';
import 'package:app_ourecycle_main/backend/models/user_model.dart';
import 'package:app_ourecycle_main/backend/services/session_service.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final isLoading = false.obs;
  final profileImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadFreshUserData();
  }

  Future<void> loadFreshUserData() async {
    isLoading.value = true;
    UserModel? sessionUser = await SessionService.getUser();
    if (sessionUser == null || sessionUser.id == null) {
      Get.snackbar('Error', 'Sesi tidak ditemukan.');
      isLoading.value = false;
      return;
    }

    try {
      //  Perbaikan nama fungsi yang benar ---
      final profileData = await UserDatasource.getUserProfile(sessionUser.id!);

      nameController.text = profileData['name'] ?? '';
      emailController.text = profileData['email'] ?? '';
      phoneController.text = profileData['phone'] ?? '';
      addressController.text = profileData['address'] ?? '';
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data profil terbaru.');
      nameController.text = sessionUser.name ?? '';
      emailController.text = sessionUser.email ?? '';
      phoneController.text = sessionUser.phone ?? '';
      addressController.text = sessionUser.address ?? '';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty) {
      Get.snackbar('Error', 'Semua field selain email wajib diisi');
      return;
    }

    isLoading.value = true;
    UserModel? currentUser = await SessionService.getUser();
    if (currentUser == null || currentUser.id == null) {
      Get.snackbar('Error', 'Sesi tidak valid.');
      isLoading.value = false;
      return;
    }

    // Menggunakan try-catch karena fungsi tidak mengembalikan Either ---
    try {
      // Panggil fungsi update
      await UserDatasource.updateUserProfile(
        userId: currentUser.id!,
        name: nameController.text,
        phone: phoneController.text,
        address: addressController.text,
      );

      // Jika berhasil, lanjutkan logika di sini
      UserModel updatedUser = UserModel(
        id: currentUser.id,
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        address: addressController.text,
      );
      await SessionService.saveUser(updatedUser);

      isLoading.value = false; // Matikan loading sebelum menampilkan dialog

      // Tampilkan dialog sukses
      Get.defaultDialog(
        title: "",
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green[600], size: 60),
            const SizedBox(height: 16),
            Text(
              "Berhasil!",
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Perubahan profil Anda telah berhasil disimpan.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        radius: 16,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 24,
        ),
      ).then((_) {
        Get.back(result: 'updated');
      });
    } catch (e) {
      // Jika gagal, tangkap error di sini
      isLoading.value = false;
      Get.snackbar('Gagal Menyimpan', 'Terjadi kesalahan: $e');
    }
  }

  void updateProfileImage(String url) {
    profileImageUrl.value = url;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
