import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'AdminDailyReportsModel.dart';

class AdminReportsRepository {
  final String baseUrl;

  AdminReportsRepository(this.baseUrl);

  Future<List<AdminDailyReportsModel>> fetchDailyReports(
      List<int> employeeIds, String reportDate) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? corporateId = prefs.getString('corporate_id');

    if (corporateId == null) {
      print('Corporate ID not found in shared preferences');
      return [];
    }

    final employeeIdParams = employeeIds.map((id) => 'employeeIds=$id').join('&');
    final url = '$baseUrl/api/admin/report/getdailyreport?CorporateId=$corporateId&$employeeIdParams&ReportDate=$reportDate';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // Convert the JSON data to a list of AdminDailyReportsModel objects
      final reports = data.map((item) => AdminDailyReportsModel.fromJson(item)).toList();

      return reports;
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load daily reports');
    }
  }
}
