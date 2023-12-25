import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Sqlite/sqlite_helper.dart';
import 'attendanceGeoFencingModel.dart';

class GeoFenceRepository {
  final String area;

  GeoFenceRepository(this.area);

  Future<void> postData(GeofenceModel geoFenceModel) async {
    try {
      final dbHelper = EmployeeDatabaseHelper.instance;
      final firstEmployee = await dbHelper.getFirstEmployee();

      if (firstEmployee != null) {
        String corporateId = firstEmployee['corporate_id'] as String;
        final String baseUrl =
            "http://62.171.184.216:9595/api/employee/location/AddGeoPunch?CorporateId=$corporateId&Area";
        print("${baseUrl}=$area");
        final apiUrl = "${baseUrl}=$area";

        final headers = {
          'Content-Type': 'application/json',
        };

        final requestBody = jsonEncode(geoFenceModel.toJson());

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
      } else {

        print("No employee data found in the database.");
      }
    } catch (e) {
      print('Error making API request: $e');
      throw Exception("Failed to make the API request.");
    }
  }
}
