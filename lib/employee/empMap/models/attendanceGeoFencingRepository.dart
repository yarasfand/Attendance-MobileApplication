import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'attendanceGeoFencingModel.dart';

class GeoFenceRepository {
  final String area;
  GeoFenceRepository(this.area);



  Future<void> postData(GeofenceModel geoFenceModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String corporateId = prefs.getString("corporate_id") ?? "ptsoffice";
    final String baseUrl =
        "http://62.171.184.216:9595/api/employee/location/AddGeoPunch?CorporateId=$corporateId&Area";
    print("${baseUrl}=$area");
    final apiUrl = "${baseUrl}=$area";

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
