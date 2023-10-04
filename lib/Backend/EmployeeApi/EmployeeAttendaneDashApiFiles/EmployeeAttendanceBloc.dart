import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../EmployeeModels/EmployeeAttendanceStatusModel.dart';
import '../EmployeeRespository/EmployeeAttendanceStatusRepository.dart';
part 'EmployeeAttendanceEvent.dart';
part 'EmployeeAttendanceState.dart';

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
