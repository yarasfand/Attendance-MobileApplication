import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Sqlite/sqlite_helper.dart';
import 'emp_attendance_status_model.dart';

class EmpAttendanceRepository {
  String? corporateId;
  int? employeeId;

  EmpAttendanceRepository() {
    // Initialize shared preferences and fetch data when the object is created.
    fetchDatabaseData();
  }

  Future<void> fetchDatabaseData() async {
    try {
      final dbHelper = EmployeeDatabaseHelper.instance;
      final firstEmployee = await dbHelper.getFirstEmployee();

      if (firstEmployee != null) {
        corporateId = firstEmployee['corporate_id'] as String?;
        employeeId = firstEmployee['id'] as int?;
      } else {
        // Handle the case where no employee data is found
        // Set default values or throw an exception as needed
        corporateId = null; // Set a default value
        employeeId = null;   // Set a default value
      }
    } catch (e) {
      print("Error fetching data from the database: $e");
      // Handle the error as needed
    }
    print("Fetched corporateId: $corporateId, employeeId: $employeeId");
  }

  Future<EmpAttendanceModel> getData() async {
    if (!_isInitialized()) {
      // If not initialized, fetch data before proceeding
      await fetchDatabaseData();
    }
    // Construct the apiUrl when you need it (inside a method).
    if (corporateId == null || employeeId == null) {
      // Handle the case where corporateId or employeeId is still null
      throw Exception("CorporateId or employeeId is null");
    }

    String apiUrl =
        "http://62.171.184.216:9595/api/employee/dashboard/attendance?CorporateId=$corporateId&employeeId=$employeeId";

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

  bool _isInitialized() {
    print("Checking initialization: corporateId = $corporateId, employeeId = $employeeId");
    return corporateId != null && employeeId != null;
  }
}
