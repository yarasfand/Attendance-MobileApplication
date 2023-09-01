
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:project/bloc_internet/internet_event.dart';
import 'package:project/bloc_internet/internet_state.dart';


class InternetBloc extends Bloc<InternetEvent,InternetStates>{

  Connectivity _connectivity =Connectivity();
  StreamSubscription ? connectivitySubscription; // to stop the listener


  InternetBloc(): super(InternetInitialState()){
    on<InternetLostEvent>((event, emit) => emit(InternetLostState()));
    on<InternetGainedEvent>((event, emit) => emit(InternetGainedState()));
   connectivitySubscription= _connectivity.onConnectivityChanged.listen((result) {

      if(result==ConnectivityResult.mobile || result== ConnectivityResult.wifi)
        {
          add(InternetGainedEvent());
        }
      else
        {
          add(InternetLostEvent());
        }
    });


}

// this is predefined but i am adding slight alteration
@override
  Future<void> close() {
    // TODO: implement close
  connectivitySubscription?.cancel();
    return super.close();
  }
}
