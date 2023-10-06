import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../models/emp_attendance_status_model.dart';
import '../repository/emp_attendance_status_repository.dart';
part 'emp_attendance_event.dart';
part 'emp_attendance_state.dart';

class EmpAttendanceBloc extends Bloc<EmpAttendanceEvent, EmpAttendanceState> {
  final EmpAttendanceRepository _empAttendanceRepository;
  EmpAttendanceBloc(this._empAttendanceRepository) : super(EmpAttendanceLoadingState()) {
    on<EmpAttendanceLoadingEvent>((event, emit) async {
      emit(EmpAttendanceLoadingState());
      try{
        final users=await _empAttendanceRepository.getData();
        emit(EmpAttendanceLoadedState([users]));
      }
      catch (e) {
        print("API Error: $e"); // Add this line to print the error message
        emit(EmpAttendanceErrorState("Failed to fetch data from the API: $e"));
      }
      // print("hey you emit first state");
    });

  }
}
