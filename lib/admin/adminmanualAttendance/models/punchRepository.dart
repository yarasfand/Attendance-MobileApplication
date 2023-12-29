import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/admin/adminmanualAttendance/models/punchDataModel.dart';
import '../../../Sqlite/admin_sqliteHelper.dart';

class ManualPunchRepository {
  Future<bool> addManualPunch(List<PunchData> requestDataList) async {
    try {
      // Retrieve corporate_id from SQLite table
      final adminDbHelper = AdminDatabaseHelper();
      final adminData = await adminDbHelper.getAdmins();
      if (adminData.isNotEmpty) {
        final String? corporateId = adminData.first['corporate_id'];

        if (corporateId == null) {
          print('Corporate ID is null in SQLite table');
          return false;
        }

        final String apiUrl =
            'http://62.171.184.216:9595/api/Admin/ManualPunch/AddManualPunch?CorporateId=$corporateId';

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
      } else {
        print('No admin data found in the SQLite table');
        return false;
      }
    } catch (e) {
      // Handle any network or exception errors here.
      print('Exception occurred while adding manual punch: $e');
      return false;
    }
  }
}
