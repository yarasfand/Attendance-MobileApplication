class Branch {
  final int branchId;
  final String branchName;
  final String address;
  final String phoneNo;
  final String emailId;
  final bool active;
  final DateTime onDate;
  final int byUser;
  final int companyId;
  final dynamic chk1;
  final dynamic chk2;
  final dynamic chk3;
  final dynamic chk4;
  final dynamic chk5;
  final dynamic chk6;
  final dynamic lat2;
  final dynamic log2;
  final dynamic lat3;
  final dynamic log3;
  final dynamic lat4;
  final dynamic log4;
  final dynamic lat5;
  final dynamic log5;
  final dynamic lat;
  final dynamic log;
  final dynamic arera;
  final List<MstEmployee> mstEmployees;

  Branch({
    required this.branchId,
    required this.branchName,
    required this.address,
    required this.phoneNo,
    required this.emailId,
    required this.active,
    required this.onDate,
    required this.byUser,
    required this.companyId,
    required this.chk1,
    required this.chk2,
    required this.chk3,
    required this.chk4,
    required this.chk5,
    required this.chk6,
    required this.lat2,
    required this.log2,
    required this.lat3,
    required this.log3,
    required this.lat4,
    required this.log4,
    required this.lat5,
    required this.log5,
    required this.lat,
    required this.log,
    required this.arera,
    required this.mstEmployees,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      branchId: json['branchId'] as int,
      branchName: json['branchName'] as String,
      address: json['address'] as String,
      phoneNo: json['phoneNo'] as String,
      emailId: json['emailId'] as String,
      active: json['active'] as bool? ?? false,
      onDate: DateTime.parse(json['onDate'] as String),
      byUser: json['byUser'] as int,
      companyId: json['companyId'] as int,
      chk1: json['chk1'],
      chk2: json['chk2'],
      chk3: json['chk3'],
      chk4: json['chk4'],
      chk5: json['chk5'],
      chk6: json['chk6'],
      lat2: json['lat2'],
      log2: json['log2'],
      lat3: json['lat3'],
      log3: json['log3'],
      lat4: json['lat4'],
      log4: json['log4'],
      lat5: json['lat5'],
      log5: json['log5'],
      lat: json['lat'],
      log: json['log'],
      arera: json['arera'],
      mstEmployees: (json['mstEmployees'] as List<dynamic>?)
          ?.map((e) => MstEmployee.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class MstEmployee {
  final int empId;
  final String empName;
  final String? empDescription; // Use nullable type for potentially null properties

  MstEmployee({
    required this.empId,
    required this.empName,
    this.empDescription,
  });

  factory MstEmployee.fromJson(Map<String, dynamic> json) {
    return MstEmployee(
      empId: json['empId'] as int,
      empName: json['empName'] as String,
      empDescription: json['empDescription'] as String?,
    );
  }
}

