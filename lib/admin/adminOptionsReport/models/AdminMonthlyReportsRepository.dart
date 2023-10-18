import 'dart:convert';
import 'package:http/http.dart' as http;

import 'AdminMonthlyReportModel.dart';

class AdminMonthlyReportsRepository {
  final String baseUrl =
      'http://62.171.184.216:9595/api/admin/report/getmonthlyreport?CorporateId=ptsoffice';

  Future<List<AdminMonthlyReportsModel>> fetchMonthlyReports(
      List<int> employeeIds, int selectedMonth) async {
    final employeeIdsQuery =
        employeeIds.map((id) => 'employeeIds=$id').join('&');
    final fullUrl = '$baseUrl&Month=$selectedMonth&$employeeIdsQuery';

    try {
      final response = await http.get(Uri.parse(fullUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<AdminMonthlyReportsModel> reportsList = jsonList
            .map((json) => AdminMonthlyReportsModel.fromJson(json))
            .toList();
        return reportsList;
      } else {
        throw Exception(
            'Failed to fetch monthly reports. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching monthly reports: $e');
    }
  }
}
