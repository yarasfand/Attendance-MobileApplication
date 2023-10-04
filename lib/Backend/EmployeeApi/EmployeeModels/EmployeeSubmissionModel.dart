
class SubmissionModel {
  final String employeeId;
  final String fromDate;
  final String toDate;
  final String reason;
  final int leaveId;
  final String leaveDuration;
  final String status;
  final String applicationDate;
  final String remark;

  SubmissionModel({
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

  Map<String, dynamic> toJson() {
    return {
      "employeeId": employeeId,
      "fromDate": fromDate,
      "toDate": toDate,
      "reason": reason,
      "leaveId": leaveId,
      "leaveDuration": leaveDuration,
      "status": status,
      "applicationDate": applicationDate,
      "remark": remark,
    };
  }
}
