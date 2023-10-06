import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/emp_dash_model.dart';

class EmpDashRepository {
  final String baseUrl = "http://62.171.184.216:9595/api/employee/dashboard/monthlystatus";

  Future<List<EmpDashModel>> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String corporateId = prefs.getString('corporate_id') ?? "";
    final int empId = prefs.getInt('employee_id') ?? 0;

    final Uri uri = Uri.parse("$baseUrl?CorporateId=$corporateId&employeeId=$empId");

    final headers = {
      'Content-Type': 'application/json', // Set the content type to JSON
    };

    final client = http.Client();

    final response = await client.get(
      uri,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final int presentCount = responseData["presentCount"];
      final int absentCount = responseData["absentCount"];
      final int leaveCount = responseData["leaveCount"];

      final empDashModel = EmpDashModel(
        presentCount: presentCount,
        absentCount: absentCount,
        leaveCount: leaveCount,
      );

      // Return a list with a single EmpDashModel, as your code suggests accessing userList[0]
      return [empDashModel];
    } else {
      throw Exception(
          "Failed to fetch data from the API. Status code: ${response.statusCode}");
    }
  }
}
