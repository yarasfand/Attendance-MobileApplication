class DailyReportsModel {
  final String? payCode;
  final DateTime? shiftStartTime;
  final DateTime? shiftEndTime;
  final DateTime? lunchStartTime;
  final DateTime? lunchEndTime;
  final DateTime? in1;
  final DateTime? out2;
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
    this.in1,
    this.out2
  });

  factory DailyReportsModel.fromJson(Map<String, dynamic> json) {
    return DailyReportsModel(
      payCode: json['paycode'],
      shiftStartTime: _parseDateTime(json['shiftstarttime']),
      shiftEndTime: _parseDateTime(json['shiftendtime']),
      lunchStartTime: _parseDateTime(json['lunchstarttime']),
      lunchEndTime: _parseDateTime(json['lunchendtime']),
      in1: _parseDateTime(json['in1']),
      out2: _parseDateTime(json['out2']),
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
