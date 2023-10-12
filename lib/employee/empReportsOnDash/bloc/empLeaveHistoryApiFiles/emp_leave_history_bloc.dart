import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/LeaveHistory_repository.dart';
import '../../models/empLeaveHistoryModel.dart';

part 'emp_leave_history_event.dart';
part 'emp_leave_history_state.dart';

class EmpLeaveHistoryBloc extends Bloc<EmpLeaveHistoryEvent, EmpLeaveHistoryState> {
  final LeaveHistoryRepository _leaveHistoryRepository;

  EmpLeaveHistoryBloc(this._leaveHistoryRepository) : super(EmpLeaveHistoryLoadingState()) {
    on<EmpLeaveHistoryLoadingEvent>((event, emit) async {
      emit(EmpLeaveHistoryLoadingState());
      try {
        final users = await _leaveHistoryRepository.getLeaveHistory();
        emit(EmpLeaveHistoryLoadedState(users)); // Assuming EmpLeaveHistoryLoadedState constructor expects List<LeaveHistoryModel>
      } catch (e) {
        print("API Error: $e");
        emit(EmpLeaveHistoryErrorState("Failed to fetch data from the API: $e"));
      }
    });
  }
}
