import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../emp_attendance_status_model.dart';
import '../emp_attendance_status_repository.dart';

part 'emp_attendance_event.dart';
part 'emp_attendance_state.dart';

class EmpAttendanceBloc extends Bloc<EmpAttendanceEvent, EmpAttendanceState> {
  final EmpAttendanceRepository _empAttendanceRepository;

  EmpAttendanceBloc(this._empAttendanceRepository)
      : super(EmpAttendanceLoadingState()) {
    on<EmpAttendanceLoadingEvent>((event, emit) async {
      emit(EmpAttendanceLoadingState());
      try {
        final users = await _empAttendanceRepository.getData();
        emit(EmpAttendanceLoadedState([users]));
      } catch (e) {
        print("API Error: $e");
        emit(EmpAttendanceErrorState(
            "Failed to fetch data from the API: $e"));
      }
    });

    on<RefreshEmpAttendanceEvent>((event, emit) async {
      try {
        final refreshedUsers = await _empAttendanceRepository.getData();
        emit(EmpAttendanceLoadedState([refreshedUsers]));
      } catch (e) {
        print("API Error during refresh: $e");
        emit(EmpAttendanceErrorState("Failed to refresh data: $e"));
      }
    });
  }
}
