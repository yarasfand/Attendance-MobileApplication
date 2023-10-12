class AdminGeoFenceModel {
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

  AdminGeoFenceModel({
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

  factory AdminGeoFenceModel.fromJson(Map<String, dynamic> json) {
    return AdminGeoFenceModel(
      empId: json['empId'] ?? 0,
      empName: json['empName'] ?? '',
      fatherName: json['fatherName'] ?? '',
      pwd: json['pwd'] ?? '',
      emailAddress: json['emailAddress'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      profilePic: json['profilePic'] ?? '',
      lat: json['lat'] ?? '',
      lon: json['lon'] ?? '',
      radius: json['radius'] ?? '',
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
