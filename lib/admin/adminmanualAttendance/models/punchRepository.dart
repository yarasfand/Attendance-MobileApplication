import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/admin/adminmanualAttendance/models/punchDataModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManualPunchRepository {


  Future<bool> addManualPunch(List<PunchData> requestDataList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String corporateId = prefs.getString("corporate_id") ?? "ptsoffice";
    print(corporateId);
    final String apiUrl =
        'http://62.171.184.216:9595/api/Admin/ManualPunch/AddManualPunch?CorporateId=$corporateId';
    try {
      // Convert List<PunchData> to List<Map<String, dynamic>>
      final requestDataJsonList = requestDataList
          .map((punchData) => punchData.toJson())
          .toList();

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestDataJsonList), // Encode the list directly
      );

      if (response.statusCode == 200) {
        // Successfully added the manual punch
        print('Response body: ${response.body}');
        return true;
      } else {
        // Handle the API error here, log or throw an exception.
        print('Failed to add manual punch. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      // Handle any network or exception errors here.
      print('Exception occurred while adding manual punch: $e');
      return false;
    }
  }
}
