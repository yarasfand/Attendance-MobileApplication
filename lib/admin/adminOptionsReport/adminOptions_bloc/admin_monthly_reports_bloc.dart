import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/AdminMonthlyReportsRepository.dart';
import 'admin_monthly_reports_event.dart';
import 'admin_monthly_reports_state.dart';

class AdminMonthlyReportsBloc extends Bloc<AdminMonthlyReportsEvent, AdminMonthlyReportsState> {
  final AdminMonthlyReportsRepository repository;

  AdminMonthlyReportsBloc(this.repository) : super(AdminMonthlyReportsInitial()) {
    on<FetchAdminMonthlyReports>((event, emit) async {
      await _handleFetchAdminMonthlyReports(event, emit);
    });
  }

  Future<void> _handleFetchAdminMonthlyReports(FetchAdminMonthlyReports event, Emitter<AdminMonthlyReportsState> emit) async {
    try {
      final reports = await repository.fetchMonthlyReports(
        event.employeeIds,
        event.selectedMonth ?? 1,
        event.year
      );
      // Emit the loaded state with the fetched data
      emit(AdminMonthlyReportsLoaded(reports: reports));
    } catch (e) {
      emit(AdminMonthlyReportsError(errorMessage: e.toString()));
    }
  }

}
