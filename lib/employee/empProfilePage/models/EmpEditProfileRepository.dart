import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'empEditProfileModel.dart';
class EmpEditProfileRepository {
  final String apiUrl =
      "http://62.171.184.216:9595/api/employee/dashboard/updateprofile";

  Future<void> postData(EmpEditProfileModel empEditProfileModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String corporateId = prefs.getString("corporate_id") ??
        "default_corporate_id"; // Replace "default_corporate_id" with a default value if needed
    print('This is corporate id $corporateId');
    final headers = {
      'Content-Type': 'application/json', // Set the content type to JSON
    };

    final client = http.Client();

    final requestBody = jsonEncode(empEditProfileModel.toJson());

    final response = await client.post(
      Uri.parse('$apiUrl?CorporateId=$corporateId'),
      headers: headers,
      body: requestBody,
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      // Request was successful
      // You can handle the response as needed
      print("--------------------Response submitted Successfully------------------");
    } else {
      throw Exception(
          "Failed to post data to the API. Status code: ${response.statusCode}");
    }
  }
}
