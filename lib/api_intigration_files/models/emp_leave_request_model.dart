class EmpLeaveModel {
  final int leaveTypeId;
  final String ltypeCode;
  final String ltypeName;

  EmpLeaveModel({
    required this.leaveTypeId,
    required this.ltypeCode,
    required this.ltypeName,
  });

  factory EmpLeaveModel.fromJson(Map<String, dynamic> json) {
    return EmpLeaveModel(
      leaveTypeId: json['leaveTypeId'] ?? 0,
      ltypeCode: json['ltypeCode'] ?? '',
      ltypeName: json['ltypeName'] ?? '',
    );
  }
}
