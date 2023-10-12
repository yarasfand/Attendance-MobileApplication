part of 'leave_request_bloc.dart';

abstract class LeaveRequestState {
  const LeaveRequestState();
}

class LeaveRequestInitial extends LeaveRequestState {}

class LeaveRequestLoading extends LeaveRequestState {}

class LeaveRequestLoaded extends LeaveRequestState {
  final List<LeaveRequest> leaveRequests;

  const LeaveRequestLoaded({required this.leaveRequests});
}

class LeaveRequestError extends LeaveRequestState {
  final String error;

  const LeaveRequestError({required this.error});
}
