class EmpProfileModel {
  final String empName;
  final String empCode;
  final String shiftCode;
  final String emailAddress;
  final DateTime dateofJoin;

  EmpProfileModel({
    required this.empName,
    required this.empCode,
    required this.shiftCode,
    required this.emailAddress,
    required this.dateofJoin,
  });

  factory EmpProfileModel.fromJson(Map<String, dynamic> json) {
    return EmpProfileModel(
      empName: json['empName'] ?? '',
      empCode: json['empCode'] ?? '',
      shiftCode: json['shiftCode'] ?? '',
      emailAddress: json['emailAddress'] ?? '',
      dateofJoin: json['dateofJoin'] != null
          ? DateTime.tryParse(json['dateofJoin'] ?? '') ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
