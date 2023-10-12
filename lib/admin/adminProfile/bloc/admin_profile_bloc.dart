import 'dart:async';
import 'package:bloc/bloc.dart';

import 'admin_profile_event.dart';
import 'admin_profile_state.dart';



class AdminProfileBloc extends Bloc<AdminProfileEvent, AdminProfileState> {
  AdminProfileBloc() : super(ProfileInitial()) {
   on<AdminNavigateToViewPageEvent>(navigateToViewPageEvent);
  }


  FutureOr<void> navigateToViewPageEvent(AdminNavigateToViewPageEvent event, Emitter<AdminProfileState> emit) {

    emit(NavigateToViewPageState());
  }
}
