import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'attendanceGeoFencingModel.dart';

class GeoFenceRepository {
  final String corporateId;
  GeoFenceRepository(this.corporateId);

  final String baseUrl =
      "http://62.171.184.216:9595/api/employee/location/AddGeoPunch?CorporateId=ptsoffice&Area";

  Future<void> postData(GeofenceModel geoFenceModel) async {

    print("${baseUrl}=$corporateId");
    final apiUrl = "${baseUrl}=$corporateId";

    final headers = {
      'Content-Type': 'application/json',
    };

    final requestBody = jsonEncode(geoFenceModel.toJson());

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Request was successful
        print("Response submitted successfully!");
        print(response.body);
      } else {
        // Request failed, log status code and response content
        print(
            "Failed to fetch data from the API. Status code: ${response.statusCode}");
        print("Response content: ${response.body}");
        throw Exception("Failed to fetch data from the API.");
      }
    } catch (e) {
      print('Error making API request: $e');
      throw Exception("Failed to make the API request.");
    }
  }
}
