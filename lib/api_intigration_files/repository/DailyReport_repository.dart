import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/DailyReports_model.dart';

class DailyReportsRepository {
  final String baseUrl =
      'http://62.171.184.216:9595/api/employee/report/getdailyreport';

  Future<List<DailyReportsModel>> getDailyReports({
    required String corporateId,
    required int employeeId,
    required DateTime reportDate,
  }) async {
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
  }
}
