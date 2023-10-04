
abstract class SignInState{}

class SignInInitialState extends SignInState{}
class SigninValidState extends SignInState{}
class SignInNotValidState extends SignInState{
  late final String message;
  SignInNotValidState({required this.message});
}
