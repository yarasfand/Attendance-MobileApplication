import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../EmployeeModels/EmployeeProfileModel.dart';

class EmpProfileRepository {
  late String coorporateId;
  late int employeeId;

  EmpProfileRepository() {
    // Initialize shared preferences and fetch data when the object is created.
    fetchSharedPrefData();
  }

  Future<void> fetchSharedPrefData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    coorporateId = pref.getString("corporate_id")!;
    employeeId = pref.getInt("employee_id")!;
    print(coorporateId);
    print(employeeId);
  }

  Future<List<EmpProfileModel>> getData() async {
    // Check if coorporateId and employeeId are initialized
    if (coorporateId.isEmpty || employeeId == 0) {
      throw Exception("coorporateId or employeeId not initialized");
    }

    String apiUrl =
        "http://62.171.184.216:9595/api/dashboard/profile?CorporateId=$coorporateId&employeeId=$employeeId";

    final headers = {
      'Content-Type': 'application/json', // Set the content type to JSON
    };

    final client = http.Client();

    final response = await client.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);

      // Create a list of EmpProfileModel instances by mapping the data
      final List<EmpProfileModel> empProfileList = responseData.map((item) {
        return EmpProfileModel(
          empName: item["empName"] ?? "",
          empCode: item["empCode"] ?? "",
          shiftCode: item["shiftCode"] ?? "",
          emailAddress: item["emailAddress"] ?? "",
          dateofJoin: item["dateofJoin"] != null
              ? DateTime.tryParse(item["dateofJoin"]) ?? DateTime.now()
              : DateTime.now(),
        );
      }).toList();

      return empProfileList;
    } else {
      throw Exception(
          "Failed to fetch data from the API. Status code: ${response.statusCode}");
    }
  }
}
