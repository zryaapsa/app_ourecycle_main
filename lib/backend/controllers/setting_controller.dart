import 'package:get/get.dart';
import 'package:app_ourecycle_main/backend/models/user_model.dart';
import 'package:app_ourecycle_main/backend/services/session_service.dart';

class SettingController extends GetxController {
  final userName = 'Loading...'.obs;
  final userEmail = 'Loading...'.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    UserModel? user = await SessionService.getUser();
    if (user != null) {
      userName.value = user.name ?? 'Nama Tidak Ditemukan';
      userEmail.value = user.email ?? 'Email Tidak Ditemukan';
    }
  }
}
