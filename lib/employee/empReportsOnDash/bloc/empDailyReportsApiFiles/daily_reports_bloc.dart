import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/DailyReport_repository.dart';
import '../../models/DailyReports_model.dart';
part 'daily_reports_event.dart';
part 'daily_reports_state.dart';

class DailyReportsBloc extends Bloc<DailyReportsEvent, DailyReportsState> {
  final DailyReportsRepository repository;

  DailyReportsBloc(this.repository) : super(DailyReportsInitial());

  @override
  Stream<DailyReportsState> mapEventToState(DailyReportsEvent event) async* {
    if (event is FetchDailyReports) {
      yield DailyReportsLoading();

      try {
        final reports = await repository.getDailyReports(
          reportDate: event.reportDate,
        );

        yield DailyReportsLoaded(reports);
      } catch (e) {
        yield DailyReportsError('Failed to load daily reports: $e');
      }
    }
  }
}
