  import 'dart:convert';
  import 'package:http/http.dart' as http;

  class LeaveTypeRepository {
    final String baseUrl = 'http://62.171.184.216:9595/api/admin/leave/getleavetype?CorporateId=ptsoffice';
    List<Map<String, dynamic>> leaveTypes = []; // Add this property

    Future<List<Map<String, dynamic>>?> fetchLeaveTypes() async {
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
