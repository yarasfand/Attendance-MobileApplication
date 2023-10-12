class AdminDashBoard {
  final int presentCount;
  final int absentCount;
  final int lateCount;
  final int totalEmployeeCount;

  AdminDashBoard({
    required this.presentCount,
    required this.absentCount,
    required this.lateCount,
    required this.totalEmployeeCount,
  });

  factory AdminDashBoard.fromJson(Map<String, dynamic> json) {
    return AdminDashBoard(
      presentCount: json['presentCount'] ?? 0,
      absentCount: json['absentCount'] ?? 0,
      lateCount: json['lateCount'] ?? 0,
      totalEmployeeCount: json['totalEmployeeCount'] ?? 0,
    );
  }
}
