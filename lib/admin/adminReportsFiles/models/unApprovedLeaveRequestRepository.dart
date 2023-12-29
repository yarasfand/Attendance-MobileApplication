import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/admin/adminReportsFiles/models/unApprovedLeaveRequestModel.dart';
import '../../../Sqlite/admin_sqliteHelper.dart';

class UnApprovedLeaveRepository {
  Future<List<UnApprovedLeaveRequest>> fetchUnApprovedLeaveRequests() async {
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

        final String baseUrl =
            'http://62.171.184.216:9595/api/admin/leave/getunapproved?CorporateId=$corporateId';

        final response = await http.get(Uri.parse(baseUrl));

        if (response.statusCode == 200) {
          final List<dynamic> jsonData = json.decode(response.body);
          final List<UnApprovedLeaveRequest> unApprovedLeaveRequests = jsonData
              .map((data) => UnApprovedLeaveRequest.fromJson(data))
              .toList();

          return unApprovedLeaveRequests;
        } else {
          throw Exception('Failed to load unapproved leave requests');
        }
      } else {
        print('No admin data found in the SQLite table');
        return [];
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
