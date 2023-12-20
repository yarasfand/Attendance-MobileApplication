part of 'emp_attendance_bloc.dart';

@immutable
abstract class EmpAttendanceEvent extends Equatable {
  const EmpAttendanceEvent();

  @override
  List<Object> get props => [];
}

class EmpAttendanceLoadingEvent extends EmpAttendanceEvent {}

class RefreshEmpAttendanceEvent extends EmpAttendanceEvent {}
