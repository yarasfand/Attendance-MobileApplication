import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'dashboardk_event.dart';
part 'dashboardk_state.dart';

class DashboardkBloc extends Bloc<DashboardkEvent, DashboardkState> {
  DashboardkBloc() : super(DashboardkInitial()) {
    on<NavigateToProfileEvent>(navigateToProfileEvent);
    on<NavigateToAttendanceEvent>(navigateToAttendanceEvent);
    on<NavigateToReportsEvent>(navigateToReportsEvent);
    on<NavigateToLogoutEvent>(navigateToLogoutEvent);
    on<NavigateToHomeEvent>(navigateToHomeEvent);


  }

  FutureOr<void> navigateToProfileEvent(NavigateToProfileEvent event, Emitter<DashboardkState> emit) {

    emit(NavigateToProfileState());

  }

  FutureOr<void> navigateToAttendanceEvent(NavigateToAttendanceEvent event, Emitter<DashboardkState> emit) {
    emit(NavigateToAttendanceState());

  }

  FutureOr<void> navigateToReportsEvent(NavigateToReportsEvent event, Emitter<DashboardkState> emit) {
    emit(NavigateToReportsState());


  }

  FutureOr<void> navigateToLogoutEvent(NavigateToLogoutEvent event, Emitter<DashboardkState> emit) {
    emit(NavigateToLogoutState());

  }

  FutureOr<void> navigateToHomeEvent(NavigateToHomeEvent event, Emitter<DashboardkState> emit) {
    emit(NavigateToHomeState());
  }
}
