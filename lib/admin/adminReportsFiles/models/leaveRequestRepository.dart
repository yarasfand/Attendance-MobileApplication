import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LeaveRepository {
  final String baseUrl = 'http://62.171.184.216:9595';

  Future<List<Map<String, dynamic>>> fetchLeaveRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String corporateId = prefs.getString("corporate_id") ?? "ptsoffice";
    print(corporateId);
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
  }
}
