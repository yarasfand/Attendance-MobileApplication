import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/employee/empReportsOnDash/models/submission_model.dart';
import 'package:project/Sqlite/sqlite_helper.dart'; // Adjust the import path based on your project structure

class SubmissionRepository {
  final String baseUrl =
      "http://62.171.184.216:9595/api/employee/leave/addleaverequest";

  Future<String> getCorporateId() async {
    try {
      final dbHelper = EmployeeDatabaseHelper.instance;
      final firstEmployee = await dbHelper.getFirstEmployee();

      if (firstEmployee != null) {
        final String corporateId = firstEmployee['corporate_id'] as String;
        return corporateId;
      } else {
        // Handle the case where no employee data is found
        // Set default value or throw an exception as needed
        print("No employee data found in the database.");
        throw Exception("Corporate ID not found in the database");
      }
    } catch (e) {
      // Handle any database error
      print("Error fetching data from the database: $e");
      throw Exception("Failed to fetch corporate ID from the database");
    }
  }

  Future<void> postData(SubmissionModel submissionModel) async {
    try {
      final corporateId = await getCorporateId();
      final apiUrl = "$baseUrl?CorporateId=$corporateId";

      final headers = {
        'Content-Type': 'application/json', // Set the content type to JSON
      };

      final client = http.Client();

      final requestBody = jsonEncode(submissionModel.toJson());

      final response = await client.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Request was successful
        print(response.body);
        print("Response submitted");
      } else {
        // Request failed, log status code and response content
        print("Failed to fetch data from the API. Status code: ${response.statusCode}");
        print("Response content: ${response.body}");
        throw Exception("Failed to fetch data from the API.");
      }
    } catch (e) {
      // Handle any database or network errors
      print("Error: $e");
      throw Exception("Failed to fetch data from the database or make API request.");
    }
  }
}
