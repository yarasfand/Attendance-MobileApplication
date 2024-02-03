// admin_monthly_reports_event.dart

import 'package:equatable/equatable.dart';

abstract class AdminMonthlyReportsEvent extends Equatable {
  const AdminMonthlyReportsEvent();

  @override
  List<Object> get props => [];
}

class FetchAdminMonthlyReports extends AdminMonthlyReportsEvent {
  final List<int> employeeIds;
  final String corporateId;
  final int employeeId;
  final int selectedMonth;
  final int year;

  FetchAdminMonthlyReports({
    required this.employeeIds,
    required this.corporateId,
    required this.employeeId,
    required this.selectedMonth,
    required this.year,
  });

  @override
  List<Object> get props => [employeeIds, corporateId, employeeId, selectedMonth];
}
