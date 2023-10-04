import 'dart:convert';
import 'package:http/http.dart' as http;

import '../EmployeeModels/EmployeeSubmissionModel.dart';

class SubmissionRepository {
  final apiUrl =
      "http://62.171.184.216:9595/api/Leave/AddLeaveRequest?CorporateId=ptsoffice";

  Future<void> postData(SubmissionModel submissionModel) async {
    final headers = {
      'Content-Type': 'application/json', // Set the content type to JSON
    };

    final client = http.Client();

    final requestBody = jsonEncode(submissionModel.toJson());

    final response = await client.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: requestBody,
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      // Request was successful
      // You can handle the response as needed
      print("Response submitted");
    } else {
      throw Exception(
          "Failed to post data to the API. Status code: ${response.statusCode}");
    }
  }
}
