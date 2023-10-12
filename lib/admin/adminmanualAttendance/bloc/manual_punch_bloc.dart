import 'dart:async';
import 'package:bloc/bloc.dart';
import '../models/punchRepository.dart';
import './manual_punch_event.dart';
import './manual_punch_state.dart';

class ManualPunchBloc extends Bloc<ManualPunchEvent, ManualPunchState> {
  final ManualPunchRepository repository;

  ManualPunchBloc({required this.repository}) : super(ManualPunchInitial()) {
    on<ManualPunchSubmitEvent>(_handleManualPunchSubmit);
  }

  void _handleManualPunchSubmit(
    ManualPunchSubmitEvent event,
    Emitter<ManualPunchState> emit,
  ) async {
    if (event is ManualPunchSubmitEvent) {
      emit(ManualPunchLoading());
      try {
        final success = await repository.addManualPunch(event.requestDataList);
        if (success) {
          emit(ManualPunchSuccess());
        } else {
          emit(ManualPunchError());
        }
      } catch (e) {
        emit(ManualPunchError());
      }
    }
  }

  @override
  Stream<ManualPunchState> mapEventToState(
    ManualPunchEvent event,
  ) async* {
    // Your event handling logic here
  }
}
