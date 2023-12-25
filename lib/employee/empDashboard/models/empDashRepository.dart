import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Sqlite/sqlite_helper.dart';
import 'empDashModel.dart';

class EmpDashRepository {
  final String baseUrl = "http://62.171.184.216:9595/api/employee/dashboard/monthlystatus";

  Future<List<EmpDashModel>> getData() async {
    try {
      final dbHelper = EmployeeDatabaseHelper.instance;
      final firstEmployee = await dbHelper.getFirstEmployee();

      if (firstEmployee != null) {
        final String corporateId = firstEmployee['corporate_id'] as String;
        final int empId = firstEmployee['id'] as int;

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
      } else {
        // Handle the case where no employee data is found
        return [];
      }
    } catch (e) {
      print("Error fetching data from the database: $e");
      // Handle the error as needed
      return [];
    }
  }
}
