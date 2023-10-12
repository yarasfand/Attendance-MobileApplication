import 'dart:convert';
import 'package:http/http.dart' as http;

import 'companyModel.dart';

class CompanyRepository {
  final String baseUrl = 'http://62.171.184.216:9595/api/Admin/Company';

  Future<List<Company>> getAllActiveCompanies(String corporateId) async {
    final Uri uri = Uri.parse('$baseUrl/GetAllActive?CorporateId=ptsoffice');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Company> companies =
        data.map((item) => Company.fromJson(item)).toList();
        return companies;
      } else {
        print('HTTP Status Code: ${response.statusCode}');
        throw Exception('Failed to load companies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
