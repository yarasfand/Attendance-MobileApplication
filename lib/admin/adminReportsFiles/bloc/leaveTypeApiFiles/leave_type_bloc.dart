import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../models/leaveTypeRepository.dart';
import 'leave_type_event.dart';
import 'leave_type_state.dart';

class LeaveTypeBloc extends Bloc<LeaveTypeEvent, LeaveTypeState> {
  final LeaveTypeRepository repository;

  LeaveTypeBloc({required this.repository}) : super(LeaveTypeInitial());

  @override
  Stream<LeaveTypeState> mapEventToState(LeaveTypeEvent event) async* {
    if (event is FetchLeaveTypes) {
      yield LeaveTypeLoading();
      try {
        final leaveTypes = await repository.fetchLeaveTypes();
        if (leaveTypes != null) {
          yield LeaveTypeLoaded(leaveTypes: leaveTypes);
        } else {
          yield LeaveTypeError(error: 'Failed to fetch leave types');
        }
      } catch (e) {
        yield LeaveTypeError(error: e.toString());
      }
    }
  }


}
