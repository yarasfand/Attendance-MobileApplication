import 'dart:async';
import 'package:bloc/bloc.dart';

import 'approve_manual_punch_event.dart';
import 'approve_manual_punch_state.dart';


class ApproveManualPunchBloc extends Bloc<ApproveManualPunchEvent, ApproveManualPunchState> {
  // You may need to inject your API repository here.

  ApproveManualPunchBloc() : super(ApproveManualPunchInitial());

  @override
  Stream<ApproveManualPunchState> mapEventToState(ApproveManualPunchEvent event) async* {
    if (event is ApproveManualPunchRequested) {
      yield ApproveManualPunchLoading();
      try {

      } catch (error) {
        yield ApproveManualPunchFailure('Failed to post data: $error');
      }
    }
  }
}
