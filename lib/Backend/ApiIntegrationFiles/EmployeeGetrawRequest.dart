
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class EmployeeApi{

  Future<void> getData() async {
    final apiUrl = "http://62.171.184.216:9595/api/login";
    final Map<String, dynamic> data = {
      "user_Name": "1999",
      "user_Password": "1999",
      "email": "a",
      "mobile": "a",
      "role": "employee",
      "corporateId": "ptsoffice"
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
    // print(responseStream);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(responseStream);
      print(responseData[0]["empName"]);
      final sharedPrefs = await SharedPreferences.getInstance();
      sharedPrefs.setInt('employee_id', responseData[0]["empId"]);
      print("data saved");
    } else {
      print(
          "Failed to fetch data from the API. Status code: ${response.statusCode}");
    }

    client.close();
  }

}