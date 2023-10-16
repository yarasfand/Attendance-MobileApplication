import 'package:equatable/equatable.dart';

abstract class PendingLeavesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPendingLeaves extends PendingLeavesEvent {}
