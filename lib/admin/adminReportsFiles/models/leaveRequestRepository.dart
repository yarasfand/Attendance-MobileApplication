import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Sqlite/admin_sqliteHelper.dart';

class LeaveRepository {
  final String baseUrl = 'http://62.171.184.216:9595';

  Future<List<Map<String, dynamic>>> fetchLeaveRequests() async {
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

        final uri = Uri.parse('$baseUrl/api/admin/leave/getapproved?CorporateId=$corporateId');

        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final List<dynamic> jsonData = json.decode(response.body);

          // You can convert the dynamic List into a List of Map<String, dynamic>
          List<Map<String, dynamic>> leaveRequests = jsonData.cast<Map<String, dynamic>>();
          return leaveRequests;
        } else {
          throw Exception('Failed to fetch leave requests');
        }
      } else {
        print('No admin data found in the SQLite table');
        return [];
      }
    } catch (e) {
      print('Error fetching leave requests: $e');
      throw Exception('An error occurred: $e');
    }
  }
}
