import 'package:equatable/equatable.dart';

import '../model/PendingLeavesModel.dart';

abstract class PendingLeavesState extends Equatable {
  @override
  List<Object> get props => [];
}

class PendingLeavesInitial extends PendingLeavesState {}

class PendingLeavesLoading extends PendingLeavesState {}

class PendingLeavesLoaded extends PendingLeavesState {
  final List<PendingLeavesModel> pendingLeaves;

  PendingLeavesLoaded(this.pendingLeaves);

  @override
  List<Object> get props => [pendingLeaves];
}

class PendingLeavesError extends PendingLeavesState {
  final String error;

  PendingLeavesError(this.error);

  @override
  List<Object> get props => [error];
}
