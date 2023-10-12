import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../models/leaveRequestModel.dart';
import '../../models/leaveRequestRepository.dart';

part 'leave_request_event.dart';
part 'leave_request_state.dart';

class LeaveRequestBloc extends Bloc<LeaveRequestEvent, LeaveRequestState> {
  final LeaveRepository repository;

  LeaveRequestBloc({required this.repository}) : super(LeaveRequestInitial()) {
    on<FetchLeaveRequests>(_fetchLeaveRequests);
  }

  void _fetchLeaveRequests(
      FetchLeaveRequests event,
      Emitter<LeaveRequestState> emit,
      ) async {
    emit(LeaveRequestLoading());
    try {
      final List<Map<String, dynamic>> leaveRequestsData = await repository.fetchLeaveRequests();

      // Convert List<Map<String, dynamic>> to List<LeaveRequest>
      final List<LeaveRequest> leaveRequests = leaveRequestsData
          .map((data) => LeaveRequest.fromJson(data))
          .toList();

      emit(LeaveRequestLoaded(leaveRequests: leaveRequests));
    } catch (e) {
      emit(LeaveRequestError(error: e.toString()));
    }
  }

}
