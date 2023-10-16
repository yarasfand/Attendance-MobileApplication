import 'package:bloc/bloc.dart';
import '../model/PendingLeavesModel.dart';
import '../model/PendingLeavesRepository.dart';
import 'pending_leaves_event.dart';
import 'pending_leaves_state.dart';

class PendingLeavesBloc extends Bloc<PendingLeavesEvent, PendingLeavesState> {
  final PendingLeavesRepository repository;

  PendingLeavesBloc(this.repository) : super(PendingLeavesInitial()) {
    on<FetchPendingLeaves>(_fetchPendingLeaves);
  }
  void _fetchPendingLeaves(
      FetchPendingLeaves event, Emitter<PendingLeavesState> emit) async {
    emit(PendingLeavesLoading());
    try {
      List<PendingLeavesModel> pendingLeaves =
      await repository.fetchPendingLeaves();
      emit(PendingLeavesLoaded(pendingLeaves));
    } catch (e) {
      print('Error fetching data: $e');
      emit(PendingLeavesError('Failed to load pending leaves data'));
    }
  }


}
