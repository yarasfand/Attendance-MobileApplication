class LeaveSubmissionModel {
  final String employeeId;
  final String fromDate;
  final String toDate;
  final String reason;
  final int leaveId;
  final String leaveDuration;
  final String status;
  final String applicationDate;
  final String remark;

  LeaveSubmissionModel({
    required this.employeeId,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.leaveId,
    required this.leaveDuration,
    required this.status,
    required this.applicationDate,
    required this.remark,
  });

  factory LeaveSubmissionModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw FormatException("Invalid JSON data");
    }

    return LeaveSubmissionModel(
      employeeId: json['employeeId'] ?? '',
      fromDate: json['fromDate'] ?? '',
      toDate: json['toDate'] ?? '',
      reason: json['reason'] ?? '',
      leaveId: json['leaveId'] ?? 0,
      leaveDuration: json['leaveDuration'] ?? '',
      status: json['status'] ?? '',
      applicationDate: json['applicationDate'] ?? '',
      remark: json['remark'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'fromDate': fromDate,
      'toDate': toDate,
      'reason': reason,
      'leaveId': leaveId,
      'leaveDuration': leaveDuration,
      'status': status,
      'applicationDate': applicationDate,
      'remark': remark,
    };
  }
}
