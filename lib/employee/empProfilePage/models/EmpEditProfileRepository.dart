import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Sqlite/sqlite_helper.dart';

import 'empEditProfileModel.dart';

class EmpEditProfileRepository {
  final String apiUrl =
      "http://62.171.184.216:9595/api/employee/dashboard/updateprofile";

  Future<void> postData(EmpEditProfileModel empEditProfileModel) async {
    try {
      final dbHelper = EmployeeDatabaseHelper.instance;
      final firstEmployee = await dbHelper.getFirstEmployee();

      if (firstEmployee != null) {
        final String corporateId = firstEmployee['corporate_id'] as String;
        final headers = {
          'Content-Type': 'application/json', // Set the content type to JSON
        };

        final client = http.Client();

        final requestBody = jsonEncode(empEditProfileModel.toJson());

        final response = await client.post(
          Uri.parse('$apiUrl?CorporateId=$corporateId'),
          headers: headers,
          body: requestBody,
        );

        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

        if (response.statusCode == 200) {
          // Request was successful
          // You can handle the response as needed
          print("--------------------Response submitted Successfully------------------");
        } else {
          throw Exception(
              "Failed to post data to the API. Status code: ${response.statusCode}");
        }
      } else {
        // Handle the case where no employee data is found
        // Set default values or throw an exception as needed
        print("No employee data found in the database.");
      }
    } catch (e) {
      // Handle any database or network errors
      print("Error: $e");
      throw Exception("Failed to fetch data from the database or make API request.");
    }
  }
}
