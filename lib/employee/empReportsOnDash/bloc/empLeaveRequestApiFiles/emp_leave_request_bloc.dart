import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/empLeaveRequestModel.dart';
import '../../models/empLeaveRequestRepository.dart';

part 'emp_leave_request_event.dart';
part 'emp_leave_request_state.dart';

class EmpLeaveRequestBloc
    extends Bloc<EmpLeaveRequestEvent, EmpLeaveRequestState> {
  final EmpLeaveRepository _empLeaveRepository;
  EmpLeaveRequestBloc(this._empLeaveRepository)
      : super(EmpLeaveRequestLoadingState()) {
    on<EmpLeaveRequestLoadingEvent>((event, emit) async {
      emit(EmpLeaveRequestLoadingState());
      try {
        final users = await _empLeaveRepository.getData();
        emit(EmpLeaveRequestLoadedState(users));
      } catch (e) {
        print("API Error: $e"); // Add this line to print the error message
        emit(
            EmpLeaveRequestErrorState("Failed to fetch data from the API: $e"));
      }
      // print("hey you emit first state");
    });
  }

}
