import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/AdminDashBoard_model.dart';

class AdminDashboardRepository {
  final String baseUrl;

  AdminDashboardRepository(this.baseUrl);

  Future<AdminDashBoard> fetchDashboardData(String corporateId, DateTime date) async {
    final formattedDate = date.toIso8601String(); // Format DateTime to ISO 8601 string
    final url = Uri.parse('$baseUrl/api/Admin/Dashboard/Attendance?CorporateId=$corporateId&Date=$formattedDate');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        print(response.body);
        return AdminDashBoard.fromJson(jsonData);
      } else {
        throw Exception('Failed to fetch data from the API');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
