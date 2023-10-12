class Company {
  final int companyId;
  final String companyName;
  final String description;
  final String address;
  final String phoneNo;
  final String emailId;
  final String vatNo;
  final String pfNo;
  final String tanNo;
  final String regNo;
  final String esiNo;
  final String panNo;
  final double pf;
  final double fpf;
  final double ppf;
  final double esi;
  final String addition1;
  final String addition2;
  final String addition3;
  final String addition4;
  final String addition5;
  final String addition6;
  final String addition7;
  final String addition8;
  final String addition9;
  final String addition10;
  final String ded1;
  final String ded2;
  final String ded3;
  final String ded4;
  final String ded5;
  final String fded1;
  final String fded2;
  final String fded3;
  final String fded4;
  final String fded5;
  final bool active;
  final DateTime onDate;
  final int? byUser;
  final List<MstEmployee> mstEmployees;

  Company({
    required this.companyId,
    required this.companyName,
    required this.description,
    required this.address,
    required this.phoneNo,
    required this.emailId,
    required this.vatNo,
    required this.pfNo,
    required this.tanNo,
    required this.regNo,
    required this.esiNo,
    required this.panNo,
    required this.pf,
    required this.fpf,
    required this.ppf,
    required this.esi,
    required this.addition1,
    required this.addition2,
    required this.addition3,
    required this.addition4,
    required this.addition5,
    required this.addition6,
    required this.addition7,
    required this.addition8,
    required this.addition9,
    required this.addition10,
    required this.ded1,
    required this.ded2,
    required this.ded3,
    required this.ded4,
    required this.ded5,
    required this.fded1,
    required this.fded2,
    required this.fded3,
    required this.fded4,
    required this.fded5,
    required this.active,
    required this.onDate,
    required this.byUser,
    required this.mstEmployees,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyId: json['companyId'] as int,
      companyName: json['companyName'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      phoneNo: json['phoneNo'] as String,
      emailId: json['emailId'] as String,
      vatNo: json['vatNo'] as String,
      pfNo: json['pfNo'] as String,
      tanNo: json['tanNo'] as String,
      regNo: json['regNo'] as String,
      esiNo: json['esiNo'] as String,
      panNo: json['panNo'] as String,
      pf: (json['pf'] as num).toDouble(),
      fpf: (json['fpf'] as num).toDouble(),
      ppf: (json['ppf'] as num).toDouble(),
      esi: (json['esi'] as num).toDouble(),
      addition1: json['addition1'] as String,
      addition2: json['addition2'] as String,
      addition3: json['addition3'] as String,
      addition4: json['addition4'] as String,
      addition5: json['addition5'] as String,
      addition6: json['addition6'] as String,
      addition7: json['addition7'] as String,
      addition8: json['addition8'] as String,
      addition9: json['addition9'] as String,
      addition10: json['addition10'] as String,
      ded1: json['ded1'] as String,
      ded2: json['ded2'] as String,
      ded3: json['ded3'] as String,
      ded4: json['ded4'] as String,
      ded5: json['ded5'] as String,
      fded1: json['fded1'] as String,
      fded2: json['fded2'] as String,
      fded3: json['fded3'] as String,
      fded4: json['fded4'] as String,
      fded5: json['fded5'] as String,
      active: json['active'] as bool? ?? false,
      onDate: DateTime.parse(json['onDate'] as String),
      byUser: json['byUser'] as int?,
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