import 'package:equatable/equatable.dart';

abstract class AdminReportsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchDailyReportsEvent extends AdminReportsEvent {
  final List<int> employeeIds;
  final String reportDate;

  FetchDailyReportsEvent(this.employeeIds, this.reportDate);

  @override
  List<Object> get props => [employeeIds, reportDate];
}
