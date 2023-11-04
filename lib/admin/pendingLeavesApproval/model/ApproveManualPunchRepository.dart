import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApproveManualPunchRepository {


  Future<bool> postApproveManualPunch(List<Map<String, dynamic>> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String corporateId = prefs.getString("corporate_id") ?? "ptsoffice";
    print(corporateId);
    final String apiUrl =
        'http://62.171.184.216:9595/api/admin/manualpunch/approvemanualpunch?CorporateId=$corporateId';
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final body =
        json.encode(data); // Convert the list of data objects to a JSON string

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      // Request was successful
      print("Posted");
      return true;
    } else {
      // Request failed
      print("Not posted");
      return false;
    }
  }
}
