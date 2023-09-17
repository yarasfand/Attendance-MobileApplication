
abstract class SignInEvent{}
class SignInTextChangedEvent extends SignInEvent{
late final String password;

SignInTextChangedEvent({required this.password});

}
class SignInButtonEvent extends SignInEvent{
  late final String password;

  SignInButtonEvent({required this.password});

}