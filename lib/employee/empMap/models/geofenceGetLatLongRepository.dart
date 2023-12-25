import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/constants/globalObjects.dart';
import '../../../Sqlite/sqlite_helper.dart';
import 'geofenceGetlatLongmodel.dart';

class GetLatLongRepo {
  Future<getLatLong?> fetchData() async {
    try {
      final dbHelper = EmployeeDatabaseHelper.instance;
      final firstEmployee = await dbHelper.getFirstEmployee();

      if (firstEmployee != null) {
        String corporateId = firstEmployee['corporate_id'] as String;
        int? empId = firstEmployee['id'] as int;

        final response = await http.get(Uri.parse(
          "http://62.171.184.216:9595/api/employee/location/locationdetail?CorporateId=$corporateId&employeeId=$empId",
        ));

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          return getLatLong.fromJson(data);
        } else {
          // Handle the response when it's not successful
          throw Exception('Failed to fetch data');
        }
      } else {
        // Handle the case where no employee data is found
        // Set default values or throw an exception as needed
        print("No employee data found in the database.");
        return null;
      }
    } catch (e) {
      // Handle any network or other errors
      throw Exception('An error occurred: $e');
    }
  }
}
