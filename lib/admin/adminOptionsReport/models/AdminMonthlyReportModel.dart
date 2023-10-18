class AdminMonthlyReportsModel {
  int empId;
  DateTime? shiftStartTime;
  DateTime? shiftEndTime;
  int hoursWorked;
  int? otDuration;
  int earlyArrival;
  int earlyDeparture;
  int lateArrival;
  int totalLossHrs;
  String status;
  String? reason;
  String? shift;
  DateTime? in1;
  DateTime? in2;
  DateTime? out1;
  DateTime? out2;
  String remark;

  AdminMonthlyReportsModel({
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

  factory AdminMonthlyReportsModel.fromJson(Map<String, dynamic> json) {
    return AdminMonthlyReportsModel(
      empId: json['empId'],
      shiftStartTime: json['shiftstarttime'] != null
          ? DateTime.parse(json['shiftstarttime'])
          : null,
      shiftEndTime: json['shiftendtime'] != null
          ? DateTime.parse(json['shiftendtime'])
          : null,
      hoursWorked: json['hoursworked'],
      otDuration: json['otduration'],
      earlyArrival: json['earlyarrival'],
      earlyDeparture: json['earlydeparture'],
      lateArrival: json['latearrival'],
      totalLossHrs: json['totallosshrs'],
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
