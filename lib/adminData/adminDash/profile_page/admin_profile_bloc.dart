import 'dart:async';

import 'package:bloc/bloc.dart';


import '../../../employeeData/employeeDash/drawerPages/profile_page/profileBloc/profile_bloc.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
   on<NavigateToViewPageEvent>(navigateToViewPageEvent);
  }


  FutureOr<void> navigateToViewPageEvent(NavigateToViewPageEvent event, Emitter<ProfileState> emit) {

    emit(NavigateToViewPageState());
  }
}
