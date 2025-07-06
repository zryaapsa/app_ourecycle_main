import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_ourecycle_main/backend/config/snackbar.dart'; // <-- 1. Impor AppSnackbar
import 'package:app_ourecycle_main/backend/datasources/user_datasource.dart';
import 'package:app_ourecycle_main/backend/models/user_model.dart';
import 'package:app_ourecycle_main/backend/services/session_service.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final isLoading = false.obs;
  final profileImageUrl = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
  }

  void loadCurrentUser() async {
    isLoading.value = true;
    UserModel? currentUser = await SessionService.getUser();
    if (currentUser == null) {
      AppSnackbar.showError(title: 'Error', message: 'Sesi tidak ditemukan.'); // <-- Diubah
      isLoading.value = false;
      return;
    }

    nameController.text = currentUser.name ?? '';
    emailController.text = currentUser.email ?? '';
    phoneController.text = currentUser.phone ?? '';
    addressController.text = currentUser.address ?? '';
    isLoading.value = false;
  }

  void updateProfile() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty || addressController.text.isEmpty) {
      AppSnackbar.showError(title: 'Error', message: 'Semua field selain email wajib diisi.'); // <-- Diubah
      return;
    }

    isLoading.value = true;
    UserModel? currentUser = await SessionService.getUser();
    if (currentUser == null || currentUser.id == null) {
      AppSnackbar.showError(title: 'Error', message: 'Sesi tidak valid.'); 
      isLoading.value = false;
      return;
    }

    final result = await UserDatasource.updateUserProfile(
      userId: currentUser.id!,
      name: nameController.text,
      phone: phoneController.text,
      address: addressController.text,
    );
    
    result.fold(
      (errorMessage) {
        isLoading.value = false;
        AppSnackbar.showError(title: 'Gagal', message: errorMessage); 
      },
      (updatedUser) async {
        await SessionService.saveUser(updatedUser);
        isLoading.value = false;
        Get.back(result: 'updated');
        
        
        Get.defaultDialog(
          title: "Berhasil!",
          middleText: "Perubahan profil Anda telah berhasil disimpan.",
          textConfirm: "OK",
          onConfirm: () => Get.back(),
        );
      },
    );
  }
  @override
    void onClose() {
      nameController.dispose();
      emailController.dispose();
      phoneController.dispose();
      addressController.dispose();
      super.onClose();
    }
  // ... (onClose)
}

  

