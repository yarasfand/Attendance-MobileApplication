import 'dart:async';
import 'package:bloc/bloc.dart';

import '../../models/MonthlyReports_repository.dart';
import '../../models/empMonthlyReportsModel.dart';



part 'monthly_reports_event.dart';
part 'monthly_reports_state.dart';

class MonthlyReportsBloc extends Bloc<MonthlyReportsEvent, MonthlyReportsState> {
  final MonthlyReportsRepository repository;

  MonthlyReportsBloc({required this.repository}) : super(MonthlyReportsInitial()) {
    on<FetchMonthlyReports>((event, emit) async {
      if (event is FetchMonthlyReports) {
        emit(MonthlyReportsLoading());

        try {
          final reports = await repository.getMonthlyReports(

            month: event.month,
            year: event.year,
          );

          emit(MonthlyReportsLoaded(reports: reports));
        } catch (e) {
          emit(MonthlyReportsError(error: 'Failed to load daily reports: $e'));
        }
      }
    });
  }

  @override
  Stream<MonthlyReportsState> mapEventToState(MonthlyReportsEvent event) async* {
    // You don't need to add event handling logic here anymore,
    // as it's handled by the registered event handler using 'on'.
  }
}

