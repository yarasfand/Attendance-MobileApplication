part of 'monthly_reports_bloc.dart';

abstract class MonthlyReportsEvent {}

class FetchMonthlyReports extends MonthlyReportsEvent {
  final String corporateId;
  final int employeeId;
  final int month;
  final int year;

  FetchMonthlyReports({
    required this.corporateId,
    required this.employeeId,
    required this.month,
    required this.year,
  });
}
