import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'empLeaveHistoryModel.dart';
class LeaveHistoryRepository {
  Future<List<LeaveHistoryModel>> getLeaveHistory() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String corporateId = pref.getString("corporate_id") ?? "";
      int employeeId = pref.getInt("employee_id") ?? 0;
      print(employeeId);
      final apiUrl =
          "http://62.171.184.216:9595/api/employee/leave/getleavehistorybyemployeeid?CorporateId=$corporateId&employeeId=$employeeId";

      final headers = {
        'Content-Type': 'application/json', // Set the content type to JSON
      };

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        final List<LeaveHistoryModel> leaveHistoryList = responseData.map((item) {
          return LeaveHistoryModel.fromJson(item);
        }).toList();
        return leaveHistoryList;
      } else {
        throw Exception("Failed to fetch data from the API. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to fetch leave history data: $e");
    }
  }
}
