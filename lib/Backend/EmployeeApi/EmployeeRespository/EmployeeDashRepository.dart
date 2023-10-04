import 'dart:convert';
import 'package:http/http.dart' as http;

import '../EmployeeModels/EmployeeDashModel.dart';

class EmpDashRepository {
  final apiUrl =
      "http://62.171.184.216:9595/api/dashboard/monthlystatus/employee?CorporateId=ptsoffice&employeeId=11";

  Future<List<EmpDashModel>> getData() async {
    final headers = {
      'Content-Type': 'application/json', // Set the content type to JSON
    };

    final client = http.Client();

    final response = await client.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

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
