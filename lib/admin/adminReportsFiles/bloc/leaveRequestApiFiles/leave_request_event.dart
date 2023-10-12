part of 'leave_request_bloc.dart';

abstract class LeaveRequestEvent {
  const LeaveRequestEvent();
}

class FetchLeaveRequests extends LeaveRequestEvent {}
