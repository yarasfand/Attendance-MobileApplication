import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Sqlite/admin_sqliteHelper.dart';
import 'branchModel.dart';

class BranchRepository {
  final String baseUrl = 'http://62.171.184.216:9595/api/Admin/Branch';

  Future<List<Branch>> getAllActiveBranches() async {
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
          final List<Branch> branches =
          data.map((item) => Branch.fromJson(item)).toList();
          return branches;
        } else {
          print('HTTP Status Code: ${response.statusCode}');
          throw Exception('Failed to load branches');
        }
      } else {
        print('No admin data found in the SQLite table');
        return [];
      }
    } catch (e) {
      // Handle any network or exception errors here.
      print('Exception occurred while fetching branches: $e');
      return [];
    }
  }
}
