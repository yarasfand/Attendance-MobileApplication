import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/MonthlyReports_model.dart';

class MonthlyReportsRepository {
  final String baseUrl =
      'http://62.171.184.216:9595/api/employee/report/getmonthlyreport';

  Future<List<MonthlyReportsModel>> getMonthlyReports({
    required String corporateId,
    required int employeeId,
    required int month,
  }) async {
    final Uri uri = Uri.parse(
        '$baseUrl?CorporateId=$corporateId&employeeId=$employeeId&Month=$month');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        List<MonthlyReportsModel> reports =
        data.map((item) => MonthlyReportsModel.fromJson(item)).toList();
        print(response.body);
        return reports;
      } else {
        throw Exception(
            'Failed to load monthly reports. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load monthly reports: $e');
    }
  }
}
