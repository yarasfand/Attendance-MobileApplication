import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'departmentModel.dart';

class DepartmentRepository {
  final String baseUrl = 'http://62.171.184.216:9595/api/Admin/Department';

  Future<List<Department>> getAllActiveDepartments(String corporateId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String corporateId = prefs.getString("corporate_id") ?? "ptsoffice";
    print(corporateId);
    final Uri uri = Uri.parse('$baseUrl/GetAllActive?CorporateId=$corporateId');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Department> departments =
        data.map((item) => Department.fromJson(item)).toList();
        return departments;
      } else {
        print('HTTP Status Code: ${response.statusCode}');
        throw Exception('Failed to load departments');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
