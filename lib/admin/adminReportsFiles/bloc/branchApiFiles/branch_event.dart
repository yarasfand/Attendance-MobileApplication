part of 'branch_bloc.dart';

abstract class BranchEvent extends Equatable {
  const BranchEvent();

  @override
  List<Object> get props => [];
}

class FetchBranches extends BranchEvent {
  final String corporateId;

  FetchBranches({required this.corporateId});

  @override
  List<Object> get props => [corporateId];
}
