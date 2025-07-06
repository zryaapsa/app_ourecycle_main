import 'package:appwrite/appwrite.dart';
import 'package:dartz/dartz.dart';
import 'package:app_ourecycle_main/backend/config/appwrite.dart';
import 'package:app_ourecycle_main/backend/models/user_model.dart';

class UserDatasource {
  
  static Future<Either<String, UserModel>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await Appwrite.account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      final document = await Appwrite.databases.createDocument(
        databaseId: Appwrite.databaseId,
        collectionId: Appwrite.collectionUsers,
        documentId: user.$id,
        data: {
          'name': name,
          'email': email,
          // phone dan address dikosongkan, akan diisi nanti di profil
          'phone': '',
          'address': '',
        },
      );

      final data = document.data;
      data['\$id'] = document.$id;
      return Right(UserModel.fromJson(data));
    } on AppwriteException catch (e) {
      String message = 'Terjadi kesalahan, silakan coba lagi.';
      if (e.type == 'user_already_exists' || e.code == 409) {
        message = 'Email sudah terdaftar.';
      } else {
        message = e.message ?? message;
      }
      return Left(message);
    } catch (e) {
      return Left('Terjadi kesalahan yang tidak diketahui: $e');
    }
  }

  static Future<Either<String, UserModel>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final session = await Appwrite.account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      final document = await Appwrite.databases.getDocument(
        databaseId: Appwrite.databaseId,
        collectionId: Appwrite.collectionUsers,
        documentId: session.userId,
      );

      final data = document.data;
      data['\$id'] = document.$id;
      return Right(UserModel.fromJson(data));
    } on AppwriteException catch (e) {
      String message = 'Terjadi kesalahan, silakan coba lagi.';
      if (e.type == 'user_invalid_credentials' || e.code == 401) {
        message = 'Email atau password salah.';
      } else {
        message = e.message ?? message;
      }
      return Left(message);
    } catch (e) {
      return Left('Terjadi kesalahan yang tidak diketahui: $e');
    }
  }

  // --- FUNGSI BARU UNTUK MENGAMBIL PROFIL ---
  static Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final doc = await Appwrite.databases.getDocument(
      databaseId: Appwrite.databaseId,
      collectionId: Appwrite.collectionUsers,
      documentId: userId,
    );
    return doc.data;
  }

   // --- FUNGSI UPDATE PROFIL (DIPERBAIKI) ---
  static Future<Either<String, UserModel>> updateUserProfile({
    required String userId,
    required String name,
    required String phone,
    required String address,
  }) async {
    try {
      // 1. Update dokumen di database
      final response = await Appwrite.databases.updateDocument(
        databaseId: Appwrite.databaseId,
        collectionId: Appwrite.collectionUsers,
        documentId: userId,
        data: {
          'name': name,
          'phone': phone,
          'address': address,
        },
      );
      // 2. Update nama di sistem Auth Appwrite agar sinkron
      await Appwrite.account.updateName(name: name);
      // 3. Kembalikan data baru dalam bentuk UserModel
      return Right(UserModel.fromJson(response.data));
    } on AppwriteException catch (e) {
      return Left(e.message ?? 'Gagal memperbarui profil.');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  // --- FUNGSI BARU UNTUK UPDATE PASSWORD ---
  static Future<Either<String, void>> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await Appwrite.account.updatePassword(
        password: newPassword,
        oldPassword: oldPassword,
      );
      return const Right(null); // Tidak perlu mengembalikan data, cukup sinyal sukses
    } on AppwriteException catch (e) {
      // Pesan error spesifik untuk password salah
      if (e.code == 401 && e.message!.contains('Invalid `oldPassword`')) {
        return const Left('Password lama yang Anda masukkan salah.');
      }
      return Left(e.message ?? 'Gagal mengubah password.');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
  // ... (import dan fungsi lain tidak berubah)
  // ... (fungsi signUp, signIn, updateUserProfile, dll.)

  // FUNGSI BARU UNTUK LUPA PASSWORD
  static Future<Either<String, void>> createPasswordRecovery(String email) async {
    try {
      // URL ini harus Anda konfigurasikan di dashboard Appwrite
      // Arahkan ke halaman di aplikasi/website Anda untuk reset password
      // Untuk development, bisa gunakan URL placeholder
      const String recoveryUrl = 'http://localhost/reset-password';

      await Appwrite.account.createRecovery(
        email: email,
        url: recoveryUrl,
      );
      return const Right(null); // Sukses
    } on AppwriteException catch (e) {
      return Left(e.message ?? 'Gagal mengirim email pemulihan.');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
