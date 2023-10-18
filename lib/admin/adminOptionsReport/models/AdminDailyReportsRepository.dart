import 'dart:convert';
import 'package:http/http.dart' as http;

import 'AdminDailyReportsModel.dart';

class AdminReportsRepository {
  final String baseUrl;

  AdminReportsRepository(this.baseUrl);

  Future<List<AdminDailyReportsModel>> fetchDailyReports(
      List<int> employeeIds, String reportDate) async {
    final employeeIdParams = employeeIds.map((id) => 'employeeIds=$id').join('&');
    final url = '$baseUrl/api/admin/report/getdailyreport?CorporateId=ptsoffice&$employeeIdParams&ReportDate=$reportDate';

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
