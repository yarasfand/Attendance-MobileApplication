import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'EmployeeProfileEvent.dart';
part 'EmployeeProfileState.dart';

class EmpProfileBloc extends Bloc<EmpProfileEvent, EmpProfileState> {
  EmpProfileBloc() : super(EmpProfileInitial()) {
   on<NavigateToViewPageEvent>(navigateToViewPageEvent);
  }


  FutureOr<void> navigateToViewPageEvent(NavigateToViewPageEvent event, Emitter<EmpProfileState> emit) {

    emit(NavigateToViewPageState());
  }
}
