import 'dart:convert';
import 'package:http/http.dart' as http;

import 'adminGeofenceModel.dart';

class AdminGeoFenceRepository {
  final String baseUrl = 'http://62.171.184.216:9595/api/admin/location/setgeofence?CorporateId=ptsoffice';

  Future<void> postGeoFenceData(List<AdminGeoFenceModel> geoFenceDataList) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    try {
      // Convert the list of AdminGeoFenceModel to a list of JSON objects
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
