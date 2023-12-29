import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Sqlite/admin_sqliteHelper.dart';
import 'leaveSubmissionModel.dart';

class LeaveSubmissionRepository {
  final String baseUrl = 'http://62.171.184.216:9595';

  Future<void> submitLeaveRequest(LeaveSubmissionModel leaveSubmissionModel) async {
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

        final String apiUrl = '$baseUrl/api/admin/leave/addleave?CorporateId=$corporateId';

        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json', // Set the content type to JSON.
          },
          body: json.encode(leaveSubmissionModel.toJson()), // Convert the model to JSON.
        );

        if (response.statusCode == 200) {
          // Request was successful. You can handle the response here.
          print('Leave request submitted successfully.');
        } else {
          // Request failed. Handle the error.
          print('Failed to submit leave request. Status code: ${response.statusCode}');
        }
      } else {
        print('No admin data found in the SQLite table');
      }
    } catch (e) {
      // An error occurred. Handle the exception.
      print('Error submitting leave request: $e');
    }
  }
}
