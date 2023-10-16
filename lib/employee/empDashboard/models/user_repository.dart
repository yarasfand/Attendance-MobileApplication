import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/employee/empDashboard/models/user_model.dart';

class UserRepository {
  final apiUrl = "http://62.171.184.216:9595/api/employee/login";
  Future<List<Employee>> getData({
    required String corporateId,
    required String username,
    required String password,
    required String role,
  }) async {
    final Map<String, dynamic> data = {
      "user_Name": username,
      "user_Password": password,
      "email": "a",
      "mobile": "a",
      "role": role,
      "corporateId": corporateId,

    };

    final headers = {
      'Content-Type': 'application/json', // Set the content type to JSON
    };

    final client = http.Client();

    final response = await client.send(
      http.Request("GET", Uri.parse(apiUrl))
        ..headers.addAll(headers)
        ..body = jsonEncode(data),
    );

    final responseStream = await response.stream.bytesToString();


    if (response.statusCode == 200) {
      final List responseData = json.decode(responseStream);

      return responseData.map(((e) => Employee.fromJson(e))).toList();
    } else {
      throw Exception(
          "Failed to fetch data from the API. Status code: ${response.statusCode}");
    }
  }
}
