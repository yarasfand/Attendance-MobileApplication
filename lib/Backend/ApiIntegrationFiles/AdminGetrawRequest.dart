
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminApi{

  Future<void> getData() async {
    final apiUrl = "http://62.171.184.216:9595/api/login";
    final Map<String, dynamic> data = {
      "user_Name": "ptsadmin",
      "user_Password": "Reenoip@1234",
      "email": "a",
      "mobile": "a",
      "role": "admin",
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
      print(responseData[0]["userLoginId"]);
    } else {
      print(
          "Failed to fetch data from the API. Status code: ${response.statusCode}");
    }

    client.close();
  }

}