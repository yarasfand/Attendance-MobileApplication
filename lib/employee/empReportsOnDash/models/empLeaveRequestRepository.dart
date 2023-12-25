import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Sqlite/sqlite_helper.dart'; // Adjust the import path based on your project structure

import 'empLeaveRequestModel.dart';

class EmpLeaveRepository {
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

  Future<String> getLeaveTypeName(int leaveId) async {
    final corporateId = await getCorporateId();
    final apiUrl =
        "http://62.171.184.216:9595/api/employee/leave/getleavetype?CorporateId=$corporateId";

    final headers = {
      'Content-Type': 'application/json', // Set the content type to JSON
    };

    final client = http.Client();

    final response = await client.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      final leaveType = responseData.firstWhere(
            (element) => element['leaveTypeId'] == leaveId,
        orElse: () => null, // Return null if no match is found
      );
      if (leaveType != null) {
        final leaveTypeName = leaveType['ltypeName'] as String;
        return leaveTypeName;
      } else {
        return "Leave Type Not Found";
      }
    } else {
      throw Exception(
          "Failed to fetch leave type name from the API. Status code: ${response.statusCode}");
    }
  }

  Future<List<EmpLeaveModel>> getData() async {
    try {
      final corporateId = await getCorporateId();
      final apiUrl =
          "http://62.171.184.216:9595/api/employee/leave/getleavetype?CorporateId=$corporateId";

      final headers = {
        'Content-Type': 'application/json', // Set the content type to JSON
      };

      final client = http.Client();

      final response = await client.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<EmpLeaveModel> leaveTypes =
        responseData.map((json) => EmpLeaveModel.fromJson(json)).toList();
        return leaveTypes;
      } else {
        throw Exception(
            "Failed to fetch data from the API. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // Handle any database or network errors
      print("Error: $e");
      throw Exception("Failed to fetch data from the database or make API request.");
    }
  }
}
