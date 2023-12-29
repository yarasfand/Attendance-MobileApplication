import 'dart:async';
import 'package:bloc/bloc.dart';

import '../../models/getActiveEmployeeRepository.dart';
import 'get_active_employee_event.dart';
import 'get_active_employee_state.dart';

class GetEmployeeBloc
    extends Bloc<GetActiveEmployeeEvent, GetActiveEmployeeState> {
  final GetActiveEmpRepository repository;

  GetEmployeeBloc(this.repository) : super(GetEmployeeInitial()) {
    // Add event handler
    on<FetchEmployees>((event, emit) async {
      await fetchEmployees(event, emit);
    });
  }

  fetchEmployees(
      FetchEmployees event, Emitter<GetActiveEmployeeState> emit) async {
    emit(GetEmployeeLoading());
    try {
      final employees = await repository.getActiveEmployees();
      emit(GetEmployeeLoaded(employees));
    } catch (e) {
      emit(GetEmployeeError('Failed to fetch employees: $e'));
    }
  }
}
