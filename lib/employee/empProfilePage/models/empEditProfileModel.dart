
class EmpEditProfileModel {
  final int? empId;
  final String empName;
  final String fatherName;
  final String pwd;
  final String emailAddress;
  final String phoneNo;
  final dynamic profilePic;

  EmpEditProfileModel({
    required this.empId,
    required this.empName,
    required this.fatherName,
    required this.pwd,
    required this.emailAddress,
    required this.phoneNo,
    required this.profilePic,
  });

  Map<String, dynamic> toJson() {
    return {
      "empId": empId,
      "empName": empName,
      "fatherName": fatherName,
      "pwd": pwd,
      "emailAddress": emailAddress,
      "phoneNo": phoneNo,
      "profilePic": profilePic,
    };
  }
}
