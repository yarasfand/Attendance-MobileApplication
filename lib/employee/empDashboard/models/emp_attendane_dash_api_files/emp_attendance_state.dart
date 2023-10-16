part of 'emp_attendance_bloc.dart';

@immutable
abstract class EmpAttendanceState extends Equatable {}

class EmpAttendanceLoadingState extends EmpAttendanceState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class EmpAttendanceLoadedState extends EmpAttendanceState {
  EmpAttendanceLoadedState(this.users);
  final List<EmpAttendanceModel> users;
  @override
  // TODO: implement props
  List<Object?> get props => [users];
}

class EmpAttendanceErrorState extends EmpAttendanceState {
  EmpAttendanceErrorState(this.message);
  final String message;
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
