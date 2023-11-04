  import 'dart:convert';
  import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

  class LeaveTypeRepository {
    List<Map<String, dynamic>> leaveTypes = []; // Add this property

    Future<List<Map<String, dynamic>>?> fetchLeaveTypes() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String corporateId = prefs.getString("corporate_id") ?? "ptsoffice";
      print(corporateId);
      final String baseUrl = 'http://62.171.184.216:9595/api/admin/leave/getleavetype?CorporateId=$corporateId';


      try {
        final response = await http.get(Uri.parse(baseUrl));

        if (response.statusCode == 200) {
          final List<dynamic> jsonData = json.decode(response.body);
          List<Map<String, dynamic>> leaveTypes = jsonData.cast<Map<String, dynamic>>();
          return leaveTypes;
        } else {
          throw Exception('Failed to fetch leave types');
        }
      } catch (e) {
        throw Exception('Error: $e');
      }
    }

  }
