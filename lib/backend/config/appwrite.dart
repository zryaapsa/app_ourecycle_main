import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 

class Appwrite {

  static final String projectId = dotenv.env['APPWRITE_PROJECT_ID']!;
  static final String endpoint = dotenv.env['APPWRITE_ENDPOINT']!;
  static final String databaseId = dotenv.env['APPWRITE_DATABASE_ID']!;
  static final String collectionUsers = dotenv.env['APPWRITE_COLLECTION_USERS']!;
  static final String collectionWasteCategories = dotenv.env['APPWRITE_COLLECTION_WASTE_CATEGORIES']!;
  static final String collectionOrders = dotenv.env['APPWRITE_COLLECTION_ORDERS']!;
  static final String collectionDropOffLocations = dotenv.env['APPWRITE_COLLECTION_DROPOFF_LOCATIONS']!;
  static final String bucketImagesTrash = dotenv.env['APPWRITE_BUCKET_IMAGES_TRASH']!;

  static Client client = Client();
  static late Account account;
  static late Databases databases;
  static late Storage storage;

  static void init() {
    client
        .setEndpoint(endpoint)
        .setProject(projectId);

    account = Account(client);
    databases = Databases(client);
    storage = Storage(client);
  }


  static String getImageUrl(String bucketId, String fileId) {
    if (fileId.isEmpty) return '';
    return '$endpoint/storage/buckets/$bucketId/files/$fileId/view?project=$projectId';
  }
}