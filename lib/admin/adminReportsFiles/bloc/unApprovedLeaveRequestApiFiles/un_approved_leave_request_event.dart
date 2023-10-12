import 'package:equatable/equatable.dart';

abstract class UnapprovedLeaveRequestEvent extends Equatable {
  const UnapprovedLeaveRequestEvent();

  @override
  List<Object> get props => [];
}

class FetchUnapprovedLeaveRequests extends UnapprovedLeaveRequestEvent {}
