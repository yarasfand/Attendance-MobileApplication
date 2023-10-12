import 'package:equatable/equatable.dart';

abstract class LeaveSubmissionEvent extends Equatable {
  const LeaveSubmissionEvent();

  @override
  List<Object> get props => [];
}

class SubmitLeaveRequest extends LeaveSubmissionEvent {
  final String employeeId;
  final String fromDate;
  final String toDate;
  final String reason;
  final String leaveDuration;
  final String remark;

  SubmitLeaveRequest({
    required this.employeeId,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.leaveDuration,
    required this.remark,
  });

  @override
  List<Object> get props => [employeeId, fromDate, toDate, reason, leaveDuration, remark];
}
