class AdminProfileModel {
  String? userLoginId;
  String userName;
  String userPassword;
  String email;
  String mobile;
  String onDate;

  AdminProfileModel({
    this.userLoginId,
    required this.userName,
    required this.userPassword,
    required this.email,
    required this.mobile,
    required this.onDate,
  });

  factory AdminProfileModel.fromJson(Map<String, dynamic> json) {
    return AdminProfileModel(
      userLoginId: json['userLoginId'] as String?,
      userName: json['userName'] as String? ?? '',
      userPassword: json['userPassword'] as String? ?? '',
      email: json['email'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      onDate: json['onDate'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userLoginId'] = this.userLoginId;
    data['userName'] = this.userName;
    data['userPassword'] = this.userPassword;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['onDate'] = this.onDate;
    return data;
  }
}
