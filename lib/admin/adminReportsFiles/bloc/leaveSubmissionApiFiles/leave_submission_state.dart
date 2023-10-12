import 'package:equatable/equatable.dart';

abstract class LeaveSubmissionState extends Equatable {
  const LeaveSubmissionState();

  @override
  List<Object> get props => [];
}

class LeaveSubmissionInitial extends LeaveSubmissionState {}

class LeaveSubmissionLoading extends LeaveSubmissionState {}

class LeaveSubmissionSuccess extends LeaveSubmissionState {}

class LeaveSubmissionError extends LeaveSubmissionState {
  final String error;

  LeaveSubmissionError({required this.error});

  @override
  List<Object> get props => [error];
}
