import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Sqlite/admin_sqliteHelper.dart';
import 'AdminEditProfileModel.dart';


class AdminEditProfileRepository {
  final String baseUrl;

  AdminEditProfileRepository(this.baseUrl);

  Future<bool> updateAdminProfile(AdminEditProfile adminEditProfile) async {
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

        final url = Uri.parse('$baseUrl/api/admin/dashboard/updateprofile?CorporateId=$corporateId');

        final response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(adminEditProfile.toJson()),
        );

        if (response.statusCode == 200) {
          // Data was successfully posted
          return true;
        } else {
          // Handle the error and return false
          print('Failed to update admin profile. Status code: ${response.statusCode}');
          return false;
        }
      } else {
        print('No admin data found in the SQLite table');
        return false;
      }
    } catch (e) {
      // Handle any network or exception errors here.
      print('Exception occurred while updating admin profile: $e');
      return false;
    }
  }
}
