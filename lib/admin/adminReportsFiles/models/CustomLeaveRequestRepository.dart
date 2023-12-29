import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Sqlite/admin_sqliteHelper.dart';
import 'CustomLeaveRequestModel.dart';

class CustomLeaveRequestRepository {
  Future<void> postCustomLeaveRequest(CustomLeaveRequestModel leaveRequest) async {
    try {
      // Retrieve corporate_id from SQLite table
      final adminDbHelper = AdminDatabaseHelper();
      final adminData = await adminDbHelper.getAdmins();

      if (adminData.isNotEmpty) {
        final String? corporateId = adminData.first['corporate_id'];

        if (corporateId == null) {
          print('Corporate ID is null in SQLite table');
          return;
        }

        final String apiUrl =
            'http://62.171.184.216:9595/api/admin/leave/approveleave?CorporateId=$corporateId';

        final Map<String, dynamic> requestData = leaveRequest.toJson();

        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(requestData),
        );

        if (response.statusCode == 200) {
          print('Leave request successfully posted');
          print('Response: ${response.body}');
        } else {
          print('Failed to post leave request');
          print('Response: ${response.body}');
          throw Exception('Failed to post leave request');
        }
      } else {
        print('No admin data found in the SQLite table');
      }
    } catch (e) {
      // Handle any network or exception errors here.
      print('Exception occurred while posting leave request: $e');
    }
  }
}
