part of 'daily_reports_bloc.dart';

abstract class DailyReportsState {}

class DailyReportsInitial extends DailyReportsState {}

class DailyReportsLoading extends DailyReportsState {}

class DailyReportsLoaded extends DailyReportsState {
  final List<DailyReportsModel> reports;

  DailyReportsLoaded(this.reports);
}

class DailyReportsError extends DailyReportsState {
  final String errorMessage;

  DailyReportsError(this.errorMessage);
}