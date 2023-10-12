import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/adminGeofenceModel.dart';

class AdminGeoFenceRepository {
  final String baseUrl = 'http://62.171.184.216:9595/api/admin/location/setgeofence?CorporateId=ptsoffice';

  Future<void> setGeoFence(List<AdminGeoFenceModel> data) async {
    try {
      final List<Map<String, dynamic>> jsonDataList = data.map((model) => model.toJson()).toList();

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(jsonDataList),
      );

      if (response.statusCode == 200) {
        print('Geo-fence data successfully posted');
        print(response.body);
      } else {
        print('Failed to post Geo-fence data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error posting Geo-fence data: $e');
    }
  }
}
