class MonthlyReportsModel {
  final String? dateOffice;
  final String? shiftStartTime;
  final String? shiftEndTime;
  final String? lunchStartTime;
  final String? lunchEndTime;
  final int? hoursWorked;
  final String? status;

  MonthlyReportsModel({
    required this.dateOffice,
    required this.shiftStartTime,
    required this.shiftEndTime,
    required this.lunchStartTime,
    required this.lunchEndTime,
    required this.hoursWorked,
    required this.status,
  });

  factory MonthlyReportsModel.fromJson(Map<String, dynamic> json) {
    return MonthlyReportsModel(
      dateOffice: json['dateOffice'] as String?,
      shiftStartTime: json['shiftstarttime'] as String?,
      shiftEndTime: json['shiftendtime'] as String?,
      lunchStartTime: json['lunchstarttime'] as String?,
      lunchEndTime: json['lunchendtime'] as String?,
      hoursWorked: json['hoursworked'] as int?,
      status: json['status'] as String?,
    );
  }
}
