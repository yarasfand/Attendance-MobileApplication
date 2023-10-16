part of 'monthly_reports_bloc.dart';

abstract class MonthlyReportsState {}

class MonthlyReportsInitial extends MonthlyReportsState {}

class MonthlyReportsLoading extends MonthlyReportsState {}

class MonthlyReportsLoaded extends MonthlyReportsState {
  final List<MonthlyReportsModel> reports;

  MonthlyReportsLoaded({required this.reports});
}

class MonthlyReportsError extends MonthlyReportsState {
  final String error;

  MonthlyReportsError({required this.error});
}
