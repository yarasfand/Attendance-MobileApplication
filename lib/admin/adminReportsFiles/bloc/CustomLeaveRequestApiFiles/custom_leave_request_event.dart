part of 'custom_leave_request_bloc.dart';

abstract class CustomLeaveRequestEvent {
  const CustomLeaveRequestEvent();
}

class PostCustomLeaveRequest extends CustomLeaveRequestEvent {
  final CustomLeaveRequestModel leaveRequest;

  PostCustomLeaveRequest({required this.leaveRequest});
}
