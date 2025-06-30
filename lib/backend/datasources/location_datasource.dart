// backend/datasources/location_datasource.dart
import 'package:app_ourecycle_main/backend/config/appwrite.dart';
import 'package:app_ourecycle_main/backend/models/dropoff_location_model.dart';

class LocationDatasource {
  static Future<List<DropOffLocationModel>> getDropOffLocations() async {
    try {
      final result = await Appwrite.databases.listDocuments(
        databaseId: Appwrite.databaseId,
        collectionId: Appwrite.collectionDropOffLocations,
      );
      return result.documents
          .map((doc) => DropOffLocationModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      print("Error fetching drop-off locations: $e");
      return [];
    }
  }
}
