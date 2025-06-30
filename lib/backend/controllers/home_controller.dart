import 'package:get/get.dart';
import 'package:app_ourecycle_main/backend/datasources/waste_datasource.dart';
import 'package:app_ourecycle_main/backend/models/user_model.dart';
import 'package:app_ourecycle_main/backend/models/waste_category_model.dart';
import 'package:app_ourecycle_main/backend/services/session_service.dart';

class HomeController extends GetxController {
  // --- STATE MANAGEMENT ---
  final userName = 'User'.obs;
  final wasteCategories = <WasteCategoryModel>[].obs;
  final isLoadingCategories = true.obs;

  // --- LIFECYCLE METHOD ---
  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  // --- FUNGSI ---
  Future<void> loadAllData() async {
    // Jalankan kedua fungsi secara bersamaan untuk efisiensi
    await Future.wait([_loadUserData(), loadWasteCategories()]);
  }

  Future<void> _loadUserData() async {
    UserModel? user = await SessionService.getUser();
    if (user != null) {
      userName.value = user.name ?? 'User';
    }
  }

  Future<void> loadWasteCategories() async {
    isLoadingCategories.value = true;
    var categories = await WasteDatasource.getWasteCategories();
    wasteCategories.value = categories;
    isLoadingCategories.value = false;
  }
}
