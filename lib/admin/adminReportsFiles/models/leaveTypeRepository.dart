import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Sqlite/admin_sqliteHelper.dart';

class LeaveTypeRepository {
  Future<List<Map<String, dynamic>>?> fetchLeaveTypes() async {
    try {
      // Retrieve corporate_id from SQLite table
      final adminDbHelper = AdminDatabaseHelper();
      final adminData = await adminDbHelper.getAdmins();

      if (adminData.isNotEmpty) {
        final String? corporateId = adminData.first['corporate_id'];

        if (corporateId == null) {
          print('Corporate ID is null in SQLite table');
          return null;
        }

        final String baseUrl = 'http://62.171.184.216:9595/api/admin/leave/getleavetype?CorporateId=$corporateId';

        final response = await http.get(Uri.parse(baseUrl));

        if (response.statusCode == 200) {
          final List<dynamic> jsonData = json.decode(response.body);
          List<Map<String, dynamic>> leaveTypes = jsonData.cast<Map<String, dynamic>>();
          return leaveTypes;
        } else {
          throw Exception('Failed to fetch leave types');
        }
      } else {
        print('No admin data found in the SQLite table');
        return null;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
