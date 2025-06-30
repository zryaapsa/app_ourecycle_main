import 'package:appwrite/appwrite.dart';
import 'package:dartz/dartz.dart';
import 'package:app_ourecycle_main/backend/config/appwrite.dart';
import 'package:app_ourecycle_main/backend/models/user_model.dart';

class UserDatasource {
  // ... (fungsi signUp dan signIn Anda tidak berubah)
  static Future<Either<String, UserModel>> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
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
          'phone': phone,
          'address': address,
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

  // --- FUNGSI BARU UNTUK UPDATE PROFIL ---
  static Future<void> updateUserProfile({
    required String userId,
    required String name,
    required String phone,
    required String address,
  }) async {
    // Update nama di sistem Auth Appwrite
    await Appwrite.account.updateName(name: name);
    // Update data di database Users
    await Appwrite.databases.updateDocument(
      databaseId: Appwrite.databaseId,
      collectionId: Appwrite.collectionUsers,
      documentId: userId,
      data: {'name': name, 'phone': phone, 'address': address},
    );
  }
}
