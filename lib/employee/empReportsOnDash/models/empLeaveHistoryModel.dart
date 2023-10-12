
class LeaveHistoryModel {
  final DateTime fromDate;
  final DateTime toDate;
  final String reason;
  final int leaveId;
  final String approvedStatus;
  final DateTime applicationDate;

  LeaveHistoryModel({
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.leaveId,
    required this.approvedStatus,
    required this.applicationDate,
  });

  factory LeaveHistoryModel.fromJson(Map<String, dynamic> json) {
    return LeaveHistoryModel(
      fromDate: json['fromdate'] != null ? DateTime.tryParse(json['fromdate']) ?? DateTime.now() : DateTime.now(),
      toDate: json['todate'] != null ? DateTime.tryParse(json['todate']) ?? DateTime.now() : DateTime.now(),
      reason: json['reason'] ?? "",
      leaveId: json['leaveid'] ?? 0,
      approvedStatus: json['approvedStatus'] ?? "",
      applicationDate: json['applicationDate'] != null
          ? DateTime.tryParse(json['applicationDate']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
