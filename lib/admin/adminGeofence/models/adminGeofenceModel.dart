
class AdminGeoFenceModel {
  final int empId;
  final String? empName;
  final String? fatherName;
  final String? pwd;
  final String? emailAddress;
  final String? phoneNo;
  final String? profilePic;
  final String lat;
  final String lon;
  final String radius;

  AdminGeoFenceModel({
    required this.empId,
    this.empName,
    this.fatherName,
    this.pwd,
    this.emailAddress,
    this.phoneNo,
    this.profilePic,
    required this.lat,
    required this.lon,
    required this.radius,
  });

  Map<String, dynamic> toJson() {
    return {
      'empId': empId,
      'empName': empName,
      'fatherName': fatherName,
      'pwd': pwd,
      'emailAddress': emailAddress,
      'phoneNo': phoneNo,
      'profilePic': profilePic,
      'lat': lat,
      'lon': lon,
      'radius': radius,
    };
  }
}



