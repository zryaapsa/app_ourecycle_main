// frontend/pages/transaksi_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:app_ourecycle_main/backend/config/appwrite.dart';
import 'package:app_ourecycle_main/backend/controllers/transaction_controller.dart';
import 'package:app_ourecycle_main/backend/models/order_model.dart';

class TransaksiDetailScreen extends StatelessWidget {
  final OrderModel order;
  const TransaksiDetailScreen({super.key, required this.order});

  // Helper untuk mendapatkan warna dan teks status
  Map<String, dynamic> _getStatusInfo(String status) {
    switch (status) {
      case 'in-progress':
        return {'color': Colors.blue.shade700, 'text': 'In Progress'};
      case 'pending-cancellation':
        return {'color': Colors.orange.shade700, 'text': 'Menunggu Pembatalan'};
      case 'cancelled':
        return {'color': Colors.red.shade700, 'text': 'Dibatalkan'};
      case 'completed':
        return {'color': Colors.green.shade700, 'text': 'Selesai'};
      default:
        return {'color': Colors.grey, 'text': status.toUpperCase()};
    }
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan Get.find() untuk mendapatkan controller yang sudah ada
    final controller = Get.find<TransactionController>();
    final statusInfo = _getStatusInfo(order.status);
    final statusColor = statusInfo['color'] as Color;
    final statusText = statusInfo['text'] as String;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Berikan fungsi expanded agar status order tidak overflow
                      Expanded(
                        child: Text(
                          'ID Pesanan: #${order.id.substring(0, 8)}...',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Chip(
                        label: Text(
                          statusText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        backgroundColor: statusColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    order.wasteCategoryName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          if (order.photoIds != null && order.photoIds!.isNotEmpty)
            _buildDetailCard(
              title: 'Foto Sampah',
              children: [
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: order.photoIds!.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final photoId = order.photoIds![index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          Appwrite.getImageUrl(
                            Appwrite.bucketImagesTrash,
                            photoId,
                          ),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          loadingBuilder:
                              (context, child, progress) =>
                                  progress == null
                                      ? child
                                      : const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                          errorBuilder:
                              (context, error, stackTrace) => const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 50,
                              ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

          if (order.photoIds != null && order.photoIds!.isNotEmpty)
            const SizedBox(height: 16),

          _buildDetailCard(
            title: 'Detail Pesanan',
            children: [
              _buildInfoRow(Icons.line_weight, 'Berat', '${order.weight} Kg'),
              _buildInfoRow(
                Icons.delivery_dining,
                'Tipe Pesanan',
                order.orderType,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailCard(
            title: 'Informasi Pengantaran/Penjemputan',
            children: [
              _buildInfoRow(
                Icons.calendar_today,
                'Jadwal',
                DateFormat(
                  'EEEE, dd MMMM yyyy, HH:mm',
                ).format(order.scheduledAt),
              ),
              _buildInfoRow(Icons.location_on, 'Alamat', order.address),
              _buildInfoRow(Icons.phone, 'No. Telepon', order.phoneNumber),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailCard(
            title: 'Rincian Pendapatan',
            children: [
              _buildInfoRow(
                Icons.receipt_long,
                'Subtotal',
                'Rp${(order.totalPrice - order.taxAmount).toStringAsFixed(0)}',
              ),
              _buildInfoRow(
                Icons.request_quote,
                'Biaya Aplikasi',
                'Rp${order.taxAmount.toStringAsFixed(0)}',
              ),
              const Divider(thickness: 1, height: 24),
              _buildInfoRow(
                Icons.paid,
                'Total Pendapatan',
                'Rp${order.totalPrice.toStringAsFixed(0)}',
                isTotal: true,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // --- TOMBOL BATALKAN TRANSAKSI ---
          // Tampilkan tombol hanya jika status pesanan 'in-progress'
          if (order.status == 'in-progress')
            Obx(
              () =>
                  controller.isActionLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Tampilkan dialog konfirmasi sebelum membatalkan
                            Get.dialog(
                              AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: Row(
                                  children: const [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.orange,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Konfirmasi Pembatalan',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                content: const Text(
                                  'Apakah Anda yakin ingin mengajukan pembatalan untuk pesanan ini?',
                                  style: TextStyle(fontSize: 15),
                                ),
                                actionsPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                actionsAlignment:
                                    MainAxisAlignment.spaceBetween,
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.grey[700],
                                    ),
                                    child: const Text('Tidak'),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      Get.back(); // Tutup dialog
                                      Get.back(); // Tutup detail transaksi (kembali ke TransaksiScreen)
                                      await controller.requestCancellation(
                                        order.id,
                                      );
                                      // Tampilkan snackbar sukses
                                      Get.snackbar(
                                        'Berhasil',
                                        'Pengajuan pembatalan telah dikirim',
                                        snackPosition: SnackPosition.TOP,
                                        backgroundColor: const Color(
                                          0xFFE6F4EA,
                                        ), // hijau pastel
                                        colorText: Colors.green.shade900,
                                        snackStyle: SnackStyle.FLOATING,
                                        margin: const EdgeInsets.only(
                                          top: 20,
                                          left: 16,
                                          right: 16,
                                        ),
                                        borderRadius: 12,
                                        borderWidth: 1,
                                        borderColor: Colors.green.shade200,
                                        boxShadows: [
                                          BoxShadow(
                                            color: Colors.green.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                        duration: const Duration(seconds: 3),
                                        icon: Icon(
                                          Icons.check_circle_outline,
                                          color: Colors.green.shade900,
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.cancel_outlined,
                                      size: 18,
                                    ),
                                    label: const Text('Ya, Ajukan'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red.shade600,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Batalkan Transaksi',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
            ),
        ],
      ),
    );
  }

  // Widget helper untuk membuat kartu detail
  Widget _buildDetailCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (children.isNotEmpty) const Divider(),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  // Widget helper untuk membuat baris info dengan ikon
  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green.shade700, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label, style: TextStyle(color: Colors.grey.shade700)),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                fontSize: isTotal ? 18 : 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
