  import 'dart:async';
  import 'package:bloc/bloc.dart';
  import 'package:project/admin/adminReportsFiles/bloc/unApprovedLeaveRequestApiFiles/un_approved_leave_request_event.dart';
  import 'package:project/admin/adminReportsFiles/bloc/unApprovedLeaveRequestApiFiles/un_approved_leave_request_state.dart';
  import '../../models/unApprovedLeaveRequestRepository.dart';
  // un_approved_leave_request_bloc.dart

  class UnapprovedLeaveRequestBloc
      extends Bloc<UnapprovedLeaveRequestEvent, UnapprovedLeaveRequestState> {
    final UnApprovedLeaveRepository repository;

    UnapprovedLeaveRequestBloc({required this.repository})
        : super(UnapprovedLeaveRequestInitial()) {
      // Register event handlers
      on<FetchUnapprovedLeaveRequests>(_fetchUnapprovedLeaveRequests);
      on<ClearUnapprovedLeaveRequests>(_clearUnapprovedLeaveRequests);
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

    void _clearUnapprovedLeaveRequests(
        ClearUnapprovedLeaveRequests event,
        Emitter<UnapprovedLeaveRequestState> emit,
        ) {
      emit(UnapprovedLeaveRequestInitial());
    }

    // Explicitly fetch unapproved leave requests when needed
    Future<void> fetchUnapprovedLeaveRequests() async {
      add(FetchUnapprovedLeaveRequests());
    }

    // Add a method to clear unapproved leave requests when needed
    void clearUnapprovedLeaveRequests() {
      add(ClearUnapprovedLeaveRequests());
    }
  }
