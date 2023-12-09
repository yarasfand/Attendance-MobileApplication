import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'admin_dash_event.dart';
part 'admin_dash_state.dart';

class AdminDashBloc extends Bloc<AdminDashboardkEvent, AdminDashboardkState> {
  AdminDashBloc() : super(AdminDashboardkInitial()) {
    on<NavigateToProfileEvent>(navigateToProfileEvent);
    on<NavigateToGeofenceEvent>(navigateToAttendanceEvent);
    on<NavigateToReportsEvent>(navigateToReportsEvent);
    on<NavigateToLogoutEvent>(navigateToLogoutEvent);
    on<NavigateToHomeEvent>(navigateToHomeEvent);
    on<NavigateToLeavesEvent>(navigateToLeavesEvent);
  }

  FutureOr<void> navigateToProfileEvent(NavigateToProfileEvent event, Emitter<AdminDashboardkState> emit) {

    emit(NavigateToProfileState());

  }

  FutureOr<void> navigateToAttendanceEvent(NavigateToGeofenceEvent event, Emitter<AdminDashboardkState> emit) {
    emit(NavigateToGeofenceState());

  }

  FutureOr<void> navigateToReportsEvent(NavigateToReportsEvent event, Emitter<AdminDashboardkState> emit) {
    emit(NavigateToReportsState());


  }

  FutureOr<void> navigateToLogoutEvent(NavigateToLogoutEvent event, Emitter<AdminDashboardkState> emit) {
    emit(NavigateToLogoutState());

  }

  FutureOr<void> navigateToHomeEvent(NavigateToHomeEvent event, Emitter<AdminDashboardkState> emit) {
    emit(NavigateToHomeState());
  }



  FutureOr<void> navigateToLeavesEvent(NavigateToLeavesEvent event, Emitter<AdminDashboardkState> emit) {
    emit(NavigateToLeavesState());
  }
}