import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Impor GetX
import 'package:app_ourecycle_main/backend/controllers/order_controller.dart'; // Impor controller
import 'custom_form_field.dart';

class DeliveryInfoWidget extends StatelessWidget {
  final String sectionTitle;
  final TextEditingController phoneController;
  final TextEditingController addressController;

  const DeliveryInfoWidget({
    super.key,
    required this.sectionTitle,
    required this.phoneController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    // Cari controller yang sudah ada di memori
    final OrderController controller = Get.find<OrderController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        CustomFormField(
          controller: phoneController,
          labelText: "Nomor Telepon",
          hintText: "Masukkan No. Telp",
          keyboardType: TextInputType.phone,
          labelRightButtonText: "Gunakan dari Profil",
          // Panggil fungsi fillFromProfile saat tombol ditekan
          onLabelRightButtonPressed: () => controller.nofillFromProfile(),
        ),
        const SizedBox(height: 20),
        CustomFormField(
          controller: addressController,
          labelText: "Alamat",
          hintText: "Masukkan Alamat Lengkap",
          maxLines: 3,
          labelRightButtonText: "Gunakan dari Profil",
          // Panggil fungsi yang sama untuk mengisi alamat
          onLabelRightButtonPressed: () => controller.addressfillFromProfile(),
        ),
      ],
    );
  }
}