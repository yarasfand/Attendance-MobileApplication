class EmpAttendanceModel {
  final DateTime? in1;
  final DateTime? out2;
  final String? status;

  EmpAttendanceModel({
    this.in1,
    this.out2,
    this.status,
  });

  factory EmpAttendanceModel.fromJson(Map<String, dynamic> json) {
    return EmpAttendanceModel(
      in1: json['in1'] != null ? DateTime.parse(json['in1']) : null,
      out2: json['out2'] != null ? DateTime.parse(json['out2']) : null,
      status: json['status'],
    );
  }
}
