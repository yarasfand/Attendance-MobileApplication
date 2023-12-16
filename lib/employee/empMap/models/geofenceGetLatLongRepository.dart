import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/constants/globalObjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'geofenceGetlatLongmodel.dart';

class GetLatLongRepo{

  Future<getLatLong?> fetchData() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String corporateId = sharedPref.getString('corporate_id') ?? 'ptsoffice';
    int? empId = sharedPref.getInt('employee_id');

    try {
      final response = await http.get(Uri.parse(
        "http://62.171.184.216:9595/api/employee/location/locationdetail?CorporateId=$corporateId&employeeId=${empId}",
      ));

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