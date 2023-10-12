import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:project/admin/adminReportsFiles/bloc/unApprovedLeaveRequestApiFiles/un_approved_leave_request_event.dart';
import 'package:project/admin/adminReportsFiles/bloc/unApprovedLeaveRequestApiFiles/un_approved_leave_request_state.dart';
import '../../models/unApprovedLeaveRequestRepository.dart';

class UnapprovedLeaveRequestBloc
    extends Bloc<UnapprovedLeaveRequestEvent, UnapprovedLeaveRequestState> {
  final UnApprovedLeaveRepository repository;

  UnapprovedLeaveRequestBloc({required this.repository})
      : super(UnapprovedLeaveRequestInitial()) {
    // Register event handlers for FetchUnapprovedLeaveRequests
    on<FetchUnapprovedLeaveRequests>(_fetchUnapprovedLeaveRequests);
  }

  void _fetchUnapprovedLeaveRequests(
      FetchUnapprovedLeaveRequests event,
      Emitter<UnapprovedLeaveRequestState> emit,
      ) async {
    emit(UnapprovedLeaveRequestLoading());
    try {
      final unapprovedLeaveRequests =
      await repository.fetchUnApprovedLeaveRequests();
      emit(UnapprovedLeaveRequestLoaded(
        unapprovedLeaveRequests: unapprovedLeaveRequests,
      ));
    } catch (e) {
      emit(UnapprovedLeaveRequestError(error: e.toString()));
    }
  }
}
