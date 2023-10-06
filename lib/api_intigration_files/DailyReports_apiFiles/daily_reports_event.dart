part of 'daily_reports_bloc.dart';

abstract class DailyReportsEvent {}

class FetchDailyReports extends DailyReportsEvent {
  final String corporateId;
  final int employeeId;
  final DateTime reportDate;

  FetchDailyReports({
    required this.corporateId,
    required this.employeeId,
    required this.reportDate,
  });
}