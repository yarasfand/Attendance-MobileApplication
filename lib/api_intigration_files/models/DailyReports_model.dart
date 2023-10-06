class DailyReportsModel {
  final String? payCode;
  final DateTime? shiftStartTime;
  final DateTime? shiftEndTime;
  final DateTime? lunchStartTime;
  final DateTime? lunchEndTime;
  final int? hoursWorked;
  final String? status;

  DailyReportsModel({
    this.payCode,
    this.shiftStartTime,
    this.shiftEndTime,
    this.lunchStartTime,
    this.lunchEndTime,
    this.hoursWorked,
    this.status,
  });

  factory DailyReportsModel.fromJson(Map<String, dynamic> json) {
    return DailyReportsModel(
      payCode: json['paycode'],
      shiftStartTime: _parseDateTime(json['shiftstarttime']),
      shiftEndTime: _parseDateTime(json['shiftendtime']),
      lunchStartTime: _parseDateTime(json['lunchstarttime']),
      lunchEndTime: _parseDateTime(json['lunchendtime']),
      hoursWorked: json['hoursworked'],
      status: json['status'],
    );
  }

  static DateTime? _parseDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return null;
    }
    try {
      return DateTime.parse(dateTimeString);
    } catch (e) {
      print('Error parsing DateTime: $e');
      return null;
    }
  }
}
