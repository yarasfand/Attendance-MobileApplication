import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Sqlite/admin_sqliteHelper.dart'; // Import your SQLite helper

class ApproveManualPunchRepository {
  Future<bool> postApproveManualPunch(List<Map<String, dynamic>> data) async {
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
            'http://62.171.184.216:9595/api/admin/manualpunch/approvemanualpunch?CorporateId=$corporateId';
        final headers = <String, String>{
          'Content-Type': 'application/json',
        };

        final body = json.encode(data);

        // Print the data before making the HTTP request
        print('Posting data: $body');

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
      } else {
        print('No admin data found in the SQLite table');
        return false;
      }
    } catch (e) {
      // Handle any errors that might occur during the process
      print('Error: $e');
      return false;
    }
  }
}
