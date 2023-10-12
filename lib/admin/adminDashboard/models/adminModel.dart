class AdminModel {
  final int userId;
  final String userLoginId;
  final String userName;
  final String userPassword;
  final int parentUserId;
  final bool userEnabled;
  final String email;
  final String mobile;
  final DateTime onDate;
  final String per;
  final String branchPer;
  final String companyPer;
  final String deptPer;
  final String allowAccess;
  final String leaveAccess;
  final String deviceToken;
  final int type;
  final int adminNotification;
  final String departmentPer;
  final int visitorPer;

  AdminModel({
    required this.userId,
    required this.userLoginId,
    required this.userName,
    required this.userPassword,
    required this.parentUserId,
    required this.userEnabled,
    required this.email,
    required this.mobile,
    required this.onDate,
    required this.per,
    required this.branchPer,
    required this.companyPer,
    required this.deptPer,
    required this.allowAccess,
    required this.leaveAccess,
    required this.deviceToken,
    required this.type,
    required this.adminNotification,
    required this.departmentPer,
    required this.visitorPer,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      userId: json['userId'] ?? 0,
      userLoginId: json['userLoginId'] ?? '',
      userName: json['userName'] ?? '',
      userPassword: json['userPassword'] ?? '',
      parentUserId: json['parentUserId'] ?? 0,
      userEnabled: json['userEnabled'] ?? false,
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      onDate: DateTime.parse(json['onDate'] ?? ''),
      per: json['per'] ?? '',
      branchPer: json['branchPer'] ?? '',
      companyPer: json['companyPer'] ?? '',
      deptPer: json['deptPer'] ?? '',
      allowAccess: json['allowAccess'] ?? '',
      leaveAccess: json['leaveaccess'] ?? '',
      deviceToken: json['deviceToken'] ?? '',
      type: json['type'] ?? 0,
      adminNotification: json['adminnotification'] ?? 0,
      departmentPer: json['departmentPer'] ?? '',
      visitorPer: json['visitorPer'] ?? 0,
    );
  }
}
