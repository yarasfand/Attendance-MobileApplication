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
      hoursWorked: json['hoursworked'] != null
          ? (json['hoursworked'] is int ? json['hoursworked'] : 0)
          : 0,
      otDuration: json['otduration'],
      earlyArrival: json['earlyarrival'] != null
          ? (json['earlyarrival'] is int ? json['earlyarrival'] : 0)
          : 0,
      earlyDeparture: json['earlydeparture'] != null
          ? (json['earlydeparture'] is int ? json['earlydeparture'] : 0)
          : 0,
      lateArrival: json['latearrival'] != null
          ? (json['latearrival'] is int ? json['latearrival'] : 0)
          : 0,
      totalLossHrs: json['totallosshrs'] != null
          ? (json['totallosshrs'] is int ? json['totallosshrs'] : 0)
          : 0,
      status: json['status'] ?? "",  // Default to empty string if null
      reason: json['reason'] ?? "",  // Default to empty string if null
      shift: json['shift'] ?? "",  // Default to empty string if null
      in1: json['in1'] != null ? DateTime.parse(json['in1']) : null,
      in2: json['in2'] != null ? DateTime.parse(json['in2']) : null,
      out1: json['out1'] != null ? DateTime.parse(json['out1']) : null,
      out2: json['out2'] != null ? DateTime.parse(json['out2']) : null,
      remark: json['remark'] ?? "",  // Default to empty string if null
    );
  }
}
