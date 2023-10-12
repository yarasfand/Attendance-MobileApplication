part of 'emp_leave_request_bloc.dart';

@immutable
abstract class EmpLeaveRequestState extends Equatable{}


class EmpLeaveRequestLoadingState extends EmpLeaveRequestState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class EmpLeaveRequestLoadedState extends EmpLeaveRequestState {
  EmpLeaveRequestLoadedState(this.users);
  final List<EmpLeaveModel> users;
  @override
  // TODO: implement props
  List<Object?> get props => [users];
}

class EmpLeaveRequestErrorState extends EmpLeaveRequestState {
  EmpLeaveRequestErrorState(this.message);
  final String message;
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
