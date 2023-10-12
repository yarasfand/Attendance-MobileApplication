import 'package:equatable/equatable.dart';

abstract class LeaveTypeEvent extends Equatable {
  const LeaveTypeEvent();

  @override
  List<Object?> get props => [];
}

class FetchLeaveTypes extends LeaveTypeEvent {}
