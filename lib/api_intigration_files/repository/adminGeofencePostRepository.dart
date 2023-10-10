import 'dart:convert';
import 'dart:js_interop';
import 'package:http/http.dart' as http;
import '../models/adminGeofenceModel.dart';

class GeofencePostRepository {

  final String baseUrl =
      "http://62.171.184.216:9595/api/admin/location/setgeofence?CorporateId=ptsoffice";

  Future<void> postData(AdminGeofenceModel AdminGeofenceUpdateModel) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    final client = http.Client();

    final requestBody = jsonEncode(AdminGeofenceUpdateModel.toJson());

    try {
      final response = await client.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Request was successful
        print("Response submitted");
      } else {
        // Request failed, log status code and response content
        print("Failed to fetch data from the API. Status code: ${response.statusCode}");
        print("Response content: ${response.body}");
        throw Exception("Failed to fetch data from the API.");
      }
    } catch (e) {
      // Handle exceptions, such as network errors
      print("Error sending data: $e");
      throw Exception("Error sending data: $e");
    } finally {
      client.close(); // Close the HTTP client
    }
  }

  }