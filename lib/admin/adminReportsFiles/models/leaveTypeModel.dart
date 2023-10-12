class LeaveSubmissionRequestModel {
  final int leaveTypeId;
  final String ltypeCode;
  final String ltypeName;
  final bool weekOff;
  final bool holiday;
  final bool isAccrual;
  final String accrualType;
  final double fixmin;
  final double fixmax;
  final double carryPresent;
  final double carryLeave;
  final double maxAccrual;
  final bool paid;
  final DateTime onDate;
  final int byUser;

  LeaveSubmissionRequestModel({
    required this.leaveTypeId,
    required this.ltypeCode,
    required this.ltypeName,
    required this.weekOff,
    required this.holiday,
    required this.isAccrual,
    required this.accrualType,
    required this.fixmin,
    required this.fixmax,
    required this.carryPresent,
    required this.carryLeave,
    required this.maxAccrual,
    required this.paid,
    required this.onDate,
    required this.byUser,
  });

  factory LeaveSubmissionRequestModel.fromJson(Map<String, dynamic> json) {
    return LeaveSubmissionRequestModel(
      leaveTypeId: json['leaveTypeId'] ?? 0,
      ltypeCode: json['ltypeCode'] ?? "",
      ltypeName: json['ltypeName'] ?? "",
      weekOff: json['weekOff'] ?? false,
      holiday: json['holiday'] ?? false,
      isAccrual: json['isAccrual'] ?? false,
      accrualType: json['accrualType'] ?? "",
      fixmin: json['fixmin'] ?? 0.00,
      fixmax: json['fixmax'] ?? 0.00,
      carryPresent: json['carryPresent'] ?? 0.00,
      carryLeave: json['carryLeave'] ?? 0.00,
      maxAccrual: json['maxAccrual'] ?? 0.00,
      paid: json['paid'] ?? false,
      onDate: DateTime.tryParse(json['onDate'] ?? "") ?? DateTime.now(),
      byUser: json['byUser'] ?? 0,
    );
  }
}
