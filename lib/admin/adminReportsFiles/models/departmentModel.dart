class Department {
  final int? deptId;
  final String? deptName;
  final String? deptDescription; // Use nullable type for potentially null properties
  final bool active;
  final DateTime onDate;
  final int byUser;
  final List<MstEmployee> mstEmployees;

  Department({
    required this.deptId,
    required this.deptName,
    this.deptDescription,
    required this.active,
    required this.onDate,
    required this.byUser,
    required this.mstEmployees,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      deptId: json['deptId'] as int?,
      deptName: json['deptName'] as String?,
      deptDescription: json['deptDescription'] as String?,
      active: json['active'] as bool? ?? false, // Handle null or incorrect types
      onDate: DateTime.parse(json['onDate'] as String),
      byUser: json['byUser'] as int? ?? 0, // Handle null or incorrect types
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
