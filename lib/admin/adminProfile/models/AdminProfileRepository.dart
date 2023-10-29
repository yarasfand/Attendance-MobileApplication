import 'dart:convert';
import 'package:http/http.dart' as http;

import 'AdminProfileModel.dart';

class AdminProfileRepository {

  Future<AdminProfileModel?> fetchAdminProfile(String corporateId, String employeeId) async {
    final url = Uri.parse('http://62.171.184.216:9595/api/admin/dashboard/profile?CorporateId=$corporateId&employeeId=$employeeId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return AdminProfileModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to fetch admin profile data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching admin profile data: $e');
    }
  }
}
