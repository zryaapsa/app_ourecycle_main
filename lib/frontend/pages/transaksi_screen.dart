import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:app_ourecycle_main/backend/config/appwrite.dart';
import 'package:app_ourecycle_main/backend/controllers/transaction_controller.dart';
import 'package:app_ourecycle_main/backend/models/order_model.dart';
import 'package:app_ourecycle_main/frontend/pages/transaksi_detail_screen.dart';

class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  final controller = Get.put(TransactionController());
  bool isInProgress = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Center(
                child: Text(
                  'Transaksi',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Fungsi padding dan expanded untuk membuat tombol in progress dan completed tidak overflow
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => isInProgress = true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isInProgress
                                ? const Color(0xFF079119)
                                : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'In Progress',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => isInProgress = false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            !isInProgress
                                ? const Color(0xFF079119)
                                : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Completed',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final ordersToShow =
                    isInProgress
                        ? controller.inProgressOrders
                        : controller.completedOrders;

                return RefreshIndicator(
                  onRefresh: () => controller.fetchOrders(),
                  child:
                      ordersToShow.isEmpty
                          ? Center(
                            child: ListView(
                              children: const [
                                SizedBox(height: 150),
                                Center(
                                  child: Text(
                                    'Tidak ada transaksi di kategori ini.',
                                  ),
                                ),
                              ],
                            ),
                          )
                          : ListView.builder(
                            itemCount: ordersToShow.length,
                            itemBuilder: (context, index) {
                              final order = ordersToShow[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => TransaksiDetailScreen(order: order),
                                  );
                                },
                                child: OrderItemCard(order: order),
                              );
                            },
                          ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// Fungsi ini tetap kita simpan untuk fallback jika tidak ada foto
String _getImageForCategory(String categoryName) {
  switch (categoryName.toLowerCase()) {
    case 'botol plastik':
      return 'assets/botol_plastik_icon.png';
    case 'kardus':
      return 'assets/kardus_icon.png';
    case 'kaleng':
      return 'assets/kaleng_icon.png';
    default:
      return 'assets/ourecycle.png';
  }
}

class OrderItemCard extends StatelessWidget {
  final OrderModel order;

  const OrderItemCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'dd MMMM yyyy, HH:mm',
    ).format(order.scheduledAt);
    final formattedPrice = 'Rp${order.totalPrice.toStringAsFixed(0)}';

    // <-- KONDISI PENENTU GAMBAR DIMULAI DI SINI -->
    bool hasPhoto = order.photoIds != null && order.photoIds!.isNotEmpty;

    return GestureDetector(
      onTap: () {
        Get.to(() => TransaksiDetailScreen(order: order));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:
                  hasPhoto
                      // <-- JIKA ADA FOTO, tampilkan dari Appwrite -->
                      ? Image.network(
                        Appwrite.getImageUrl(
                          Appwrite.bucketImagesTrash,
                          order.photoIds!.first,
                        ),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        loadingBuilder:
                            (context, child, progress) =>
                                progress == null
                                    ? child
                                    : const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.broken_image,
                              size: 80,
                              color: Colors.grey,
                            ),
                      )
                      // <-- JIKA TIDAK ADA FOTO, tampilkan dari assets -->
                      : Image.asset(
                        _getImageForCategory(order.wasteCategoryName),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/ourecycle.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pesanan #${order.id.substring(0, 8)}...',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('${order.wasteCategoryName} - ${order.weight} Kg'),
                  const SizedBox(height: 2.5),
                  Text(
                    formattedDate,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              formattedPrice,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
