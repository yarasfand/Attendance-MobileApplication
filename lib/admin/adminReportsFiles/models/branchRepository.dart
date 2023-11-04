import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'branchModel.dart';

class BranchRepository {
  final String baseUrl = 'http://62.171.184.216:9595/api/Admin/Branch';

  Future<List<Branch>> getAllActiveBranches(String corporateId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String corporateId = prefs.getString("corporate_id") ?? "ptsoffice";
    print(corporateId);

    final Uri uri = Uri.parse('$baseUrl/GetAllActive?CorporateId=$corporateId');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Branch> branches =
        data.map((item) => Branch.fromJson(item)).toList();
        return branches;
      } else {
        print('HTTP Status Code: ${response.statusCode}');
        throw Exception('Failed to load branches');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
