import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Sqlite/admin_sqliteHelper.dart';
import 'departmentModel.dart';

class DepartmentRepository {
  final String baseUrl = 'http://62.171.184.216:9595/api/Admin/Department';

  Future<List<Department>> getAllActiveDepartments() async {
    try {
      // Retrieve corporate_id from SQLite table
      final adminDbHelper = AdminDatabaseHelper();
      final adminData = await adminDbHelper.getAdmins();
      if (adminData.isNotEmpty) {
        final String? corporateId = adminData.first['corporate_id'];

        if (corporateId == null) {
          print('Corporate ID is null in SQLite table');
          return [];
        }

        final Uri uri = Uri.parse('$baseUrl/GetAllActive?CorporateId=$corporateId');

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
      } else {
        print('No admin data found in the SQLite table');
        return [];
      }
    } catch (e) {
      // Handle any network or exception errors here.
      print('Exception occurred while fetching departments: $e');
      return [];
    }
  }
}
