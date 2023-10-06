import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/emp_attendance_status_model.dart';

class EmpAttendanceRepository {
  late String coorporateId;
  late int employeeId;

  EmpAttendanceRepository() {
    // Initialize shared preferences and fetch data when the object is created.
    fetchSharedPrefData();
  }

  Future<void> fetchSharedPrefData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    coorporateId = pref.getString("corporate_id")!;
    employeeId = pref.getInt("employee_id")!;

  }

  Future<EmpAttendanceModel> getData() async {
    // Construct the apiUrl when you need it (inside a method).
    String apiUrl =
        "http://62.171.184.216:9595/api/employee/dashboard/attendance?CorporateId=$coorporateId&employeeId=$employeeId";

    final headers = {
      'Content-Type': 'application/json', // Set the content type to JSON
    };

    final client = http.Client();
    final response = await client.get(
      Uri.parse(apiUrl),
      headers: headers,
    );



    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      if (responseData.isNotEmpty) {
        final Map<String, dynamic> data = responseData[0];

        final DateTime? in1 =
        data["in1"] != null ? DateTime.parse(data["in1"]) : null;
        final DateTime? out2 =
        data["out2"] != null ? DateTime.parse(data["out2"]) : null;
        final String status = data["status"] != null ? data["status"] : "";

        final empAttendanceModel = EmpAttendanceModel(
          in1: in1,
          out2: out2,
          status: status,
        );

        return empAttendanceModel;
      } else {
        // If no data is found, return a model with all fields set to null
        return EmpAttendanceModel(in1: null, out2: null, status: null);
      }
    } else {
      throw Exception(
          "Failed to fetch data from the API. Status code: ${response.statusCode}");
    }
  }
}
