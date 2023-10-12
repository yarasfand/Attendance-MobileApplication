import 'package:equatable/equatable.dart';
import '../../models/unApprovedLeaveRequestModel.dart';

abstract class UnapprovedLeaveRequestState extends Equatable {
  const UnapprovedLeaveRequestState();

  @override
  List<Object> get props => [];
}

class UnapprovedLeaveRequestInitial extends UnapprovedLeaveRequestState {}

class UnapprovedLeaveRequestLoading extends UnapprovedLeaveRequestState {}

class UnapprovedLeaveRequestLoaded extends UnapprovedLeaveRequestState {
  final List<UnApprovedLeaveRequest> unapprovedLeaveRequests;

  UnapprovedLeaveRequestLoaded({required this.unapprovedLeaveRequests});

  @override
  List<Object> get props => [unapprovedLeaveRequests];
}

class UnapprovedLeaveRequestError extends UnapprovedLeaveRequestState {
  final String error;

  UnapprovedLeaveRequestError({required this.error});

  @override
  List<Object> get props => [error];
}
