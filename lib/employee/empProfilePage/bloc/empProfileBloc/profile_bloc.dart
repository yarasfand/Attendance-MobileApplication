import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
   on<NavigateToViewPageEvent>(navigateToViewPageEvent);
   on<DataChangesinApiEvent>(dataChangesinApiEvent);
  }


  FutureOr<void> navigateToViewPageEvent(NavigateToViewPageEvent event, Emitter<ProfileState> emit) {

    emit(NavigateToViewPageState());
  }
  FutureOr<void> dataChangesinApiEvent(DataChangesinApiEvent event, Emitter<ProfileState> emit) {

    emit(DataChangesinApiState());
  }
}
