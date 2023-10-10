class AdminGeofenceModel {
  final int empId;
  final String empName;
  final String fatherName;
  final String pwd;
  final String emailAddress;
  final String phoneNo;
  final String profilePic;
  final String lat;
  final String lon;
  final String radius;

  AdminGeofenceModel({
    required this.empId,
    required this.empName,
    required this.fatherName,
    required this.pwd,
    required this.emailAddress,
    required this.phoneNo,
    required this.profilePic,
    required this.lat,
    required this.lon,
    required this.radius,
  });

  factory AdminGeofenceModel.fromJson(Map<String, dynamic> json) {
    return AdminGeofenceModel(
      empId: json['empId'] as int? ?? 0,
      empName: json['empName'] as String? ?? '',
      fatherName: json['fatherName'] as String? ?? '',
      pwd: json['pwd'] as String? ?? '',
      emailAddress: json['emailAddress'] as String? ?? '',
      phoneNo: json['phoneNo'] as String? ?? '',
      profilePic: json['profilePic'] as String? ?? '',
      lat: json['lat'] as String? ?? '',
      lon: json['lon'] as String? ?? '',
      radius: json['radius'] as String? ?? '',
    );
  }

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
