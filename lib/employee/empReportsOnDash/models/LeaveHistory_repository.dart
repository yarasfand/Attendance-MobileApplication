import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/Sqlite/sqlite_helper.dart'; // Adjust the import path based on your project structure
import 'empLeaveHistoryModel.dart';

class LeaveHistoryRepository {
  Future<Map<String, dynamic>> getEmployeeData() async {
    try {
      final dbHelper = EmployeeDatabaseHelper.instance;
      final firstEmployee = await dbHelper.getFirstEmployee();

      if (firstEmployee != null) {
        final String corporateId = firstEmployee['corporate_id'] as String;
        final int employeeId = firstEmployee['id'] as int;
        return {'corporateId': corporateId, 'employeeId': employeeId};
      } else {
        // Handle the case where no employee data is found
        // Set default values or throw an exception as needed
        print("No employee data found in the database.");
        throw Exception("Employee data not found in the database");
      }
    } catch (e) {
      // Handle any database error
      print("Error fetching data from the database: $e");
      throw Exception("Failed to fetch employee data from the database");
    }
  }

  Future<List<LeaveHistoryModel>> getLeaveHistory() async {
    try {
      final employeeData = await getEmployeeData();
      final String corporateId = employeeData['corporateId'] as String;
      final int employeeId = employeeData['employeeId'] as int;

      final apiUrl =
          "http://62.171.184.216:9595/api/employee/leave/getleavehistorybyemployeeid?CorporateId=$corporateId&employeeId=$employeeId";

      final headers = {
        'Content-Type': 'application/json', // Set the content type to JSON
      };

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        final List<LeaveHistoryModel> leaveHistoryList = responseData.map((item) {
          return LeaveHistoryModel.fromJson(item);
        }).toList();
        return leaveHistoryList;
      } else {
        throw Exception("Failed to fetch data from the API. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to fetch leave history data: $e");
    }
  }
}
