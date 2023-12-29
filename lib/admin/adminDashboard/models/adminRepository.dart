import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Sqlite/admin_sqliteHelper.dart';
import '../models/adminModel.dart';

class AdminRepository {
  final apiUrl = "http://62.171.184.216:9595/api/login";

  Future<List<AdminModel>> getData() async {
    try {
      // Retrieve corporate_id and username from SQLite table
      final adminDbHelper = AdminDatabaseHelper();
      final adminData = await adminDbHelper.getAdmins();
      if (adminData.isNotEmpty) {
        final corporateId = adminData.first['corporate_id'];
        final username = adminData.first['username'];

        final Map<String, dynamic> data = {
          "user_Name": username,
          "user_Password": "Reenoip@1234",
          "email": "a",
          "mobile": "a",
          "role": "admin",
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

        print("Response Status Code: ${response.statusCode}");
        print("Response Body: $responseStream");

        if (response.statusCode == 200) {
          final List responseData = json.decode(responseStream);
          print(responseData[0]["userName"]);
          return responseData.map(((e) => AdminModel.fromJson(e))).toList();
        } else {
          throw Exception(
              "Failed to fetch data from the API. Status code: ${response.statusCode}");
        }
      } else {
        throw Exception('No admin data found in the SQLite table');
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
