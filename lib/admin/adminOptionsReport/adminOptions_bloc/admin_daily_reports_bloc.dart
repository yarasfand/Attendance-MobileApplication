import 'dart:async';
import 'package:bloc/bloc.dart';

import '../models/AdminDailyReportsRepository.dart';
import 'admin_daily_reports_event.dart';
import 'admin_daily_reports_state.dart';


class AdminReportsBloc extends Bloc<AdminReportsEvent, AdminReportsState> {
  final AdminReportsRepository repository;

  AdminReportsBloc(this.repository) : super(AdminReportsInitialState());

  @override
  Stream<AdminReportsState> mapEventToState(AdminReportsEvent event) async* {
    if (event is FetchDailyReportsEvent) {
      yield AdminReportsLoadingState();
      try {
        final reports = await repository.fetchDailyReports(event.employeeIds, event.reportDate);
        yield AdminReportsLoadedState(reports: reports);
      } catch (e) {
        yield AdminReportsErrorState(error: e.toString());
      }
    }
  }
}
