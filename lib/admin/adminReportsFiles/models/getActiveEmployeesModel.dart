class GetActiveEmpModel {
  int? empId;
  String? empName;
  String? empCode;
  bool isSelected = false;
  String remarks;
  String? deptNames;
  String? branchNames;
  String? companyNames;

  GetActiveEmpModel({
    this.empId,
    this.empName,
    this.empCode,
    this.remarks = '',
    this.deptNames,
    this.branchNames,
    this.companyNames,
  });

  factory GetActiveEmpModel.fromJson(Map<String, dynamic> json) {
    return GetActiveEmpModel(
      empId: json['empId'] as int?,
      empName: json['empName'] as String?,
      empCode: json['empCode'] as String?,
      deptNames: json['deptNames'] as String?,
      branchNames: json['branchNames'] as String?,
      companyNames: json['companyNames'] as String?,
    );
  }
}
