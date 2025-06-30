import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:app_ourecycle_main/backend/controllers/order_controller.dart';
import 'package:app_ourecycle_main/backend/models/dropoff_location_model.dart';
import 'package:app_ourecycle_main/frontend/widgets/order_detail_widgets/curved_detail_header_clipper.dart';
import 'package:app_ourecycle_main/frontend/widgets/order_detail_widgets/detail_screen_header.dart';
import 'package:app_ourecycle_main/frontend/widgets/order_detail_widgets/plastik_info_card.dart';
import 'package:app_ourecycle_main/frontend/widgets/order_detail_widgets/weight_selector_widget.dart';

class OrderDetailDropOffScreen extends StatelessWidget {
  // --- PERUBAHAN 1: MENAMBAHKAN PARAMETER BARU ---
  final String wasteCategoryName;
  final double pricePerKg;
  final String imageId;
  final String? info;

  const OrderDetailDropOffScreen({
    super.key,
    required this.wasteCategoryName,
    required this.pricePerKg,
    required this.imageId,
    required this.info,
  });

  // --- PERUBAHAN 2: MENAMBAHKAN FUNGSI HELPER ICON ---
  IconData _getIconForCategory(String? categoryName) {
    switch (categoryName?.toLowerCase()) {
      case 'plastik':
        return Icons.local_drink;
      case 'kertas':
        return Icons.article;
      case 'kaca':
        return Icons.wine_bar;
      case 'logam':
        return Icons.build;
      default:
        return Icons.delete_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    final List<String> weights = ['5', '10', '15', '20', '25'];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.22,
              child: ClipPath(
                clipper: CurvedDetailHeaderClipper(),
                child: Container(color: Colors.green.shade400),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DetailScreenHeader(title: 'Order Detail (Drop Off)'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- PERUBAHAN 3: MENGGUNAKAN DATA DINAMIS PADA PlastikInfoCard ---
                        PlastikInfoCard(
                          imageId: imageId,
                          title: wasteCategoryName,
                          subtitle: info,
                          iconData: _getIconForCategory(wasteCategoryName),
                        ),
                        // --- TIDAK ADA PERUBAHAN APAPUN PADA UI DI BAWAH INI ---
                        const SizedBox(height: 24),
                        Obx(
                          () => WeightSelectorWidget(
                            weights: weights,
                            selectedWeight: controller.selectedWeight.value,
                            onWeightSelected:
                                (weight) => controller.selectWeight(weight),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Foto Sampah (Maks. 3)",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GetBuilder<OrderController>(
                          builder: (ctrl) {
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 3,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                              itemBuilder: (context, index) {
                                if (index < ctrl.selectedImages.length) {
                                  final imageFile = ctrl.selectedImages[index];
                                  return Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child:
                                            kIsWeb
                                                ? Image.network(
                                                  imageFile.path,
                                                  fit: BoxFit.cover,
                                                )
                                                : Image.file(
                                                  File(imageFile.path),
                                                  fit: BoxFit.cover,
                                                ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: InkWell(
                                          onTap: () => ctrl.removeImage(index),
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (index ==
                                    ctrl.selectedImages.length) {
                                  return InkWell(
                                    onTap: () => ctrl.pickImage(),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey.shade400,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.add_a_photo,
                                          color: Colors.grey,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Waktu Drop Off',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Tanggal Pengantaran',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => controller.selectDate(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(
                                      () => Text(
                                        controller.selectedDate.value != null
                                            ? DateFormat(
                                              'EEEE, dd MMMM yy',
                                            ).format(
                                              controller.selectedDate.value!,
                                            )
                                            : 'Pilih Tanggal Pengantaran',
                                        style: TextStyle(
                                          color:
                                              controller.selectedDate.value !=
                                                      null
                                                  ? Colors.black87
                                                  : Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Waktu Pengantaran',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => controller.selectTime(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(
                                      () => Text(
                                        controller.selectedTime.value?.format(
                                              context,
                                            ) ??
                                            'Pilih Waktu Pengantaran',
                                        style: TextStyle(
                                          color:
                                              controller.selectedTime.value !=
                                                      null
                                                  ? Colors.black87
                                                  : Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.access_time,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Pilih Lokasi Drop Off",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Obx(() {
                          if (controller.isLoadingLocations) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (controller.dropOffLocations.isEmpty) {
                            return const Text(
                              "Gagal memuat lokasi atau tidak ada lokasi tersedia.",
                            );
                          }
                          return DropdownButtonFormField<DropOffLocationModel>(
                            value: controller.selectedLocation.value,
                            hint: Text(
                              "Pilih Lokasi Tujuan",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            isExpanded: true,
                            items:
                                controller.dropOffLocations.map((location) {
                                  return DropdownMenuItem(
                                    value: location,
                                    child: Text(
                                      location.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (newValue) {
                              controller.selectLocation(newValue);
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.green,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 12),
                        Obx(() {
                          if (controller.selectedLocation.value != null) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Alamat: ${controller.selectedLocation.value!.address}",
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                        const SizedBox(height: 24),
                        const Text(
                          "Informasi Kontak",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(fontSize: 14),
                          cursorColor: Colors.green,
                          decoration: InputDecoration(
                            hintText: "Masukkan No. Telp Anda",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Colors.green,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 15.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Obx(
                () => ElevatedButton(
                  onPressed:
                      controller.isLoading
                          ? null
                          : () => controller.processOrder(
                            context,
                            wasteCategoryName: wasteCategoryName,
                            pricePerKg: pricePerKg,
                            orderType: 'DropOff',
                          ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child:
                      controller.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Proses Order',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
