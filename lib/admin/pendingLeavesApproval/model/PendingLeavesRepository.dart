import 'dart:convert';
import 'package:http/http.dart' as http;
import 'PendingLeavesModel.dart';

class PendingLeavesRepository {
  final String apiUrl = 'http://62.171.184.216:9595/api/admin/location/GetUnApproved?CorporateId=ptsoffice';

  Future<List<PendingLeavesModel>> fetchPendingLeaves() async {
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
