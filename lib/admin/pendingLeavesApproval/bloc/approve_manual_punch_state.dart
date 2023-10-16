import 'package:equatable/equatable.dart';

abstract class ApproveManualPunchState extends Equatable {
  const ApproveManualPunchState();

  @override
  List<Object> get props => [];
}

class ApproveManualPunchInitial extends ApproveManualPunchState {}

class ApproveManualPunchLoading extends ApproveManualPunchState {}

class ApproveManualPunchSuccess extends ApproveManualPunchState {
  final String message;

  const ApproveManualPunchSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ApproveManualPunchFailure extends ApproveManualPunchState {
  final String error;

  const ApproveManualPunchFailure(this.error);

  @override
  List<Object> get props => [error];
}
