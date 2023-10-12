part of 'branch_bloc.dart';

abstract class BranchState extends Equatable {
  const BranchState();

  @override
  List<Object> get props => [];
}

class BranchInitial extends BranchState {}

class BranchLoading extends BranchState {}

class BranchLoaded extends BranchState {
  final List<Branch> branches;

  BranchLoaded(this.branches);

  @override
  List<Object> get props => [branches];
}

class BranchError extends BranchState {
  final String errorMessage;

  BranchError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
