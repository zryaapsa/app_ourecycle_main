import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_ourecycle_main/backend/controllers/edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan GetX untuk membuat dan mengelola controller
    final controller = Get.put(EditProfileController());

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.green.shade800),
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.green.shade800),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      // Gunakan Obx untuk membuat seluruh body reaktif terhadap state loading
      body: Obx(() {
        // Tampilkan loading indicator di tengah layar jika sedang memuat data awal
        // Pengecekan 'nameController.text.isEmpty' memastikan loading hanya tampil saat pertama kali
        if (controller.isLoading.value &&
            controller.nameController.text.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Jika tidak loading, tampilkan form
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // --- Field Nama ---
              _buildTextField(
                context: context,
                label: 'Nama Lengkap',
                controller: controller.nameController,
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              // --- Field Email (Read Only) ---
              _buildTextField(
                context: context,
                label: 'Email',
                controller: controller.emailController,
                icon: Icons.email_outlined,
                isReadOnly: true,
              ),
              const SizedBox(height: 20),
              // --- Field No Telepon ---
              _buildTextField(
                context: context,
                label: 'No. Telepon',
                controller: controller.phoneController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              // --- Field Alamat ---
              _buildTextField(
                context: context,
                label: 'Alamat',
                controller: controller.addressController,
                icon: Icons.home_outlined,
                minLines: 1,
                maxLines: 5,
                keyboardType:
                    TextInputType
                        .multiline, // Agar interaktif menyesuaikan valuenya
              ),
              const SizedBox(height: 40),

              // --- Tombol Simpan ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // Tombol dinonaktifkan jika sedang loading
                  onPressed:
                      controller.isLoading.value
                          ? null
                          : () => controller.updateProfile(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  // Tampilan tombol berubah saat loading
                  child:
                      controller.isLoading.value
                          ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                          : const Text(
                            'Simpan Perubahan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Widget helper untuk membuat text field yang seragam
  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isReadOnly = false,
    int minLines = 1,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.green,
          selectionColor: Colors.green.withOpacity(0.3),
          selectionHandleColor: Colors.green,
        ),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: isReadOnly,
        minLines: minLines,
        maxLines: maxLines,
        keyboardType: keyboardType,
        cursorColor: Colors.green,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.green),
          prefixIcon: Icon(icon, color: Colors.grey.shade600),
          filled: isReadOnly,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 12.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green.shade400, width: 2.0),
          ),
        ),
      ),
    );
  }
}
