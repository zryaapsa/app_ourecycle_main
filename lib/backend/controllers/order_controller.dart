import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_ourecycle_main/backend/config/app_route.dart';
import 'package:app_ourecycle_main/backend/config/appwrite.dart';
import 'package:app_ourecycle_main/backend/controllers/transaction_controller.dart';
import 'package:app_ourecycle_main/backend/datasources/location_datasource.dart';
import 'package:app_ourecycle_main/backend/datasources/order_datasource.dart';
import 'package:app_ourecycle_main/backend/models/dropoff_location_model.dart';
import 'package:app_ourecycle_main/backend/models/user_model.dart';
import 'package:app_ourecycle_main/backend/services/session_service.dart';

class OrderController extends GetxController {
  // --- State untuk GetBuilder (Manual) ---
  final selectedImages = <XFile>[]; // Dihapus .obs

  // --- State untuk Obx (Reaktif) ---
  final selectedWeight = Rxn<String>();
  final selectedDate = Rxn<DateTime>();
  final selectedTime = Rxn<TimeOfDay>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  final _isLoadingLocations = true.obs;
  bool get isLoadingLocations => _isLoadingLocations.value;
  final dropOffLocations = <DropOffLocationModel>[].obs;
  final selectedLocation = Rxn<DropOffLocationModel>();

  // --- Controller & Picker ---
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchDropOffLocations();
  }

  void selectWeight(String weight) => selectedWeight.value = weight;

  Future<void> pickImage() async {
    if (selectedImages.length >= 3) {
      Get.snackbar(
        'Error',
        'Anda hanya dapat mengunggah maksimal 3 foto.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFFFE5E5), // merah pastel
        colorText: Colors.red.shade900,
        snackStyle: SnackStyle.FLOATING,
        margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
        borderRadius: 12,
        borderWidth: 1,
        borderColor: Colors.red.shade200,
        boxShadows: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        duration: const Duration(seconds: 3),
        icon: Icon(Icons.error_outline, color: Colors.red.shade900),
      );
      return;
    }
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImages.add(image);
      update(); // Perintahkan GetBuilder untuk update
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
    update(); // Perintahkan GetBuilder untuk update
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) selectedDate.value = picked;
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) selectedTime.value = picked;
  }

  Future<void> fetchDropOffLocations() async {
    _isLoadingLocations.value = true;
    dropOffLocations.value = await LocationDatasource.getDropOffLocations();
    _isLoadingLocations.value = false;
  }

  void selectLocation(DropOffLocationModel? location) =>
      selectedLocation.value = location;

  Future<List<String>> _uploadImages() async {
    List<String> imageIds = [];
    for (var image in selectedImages) {
      try {
        final file = await Appwrite.storage.createFile(
          bucketId: Appwrite.bucketImagesTrash,
          fileId: ID.unique(),
          file:
              kIsWeb
                  ? InputFile.fromBytes(
                    bytes: await image.readAsBytes(),
                    filename: image.name,
                  )
                  : InputFile.fromPath(path: image.path, filename: image.name),
        );
        imageIds.add(file.$id);
      } catch (e) {
        Get.snackbar(
          'Error',
          'Gagal mengunggah gambar: ${image.name}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFFFE5E5), // merah pastel
          colorText: Colors.red.shade900,
          snackStyle: SnackStyle.FLOATING,
          margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
          borderRadius: 12,
          borderWidth: 1,
          borderColor: Colors.red.shade200,
          boxShadows: [
            BoxShadow(
              color: Colors.red.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
          duration: const Duration(seconds: 3),
          icon: Icon(Icons.error_outline, color: Colors.red.shade900),
        );
      }
    }
    return imageIds;
  }

  void nofillFromProfile() async {
    // Ambil data pengguna dari sesi lokal
    UserModel? currentUser = await SessionService.getUser();
    if (currentUser != null) {
      // Isi text controller dengan data dari profil
      phoneController.text = currentUser.phone ?? '';
      
      Get.snackbar('Info', 'Data No.Telp telah diisi dari profil Anda.');
    } else {
      Get.snackbar('Error', 'No.Telp belum diisi.');
    }
  }
  void addressfillFromProfile() async {
    // Ambil data pengguna dari sesi lokal
    UserModel? currentUser = await SessionService.getUser();
    if (currentUser != null) {
      // Isi text controller dengan data dari profil
      
      addressController.text = currentUser.address ?? '';
      Get.snackbar('Info', 'Data Alamat telah diisi dari profil Anda.');
    } else {
      Get.snackbar('Error', 'Alamat belum diisi.');
    }
  }


  void processOrder(
    BuildContext context, {
    required String wasteCategoryName,
    required double pricePerKg,
    required String orderType,
  }) async {
    if (selectedWeight.value == null ||
        selectedDate.value == null ||
        selectedTime.value == null ||
        phoneController.text.isEmpty ||
        selectedImages.isEmpty) {
      Get.snackbar(
        'Error',
        'Semua informasi wajib diisi, termasuk minimal 1 foto.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFFFE5E5), // merah pastel
        colorText: Colors.red.shade900,
        snackStyle: SnackStyle.FLOATING,
        margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
        borderRadius: 12,
        borderWidth: 1,
        borderColor: Colors.red.shade200,
        boxShadows: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        duration: const Duration(seconds: 3),
        icon: Icon(Icons.error_outline, color: Colors.red.shade900),
      );
      return;
    }
    String finalAddress;
    if (orderType == 'PickOff') {
      if (addressController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Alamat tidak boleh kosong',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFFFE5E5), // merah pastel
          colorText: Colors.red.shade900,
          snackStyle: SnackStyle.FLOATING,
          margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
          borderRadius: 12,
          borderWidth: 1,
          borderColor: Colors.red.shade200,
          boxShadows: [
            BoxShadow(
              color: Colors.red.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
          duration: const Duration(seconds: 3),
          icon: Icon(Icons.error_outline, color: Colors.red.shade900),
        );
        return;
      }
      finalAddress = addressController.text;
    } else {
      if (selectedLocation.value == null) {
        Get.snackbar(
          'Error',
          'Lokasi penjemputan tidak boleh kosong',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFFFE5E5), // merah pastel
          colorText: Colors.red.shade900,
          snackStyle: SnackStyle.FLOATING,
          margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
          borderRadius: 12,
          borderWidth: 1,
          borderColor: Colors.red.shade200,
          boxShadows: [
            BoxShadow(
              color: Colors.red.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
          duration: const Duration(seconds: 3),
          icon: Icon(Icons.error_outline, color: Colors.red.shade900),
        );
        return;
      }
      finalAddress = selectedLocation.value!.address;
    }

    _isLoading.value = true;
    UserModel? currentUser = await SessionService.getUser();
    if (currentUser == null || currentUser.id == null) {
      Get.snackbar(
        'Error',
        'Gagal mendapatkan data pengguna. Silakan login ulang.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFFFE5E5), // merah pastel
        colorText: Colors.red.shade900,
        snackStyle: SnackStyle.FLOATING,
        margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
        borderRadius: 12,
        borderWidth: 1,
        borderColor: Colors.red.shade200,
        boxShadows: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        duration: const Duration(seconds: 3),
        icon: Icon(Icons.error_outline, color: Colors.red.shade900),
      );
      _isLoading.value = false;
      return;
    }

    final List<String> uploadedImageIds = await _uploadImages();

    final scheduledAt = DateTime(
      selectedDate.value!.year,
      selectedDate.value!.month,
      selectedDate.value!.day,
      selectedTime.value!.hour,
      selectedTime.value!.minute,
    );

    final result = await OrderDatasource.createOrder(
      userId: currentUser.id!,
      userName: currentUser.name ?? 'Nama tidak ada',
      wasteCategoryName: wasteCategoryName,
      weight: double.parse(selectedWeight.value!),
      orderType: orderType,
      address: finalAddress,
      phoneNumber: phoneController.text,
      scheduledAt: scheduledAt,
      totalPrice: double.parse(selectedWeight.value!) * pricePerKg,
      taxAmount: (double.parse(selectedWeight.value!) * pricePerKg) * 0.11,
      photoIds: uploadedImageIds,
    );

    _isLoading.value = false;

    result.fold(
      (errorMessage) {
        Get.snackbar(
          'Error',
          'Gagal membuat pesanan',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFFFE5E5), // merah pastel
          colorText: Colors.red.shade900,
          snackStyle: SnackStyle.FLOATING,
          margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
          borderRadius: 12,
          borderWidth: 1,
          borderColor: Colors.red.shade200,
          boxShadows: [
            BoxShadow(
              color: Colors.red.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
          duration: const Duration(seconds: 3),
          icon: Icon(Icons.error_outline, color: Colors.red.shade900),
        );
      },
      (success) {
        Get.snackbar(
          'Berhasil',
          'Pesanan berhasil dibuat',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFE6F4EA), // hijau pastel
          colorText: Colors.green.shade900,
          snackStyle: SnackStyle.FLOATING,
          margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
          borderRadius: 12,
          borderWidth: 1,
          borderColor: Colors.green.shade200,
          boxShadows: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
          duration: const Duration(seconds: 3),
          icon: Icon(Icons.check_circle_outline, color: Colors.green.shade900),
        );

        if (Get.isRegistered<TransactionController>()) {
          final transactionController = Get.find<TransactionController>();
          transactionController.fetchOrders();
        }

        Get.offAllNamed(AppRoute.dashboard.name);
      },
    );
  }

  @override
  void onClose() {
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
