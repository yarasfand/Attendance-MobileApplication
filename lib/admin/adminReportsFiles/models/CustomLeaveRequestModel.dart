class CustomLeaveRequestModel {
  final String employeeId;
  final String fromDate;
  final String toDate;
  final String? reason;
  final int leaveId;
  final String? leaveDuration;
  final String approvedBy;
  final String status;
  final String applicationDate;
  final String? remark;

  CustomLeaveRequestModel({
    required this.employeeId,
    required this.fromDate,
    required this.toDate,
    this.reason,
    this.leaveId = 0,
    this.leaveDuration,
    required this.approvedBy,
    required this.status,
    required this.applicationDate,
    this.remark,
  });

  factory CustomLeaveRequestModel.fromJson(Map<String, dynamic> json) {
    return CustomLeaveRequestModel(
      employeeId: json['employeeId'],
      fromDate: json['fromDate'],
      toDate: json['toDate'],
      reason: json['reason'],
      leaveId: json['leaveId'] ?? 0,
      leaveDuration: json['leaveDuration'],
      approvedBy: json['approvedBy'],
      status: json['status'],
      applicationDate: json['applicationDate'],
      remark: json['remark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "employeeId": employeeId,
      "fromDate": fromDate,
      "toDate": toDate,
      "reason": reason,
      "leaveId": leaveId,
      "leaveDuration": leaveDuration,
      "approvedBy": approvedBy,
      "status": status,
      "applicationDate": applicationDate,
      "remark": remark,
    };
  }
}
