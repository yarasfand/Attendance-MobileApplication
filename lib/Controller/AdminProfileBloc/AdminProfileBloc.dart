import 'dart:async';
import 'package:bloc/bloc.dart';

import 'AdminProfileEvent.dart';
import 'AdminProfileState.dart';




class AdminProfileBloc extends Bloc<AdminProfileEvent, AdminProfileState> {
  AdminProfileBloc() : super(ProfileInitial()) {
   on<AdminNavigateToViewPageEvent>(navigateToViewPageEvent);
  }


  FutureOr<void> navigateToViewPageEvent(AdminNavigateToViewPageEvent event, Emitter<AdminProfileState> emit) {

    emit(NavigateToViewPageState());
  }
}
