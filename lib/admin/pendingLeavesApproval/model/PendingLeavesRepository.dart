import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'PendingLeavesModel.dart';

class PendingLeavesRepository {

  Future<List<PendingLeavesModel>> fetchPendingLeaves() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String corporateId = prefs.getString("corporate_id") ?? "ptsoffice";
    print(corporateId);
    final String apiUrl = 'http://62.171.184.216:9595/api/admin/location/GetUnApproved?CorporateId=$corporateId';

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      print('Received JSON Data: $jsonList');
      List<PendingLeavesModel> pendingLeavesList = jsonList
          .map((data) => PendingLeavesModel.fromJson(data))
          .toList();
      return pendingLeavesList;
    } else {
      throw Exception('Failed to load pending leaves data');
    }
  }
}
