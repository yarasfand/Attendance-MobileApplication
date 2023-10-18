import 'dart:convert';
import 'package:http/http.dart' as http;

import 'geofenceGetlatLongmodel.dart';

class GetLatLongRepo{

  final String baseUrl = "http://62.171.184.216:9595/api/employee/location/locationdetail?CorporateId=ptsoffice&employeeId=3";

  Future<getLatLong?> fetchData() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return getLatLong.fromJson(data);
      } else {
        // Handle the response when it's not successful
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      // Handle any network or other errors
      throw Exception('An error occurred: $e');
    }
  }

}