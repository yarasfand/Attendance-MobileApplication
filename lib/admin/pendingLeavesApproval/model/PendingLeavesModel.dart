import 'package:intl/intl.dart';

class PendingLeavesModel {
  final int id;
  final String cardNo;
  final String empName;
  final String deptName;
  final DateTime punchDatetime;
  final String location;
  final double latitude;
  final double longitude;
  final String? imageData;
  final String imeiNo;
  final String? temp1;
  final String? temp2;
  final String? attendanceType;
  final String? remark1;
  final String imagepath;

  PendingLeavesModel({
    required this.id,
    required this.cardNo,
    required this.empName,
    required this.deptName,
    required this.punchDatetime,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.imageData,
    required this.imeiNo,
    this.temp1,
    this.temp2,
    this.attendanceType,
    this.remark1,
    required this.imagepath,
  });

  factory PendingLeavesModel.fromJson(Map<String, dynamic> json) {
    return PendingLeavesModel(
      id: json['id'] ?? 0,
      cardNo: json['cardNo'] ?? '',
      empName: json['empName'] ?? '',
      deptName: json['deptName'] ?? '',
      punchDatetime: parseApiDate(json['punchDatetime'] ?? ''),
      location: json['location'] ?? '',
      latitude: double.tryParse(json['lan'] ?? '') ?? 0.0,
      longitude: double.tryParse(json['long'] ?? '') ?? 0.0,
      imageData: json['imageData'],
      imeiNo: json['imeiNo'] ?? '',
      temp1: json['temp1'],
      temp2: json['temp2'],
      attendanceType: json['attendanceType'],
      remark1: json['remark1'],
      imagepath: json['imagepath'] ?? '',
    );
  }

  static DateTime parseApiDate(String dateString) {
    final format = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    try {
      return format.parse(dateString);
    } catch (e) {
      // Handle date parsing error, return the current date as a fallback
      print('Error parsing date: $e');
      return DateTime.now();
    }
  }

}
