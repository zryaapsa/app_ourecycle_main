// backend/models/order_model.dart

class OrderModel {
  final String id;
  final String userId;
  final String? userName;
  final String wasteCategoryName;
  final double weight;
  final String orderType;
  final String address;
  final String phoneNumber;
  final DateTime scheduledAt;
  final double totalPrice;
  final double taxAmount;
  final String status;
  // <-- PERUBAHAN: dari String? photoId menjadi List<String>? photoIds
  final List<String>? photoIds;

  OrderModel({
    required this.id,
    required this.userId,
    this.userName,
    required this.wasteCategoryName,
    required this.weight,
    required this.orderType,
    required this.address,
    required this.phoneNumber,
    required this.scheduledAt,
    required this.totalPrice,
    required this.taxAmount,
    required this.status,
    this.photoIds, // <-- PERUBAHAN
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['\$id'],
      userId: json['userId'],
      userName: json['userName'],
      wasteCategoryName: json['wasteCategoryName'],
      weight: (json['weight'] ?? 0.0).toDouble(),
      orderType: json['orderType'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      scheduledAt: DateTime.parse(json['scheduledAt']),
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      taxAmount: (json['taxAmount'] ?? 0.0).toDouble(),
      status: json['status'],
      // <-- PERUBAHAN: Mengonversi List<dynamic> dari JSON menjadi List<String>
      photoIds: json['photoIds'] != null ? List<String>.from(json['photoIds']) : null,
    );
  }
}