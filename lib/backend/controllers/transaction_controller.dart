// backend/controllers/transaction_controller.dart

import 'package:get/get.dart';
import 'package:app_ourecycle_main/backend/datasources/order_datasource.dart';
import 'package:app_ourecycle_main/backend/models/order_model.dart';
import 'package:flutter/material.dart';

class TransactionController extends GetxController {
  // --- STATE MANAGEMENT ---

  // State untuk menandai proses loading utama halaman
  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;

  // State untuk menandai proses loading aksi (seperti pembatalan)
  final _isActionLoading = false.obs;
  bool get isActionLoading => _isActionLoading.value;

  // Variabel reaktif untuk menampung semua pesanan
  final _allOrders = <OrderModel>[].obs;

  // --- COMPUTED PROPERTIES (GETTERS) ---
  // Menampilkan pesanan yang masih berjalan atau menunggu pembatalan
  List<OrderModel> get inProgressOrders =>
      _allOrders
          .where(
            (order) =>
                order.status == 'in-progress' ||
                order.status == 'pending-cancellation',
          )
          .toList();

  // Menampilkan pesanan yang sudah selesai atau dibatalkan
  List<OrderModel> get completedOrders =>
      _allOrders
          .where(
            (order) =>
                order.status == 'completed' || order.status == 'cancelled',
          )
          .toList();

  // --- LIFECYCLE ---
  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  // --- FUNGSI ---
  Future<void> fetchOrders() async {
    _isLoading.value = true;
    final result = await OrderDatasource.getOrders();
    _isLoading.value = false;

    result.fold(
      (errorMessage) {
        Get.snackbar('Error', 'Gagal memuat riwayat transaksi: $errorMessage');
      },
      (orderList) {
        // Urutkan dari yang paling baru berdasarkan tanggal jadwal
        orderList.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
        _allOrders.value = orderList;
      },
    );
  }

  // FUNGSI BARU UNTUK MENGAJUKAN PEMBATALAN
  Future<void> requestCancellation(String orderId) async {
    _isActionLoading.value = true;
    // Mengubah status menjadi 'pending-cancellation'
    final result = await OrderDatasource.updateOrderStatus(
      orderId,
      'pending-cancellation',
    );
    _isActionLoading.value = false;

    result.fold(
      (errorMessage) {
        Get.snackbar(
          'Gagal',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      (success) {
        Get.snackbar(
          'Berhasil',
          'Pengajuan pembatalan telah dikirim.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        // Refresh data transaksi untuk menampilkan status terbaru
        fetchOrders();
        // Kembali ke halaman sebelumnya
        Get.back();
      },
    );
  }
}
