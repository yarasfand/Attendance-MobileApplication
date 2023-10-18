class AdminDailyReportsModel {
  final int empId;
  final DateTime? shiftStartTime;
  final DateTime? shiftEndTime;
  final double hoursWorked;
  final double? otDuration;
  final double earlyArrival;
  final double earlyDeparture;
  final double lateArrival;
  final double totalLossHrs;
  final String status;
  final String? reason;
  final String? shift;
  final DateTime? in1;
  final DateTime? in2;
  final DateTime? out1;
  final DateTime? out2;
  final String remark;

  AdminDailyReportsModel({
    required this.empId,
    this.shiftStartTime,
    this.shiftEndTime,
    required this.hoursWorked,
    this.otDuration,
    required this.earlyArrival,
    required this.earlyDeparture,
    required this.lateArrival,
    required this.totalLossHrs,
    required this.status,
    this.reason,
    this.shift,
    this.in1,
    this.in2,
    this.out1,
    this.out2,
    required this.remark,
  });

  factory AdminDailyReportsModel.fromJson(Map<String, dynamic> json) {
    return AdminDailyReportsModel(
      empId: json['empId'],
      shiftStartTime: json['shiftstarttime'] != null
          ? DateTime.parse(json['shiftstarttime'])
          : null,
      shiftEndTime: json['shiftendtime'] != null
          ? DateTime.parse(json['shiftendtime'])
          : null,
      hoursWorked: json['hoursworked'].toDouble(),
      otDuration: json['otduration'] != null
          ? json['otduration'].toDouble()
          : null,
      earlyArrival: json['earlyarrival'].toDouble(),
      earlyDeparture: json['earlydeparture'].toDouble(),
      lateArrival: json['latearrival'].toDouble(),
      totalLossHrs: json['totallosshrs'].toDouble(),
      status: json['status'],
      reason: json['reason'],
      shift: json['shift'],
      in1: json['in1'] != null ? DateTime.parse(json['in1']) : null,
      in2: json['in2'] != null ? DateTime.parse(json['in2']) : null,
      out1: json['out1'] != null ? DateTime.parse(json['out1']) : null,
      out2: json['out2'] != null ? DateTime.parse(json['out2']) : null,
      remark: json['remark'],
    );
  }
}
