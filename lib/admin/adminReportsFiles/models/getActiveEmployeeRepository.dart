import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../Sqlite/admin_sqliteHelper.dart';
import 'getActiveEmployeesModel.dart';

class GetActiveEmpRepository {
  Future<List<GetActiveEmpModel>> getActiveEmployees() async {
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

        final apiUrl = 'http://62.171.184.216:9595/api/Admin/User/GetActiveEmployees?CorporateId=$corporateId';

        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          List<GetActiveEmpModel> employees = data.map((json) => GetActiveEmpModel.fromJson(json)).toList();
          return employees;
        } else {
          throw Exception('Failed to fetch data from the API. Status code: ${response.statusCode}');
        }
      } else {
        print('No admin data found in the SQLite table');
        return [];
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('An error occurred: $e');
    }
  }
}
