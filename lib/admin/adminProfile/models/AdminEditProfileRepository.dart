import 'dart:convert';
import 'package:http/http.dart' as http;
import 'AdminEditProfileModel.dart';

import 'package:shared_preferences/shared_preferences.dart'; // Import the package

class AdminEditProfileRepository {
  final String baseUrl;

  AdminEditProfileRepository(this.baseUrl);

  Future<bool> updateAdminProfile(AdminEditProfile adminEditProfile) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedCorporateId = prefs.getString('corporate_id') ?? "ptsoffice"; // Get corporate ID from shared preferences or use the default

    final url = Uri.parse('$baseUrl/api/admin/dashboard/updateprofile?CorporateId=$savedCorporateId');

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
      return false;
    }
  }
}
