import 'package:equatable/equatable.dart';

abstract class LeaveTypeState extends Equatable {
  const LeaveTypeState();

  @override
  List<Object?> get props => [];
}

class LeaveTypeInitial extends LeaveTypeState {}

class LeaveTypeLoading extends LeaveTypeState {}

class LeaveTypeLoaded extends LeaveTypeState {
  final List<Map<String, dynamic>> leaveTypes;

  const LeaveTypeLoaded({required this.leaveTypes});

  @override
  List<Object?> get props => [leaveTypes];
}

class LeaveTypeError extends LeaveTypeState {
  final String error;

  const LeaveTypeError({required this.error});

  @override
  List<Object?> get props => [error];
}
