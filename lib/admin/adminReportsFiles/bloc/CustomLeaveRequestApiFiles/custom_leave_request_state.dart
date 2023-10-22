part of 'custom_leave_request_bloc.dart';

abstract class CustomLeaveRequestState {
  const CustomLeaveRequestState();
}

class CustomLeaveRequestInitial extends CustomLeaveRequestState {}

class CustomLeaveRequestLoading extends CustomLeaveRequestState {}

class CustomLeaveRequestSuccess extends CustomLeaveRequestState {}

class CustomLeaveRequestFailure extends CustomLeaveRequestState {
  final String error;

  CustomLeaveRequestFailure({required this.error});
}
