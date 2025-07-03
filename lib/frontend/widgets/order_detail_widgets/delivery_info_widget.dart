import 'package:flutter/material.dart';
import 'custom_form_field.dart';

class DeliveryInfoWidget extends StatelessWidget {
  final String sectionTitle;
  final String phoneLabel;
  final String phoneHint;
  final TextEditingController phoneController;
  final String addressLabel;
  final String addressHint;
  final TextEditingController addressController;

  const DeliveryInfoWidget({
    super.key,
    required this.sectionTitle,
    required this.phoneLabel,
    required this.phoneHint,
    required this.phoneController,
    required this.addressLabel,
    required this.addressHint,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
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
          hintText: phoneHint,
          keyboardType: TextInputType.phone,
          cursorColor: Colors.green,
          labelRightButtonText: "Gunakan dari Profil",
          onLabelRightButtonPressed: () {
            // backend nanti disini
          },
        ),

        const SizedBox(height: 20),

        CustomFormField(
          controller: addressController,
          labelText: "Alamat",
          hintText: addressHint,
          maxLines: 3,
          cursorColor: Colors.green,
          labelRightButtonText: "Gunakan dari Profil",
          onLabelRightButtonPressed: () {
            // backend nanti
          },
        ),
      ],
    );
  }
}
