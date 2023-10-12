class EmpDashModel {
  final int presentCount;
  final int absentCount;
  final int leaveCount;

  EmpDashModel({
    required this.presentCount,
    required this.absentCount,
    required this.leaveCount,
  });

  factory EmpDashModel.fromJson(Map<String, dynamic> json) {
    return EmpDashModel(
      presentCount: json['presentCount'] ?? 0,
      absentCount: json['absentCount'] ?? 0,
      leaveCount: json['leaveCount'] ?? 0,
    );
  }
}
