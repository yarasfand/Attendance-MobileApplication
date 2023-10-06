part of 'emp_leave_history_bloc.dart';

@immutable
abstract class EmpLeaveHistoryState extends Equatable{}

class EmpLeaveHistoryLoadingState extends EmpLeaveHistoryState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class EmpLeaveHistoryLoadedState extends EmpLeaveHistoryState {
  EmpLeaveHistoryLoadedState(this.users);
  final List<LeaveHistoryModel> users;
  @override
  // TODO: implement props
  List<Object?> get props => [users];
}

class EmpLeaveHistoryErrorState extends EmpLeaveHistoryState {
  EmpLeaveHistoryErrorState(this.message);
  final String message;
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
