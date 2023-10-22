import 'dart:convert';
import 'package:http/http.dart' as http;

import 'CustomLeaveRequestModel.dart';

class CustomLeaveRequestRepository {
  final String apiUrl =
      'http://62.171.184.216:9595/api/admin/leave/approveleave?CorporateId=ptsoffice';

  Future<void> postCustomLeaveRequest(CustomLeaveRequestModel leaveRequest) async {
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
  }
}
