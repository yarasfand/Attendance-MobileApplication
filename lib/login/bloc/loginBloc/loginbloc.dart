import 'package:flutter_bloc/flutter_bloc.dart';
import 'loginEvents.dart';
import 'loginStates.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitialState()) {
    on<SignInTextChangedEvent>((event, emit) {
      // event contain data inside it
      if(event.password.length>=8)
        {
          emit(SigninValidState());
        }
      else if(event.password.length<8)
        {
          // emit( SignInNotValidState(message: "Atleast 7 characters required"));
        }

    });
    on<SignInButtonEvent>((event, emit) {


    });
  }
}
