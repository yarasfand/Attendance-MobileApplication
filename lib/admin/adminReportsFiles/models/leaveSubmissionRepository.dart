import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'leaveSubmissionModel.dart';


class LeaveSubmissionRepository {


  Future<void> submitLeaveRequest(LeaveSubmissionModel leaveSubmissionModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String corporateId = prefs.getString("corporate_id") ?? "ptsoffice";
    print(corporateId);
    final String baseUrl =
        'http://62.171.184.216:9595/api/admin/leave/addleave?CorporateId=$corporateId';
    final apiUrl = baseUrl; // Use the base URL for leave request submission.

    try {
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
    } catch (e) {
      // An error occurred. Handle the exception.
      print('Error submitting leave request: $e');
    }
  }
}
