import 'dart:convert';
import 'package:http/http.dart' as http;

import 'branchModel.dart';

class BranchRepository {
  final String baseUrl = 'http://62.171.184.216:9595/api/Admin/Branch';

  Future<List<Branch>> getAllActiveBranches(String corporateId) async {
    final Uri uri = Uri.parse('$baseUrl/GetAllActive?CorporateId=ptsoffice');

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
