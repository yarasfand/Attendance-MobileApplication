import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Sqlite/admin_sqliteHelper.dart';
import '../models/adminGeofenceModel.dart';

class AdminGeoFenceRepository {
  Future<void> postGeoFenceData(List<AdminGeoFenceModel> geoFenceDataList) async {
    try {
      // Retrieve corporate_id from SQLite table
      final adminDbHelper = AdminDatabaseHelper();
      final adminData = await adminDbHelper.getAdmins();
      if (adminData.isNotEmpty) {
        final String? corporateId = adminData.first['corporate_id'];

        if (corporateId == null) {
          print('Corporate ID is null in SQLite table');
          return;
        }

        final String baseUrl = 'http://62.171.184.216:9595/api/admin/location/setgeofence?CorporateId=$corporateId';

        final headers = <String, String>{
          'Content-Type': 'application/json',
        };

        final List<Map<String, dynamic>> jsonList = geoFenceDataList.map((model) => model.toJson()).toList();

        final response = await http.post(
          Uri.parse(baseUrl),
          headers: headers,
          body: jsonEncode(jsonList),
        );

        if (response.statusCode == 200) {
          // Request was successful
          print(response.body);
          print('GeoFence data posted successfully');
        } else {
          // Request failed
          print('Failed to post GeoFence data. Status code: ${response.statusCode}');
        }
      } else {
        print('No admin data found in the SQLite table');
      }
    } catch (e) {
      // Request error
      print('Error posting GeoFence data: $e');
    }
  }
}
