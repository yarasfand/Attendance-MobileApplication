import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../Sqlite/sqlite_helper.dart'; // Adjust the import path based on your project structure

import '../models/DailyReports_model.dart';

class DailyReportsRepository {
  final String baseUrl =
      'http://62.171.184.216:9595/api/employee/report/getdailyreport';

  Future<List<DailyReportsModel>> getDailyReports({
    required DateTime reportDate,
  }) async {
    try {
      final dbHelper = EmployeeDatabaseHelper.instance;
      final firstEmployee = await dbHelper.getFirstEmployee();

      if (firstEmployee != null) {
        final String corporateId = firstEmployee['corporate_id'] as String;
        final int employeeId = firstEmployee['id'] as int;

        final String formattedDate = reportDate.toIso8601String();

        final Uri uri = Uri.parse(
            '$baseUrl?CorporateId=$corporateId&employeeId=$employeeId&ReportDate=$formattedDate');

        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final dynamic data = json.decode(response.body);

          if (data is Map<String, dynamic>) {
            // Assuming that the API response is a single report object
            final DailyReportsModel report =
            DailyReportsModel.fromJson(data); // Adjust this to your model

            // Create a List to hold the single report
            final List<DailyReportsModel> reports = [report];

            return reports;
          } else {
            throw Exception('API response does not contain the expected structure');
          }
        } else {
          throw Exception('Failed to load daily reports');
        }
      } else {
        // Handle the case where no employee data is found
        // Set default values or throw an exception as needed
        print("No employee data found in the database.");
        return [];
      }
    } catch (e) {
      // Handle any database or network errors
      print("Error: $e");
      throw Exception("Failed to fetch data from the database or make API request.");
    }
  }
}
