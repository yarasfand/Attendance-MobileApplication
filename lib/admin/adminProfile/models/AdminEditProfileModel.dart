class AdminEditProfile {
  final String userLoginId;
  final String userName;
  final String userPassword;
  final String email;
  final String mobile;

  AdminEditProfile({
    required this.userLoginId,
    required this.userName,
    required this.userPassword,
    required this.email,
    required this.mobile,
  });

  factory AdminEditProfile.fromJson(Map<String, dynamic> json) {
    return AdminEditProfile(
      userLoginId: json['UserLoginId'] as String,
      userName: json['UserName'] as String,
      userPassword: json['UserPassword'] as String,
      email: json['Email'] as String,
      mobile: json['Mobile'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserLoginId': userLoginId,
      'UserName': userName,
      'UserPassword': userPassword,
      'Email': email,
      'Mobile': mobile,
    };
  }
}
