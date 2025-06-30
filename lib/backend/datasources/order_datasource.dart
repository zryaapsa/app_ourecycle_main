// backend/datasources/order_datasource.dart

import 'package:appwrite/appwrite.dart';
import 'package:dartz/dartz.dart';
import 'package:app_ourecycle_main/backend/config/appwrite.dart';
import 'package:app_ourecycle_main/backend/models/order_model.dart';
import 'package:app_ourecycle_main/backend/models/user_model.dart';
import 'package:app_ourecycle_main/backend/services/session_service.dart';

class OrderDatasource {
  static Future<Either<String, void>> createOrder({
    required String userId,
    required String userName,
    required String wasteCategoryName,
    required double weight,
    required String orderType,
    required String address,
    required String phoneNumber,
    required DateTime scheduledAt,
    required double totalPrice,
    required double taxAmount,
    List<String>? photoIds,
  }) async {
    try {
      final Map<String, dynamic> dataToSend = {
        'userId': userId,
        'userName': userName,
        'wasteCategoryName': wasteCategoryName,
        'weight': weight,
        'orderType': orderType,
        'address': address,
        'phoneNumber': phoneNumber,
        'scheduledAt': scheduledAt.toIso8601String(),
        'totalPrice': totalPrice,
        'taxAmount': taxAmount,
        'status': 'in-progress',
        'photoIds': photoIds,
      };
      await Appwrite.databases.createDocument(
        databaseId: Appwrite.databaseId,
        collectionId: Appwrite.collectionOrders,
        documentId: ID.unique(),
        data: dataToSend,
      );
      return const Right(null);
    } on AppwriteException catch (e) {
      return Left(e.message ?? 'Terjadi kesalahan saat membuat pesanan.');
    } catch (e) {
      return Left('Terjadi kesalahan yang tidak diketahui: $e');
    }
  }

  static Future<Either<String, List<OrderModel>>> getOrders() async {
    try {
      UserModel? currentUser = await SessionService.getUser();
      if (currentUser == null || currentUser.id == null) {
        return const Left(
          'Gagal mendapatkan data pengguna. Silakan login ulang.',
        );
      }

      final result = await Appwrite.databases.listDocuments(
        databaseId: Appwrite.databaseId,
        collectionId: Appwrite.collectionOrders,
        queries: [
          Query.equal('userId', [currentUser.id!]),
        ],
      );

      List<OrderModel> orders =
          result.documents.map((doc) => OrderModel.fromJson(doc.data)).toList();

      return Right(orders);
    } on AppwriteException catch (e) {
      return Left(e.message ?? 'Gagal mengambil riwayat pesanan.');
    } catch (e) {
      return Left('Terjadi kesalahan tidak diketahui: $e');
    }
  }

  // --- FUNGSI BARU UNTUK UPDATE STATUS ---
  static Future<Either<String, void>> updateOrderStatus(
    String orderId,
    String newStatus,
  ) async {
    try {
      await Appwrite.databases.updateDocument(
        databaseId: Appwrite.databaseId,
        collectionId: Appwrite.collectionOrders,
        documentId: orderId,
        data: {'status': newStatus},
      );
      return const Right(null);
    } on AppwriteException catch (e) {
      return Left(e.message ?? 'Gagal memperbarui status pesanan.');
    } catch (e) {
      return Left('Terjadi kesalahan tidak diketahui: $e');
    }
  }
}
