part of 'emp_post_request_bloc.dart';

@immutable
abstract class EmpPostRequestEvent extends Equatable {
  List<Object> get props => [];
}

class Create extends EmpPostRequestEvent {
  final String employeeId;
  final String fromDate;
  final String toDate;
  final String reason;
  final int leaveId;
  final String leaveDuration;
  final String status;
  final String applicationDate;
  final String remark;

  Create(
      this.employeeId,
      this.fromDate,
      this.toDate,
      this.reason,
      this.leaveId,
      this.leaveDuration,
      this.status,
      this.applicationDate,
      this.remark,
      );
}
