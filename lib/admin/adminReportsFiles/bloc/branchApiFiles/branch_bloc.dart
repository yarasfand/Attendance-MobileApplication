import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/branchModel.dart';
import '../../models/branchRepository.dart';
part 'branch_event.dart';
part 'branch_state.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  final BranchRepository branchRepository = BranchRepository();

  BranchBloc() : super(BranchInitial());

  @override
  Stream<BranchState> mapEventToState(
      BranchEvent event,
      ) async* {
    if (event is FetchBranches) {
      yield BranchLoading();
      try {
        final List<Branch> branches =
        await branchRepository.getAllActiveBranches();
        yield BranchLoaded(branches);
      } catch (e) {
        yield BranchError(e.toString());
      }
    }
  }
}
