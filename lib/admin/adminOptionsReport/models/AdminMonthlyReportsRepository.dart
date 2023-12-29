import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../Sqlite/admin_sqliteHelper.dart';
import 'AdminMonthlyReportModel.dart';


class AdminMonthlyReportsRepository {
  final String baseUrl = 'http://62.171.184.216:9595/api/admin/report/getmonthlyreport';

  Future<List<AdminMonthlyReportsModel>> fetchMonthlyReports(
      List<int> employeeIds, int selectedMonth) async {
    try {
      // Retrieve corporate_id from SQLite table
      final adminDbHelper = AdminDatabaseHelper();
      final adminData = await adminDbHelper.getAdmins();
      if (adminData.isNotEmpty) {
        final String? corporateId = adminData.first['corporate_id'];

        if (corporateId == null) {
          print('Corporate ID is null in SQLite table');
          return [];
        }

        final employeeIdsQuery = employeeIds.map((id) => 'employeeIds=$id').join('&');
        final fullUrl = '$baseUrl?CorporateId=$corporateId&Month=$selectedMonth&$employeeIdsQuery';

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
      } else {
        print('No admin data found in the SQLite table');
        return [];
      }
    } catch (e) {
      // Handle any network or exception errors here.
      print('Exception occurred while fetching monthly reports: $e');
      return [];
    }
  }
}
