import 'package:http/http.dart' as http;
import 'dart:convert';

import 'getActiveEmployeesModel.dart';

class GetActiveEmpRepository {
  Future<List<GetActiveEmpModel>> getActiveEmployees(String corporateId) async {
    final apiUrl = 'http://62.171.184.216:9595/api/Admin/User/GetActiveEmployees?CorporateId=$corporateId';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<GetActiveEmpModel> employees = data.map((json) => GetActiveEmpModel.fromJson(json)).toList();
        return employees;
      } else {
        throw Exception('Failed to fetch data from the API. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('An error occurred: $e');
    }

  }
}
