import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_ourecycle_main/backend/config/app_route.dart';
import 'package:app_ourecycle_main/backend/controllers/setting_controller.dart';
import 'package:app_ourecycle_main/backend/services/session_service.dart';
import 'package:app_ourecycle_main/frontend/pages/setting/edit_profile_screen.dart';
import 'package:app_ourecycle_main/frontend/widgets/settings_item_widget.dart';
import 'package:app_ourecycle_main/frontend/pages/setting/kebijakan_privasi_screen.dart';
import 'package:app_ourecycle_main/frontend/pages/setting/panduan_screen.dart';
import 'package:app_ourecycle_main/frontend/pages/setting/pertanyaan_umum_screen.dart';
import 'package:app_ourecycle_main/frontend/pages/setting/syarat_dan_ketentuan_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingController());

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 40),
              child: Text(
                'Setting',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF079119),
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 50,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  Obx(
                    () => Text(
                      controller.userName.value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Obx(
                    () => Text(
                      controller.userEmail.value,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Navigasi dan tunggu hasilnya
                      final result = await Get.to(
                        () => const EditProfileScreen(),
                      );
                      // Jika ada hasil 'updated', muat ulang data pengguna
                      if (result == 'updated') {
                        controller.loadUserData();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF079119),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Column(
                children: [
                  SettingsItemWidget(
                    icon: Icons.book,
                    title: 'Panduan',
                    onTap: () => Get.to(() => const PanduanScreen()),
                    // nanti diarahin ke panduan_screen.dart
                  ),
                  SettingsItemWidget(
                    icon: Icons.description,
                    title: 'Syarat & Ketentuan',
                    onTap: () => Get.to(() => const SyaratDanKetentuanScreen()),
                  ),
                  SettingsItemWidget(
                    icon: Icons.privacy_tip,
                    title: 'Kebijakan Privasi',
                    onTap: () => Get.to(() => const KebijakanPrivasiScreen()),
                  ),
                  SettingsItemWidget(
                    icon: Icons.question_answer,
                    title: 'Pertanyaan Umum',
                    onTap: () => Get.to(() => const PertanyaanUmumScreen()),
                  ),
                  SettingsItemWidget(
                    icon: Icons.logout,
                    title: 'Logout',
                    iconColor: Colors.red,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: Row(
                                children: const [
                                  Icon(Icons.logout, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text(
                                    'Konfirmasi Logout',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              content: const Text(
                                'Apakah Anda yakin ingin keluar?',
                                style: TextStyle(fontSize: 15),
                              ),
                              actionsPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              actionsAlignment: MainAxisAlignment.spaceBetween,
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey[700],
                                  ),
                                  child: const Text('Batal'),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    await SessionService.clearUser();
                                    Get.offAllNamed(AppRoute.login.name);
                                  },
                                  icon: const Icon(Icons.logout, size: 18),
                                  label: const Text('Logout'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
