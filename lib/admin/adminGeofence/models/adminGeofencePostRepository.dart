import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'adminGeofenceModel.dart';

class AdminGeoFenceRepository {
  Future<void> postGeoFenceData(List<AdminGeoFenceModel> geoFenceDataList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? corporateId = prefs.getString('corporate_id');

    if (corporateId == null) {
      print('Corporate ID not found in shared preferences');
      return;
    }

    final String baseUrl = 'http://62.171.184.216:9595/api/admin/location/setgeofence?CorporateId=$corporateId';

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    try {
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
    } catch (e) {
      // Request error
      print('Error posting GeoFence data: $e');
    }
  }
}
