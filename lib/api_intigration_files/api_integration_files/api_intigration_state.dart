part of 'api_intigration_bloc.dart';

@immutable
abstract class ApiIntigrationState extends Equatable {}

class ApiLoadingState extends ApiIntigrationState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ApiLoadedState extends ApiIntigrationState {
  ApiLoadedState(this.users);
  final List<Employee> users;
  @override
  // TODO: implement props
  List<Object?> get props => [users];
}

class ApiErrorState extends ApiIntigrationState {
  ApiErrorState(this.message);
  final String message;
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
//
// class ApiLoadedStateAdmin extends ApiIntigrationState {
//   ApiLoadedState(this.users);
//   final List<AdminModel> users;
//   @override
//   // TODO: implement props
//   List<Object?> get props => [users];
// }
//
// class ApiErrorStateAdmin extends ApiIntigrationState {
//   ApiErrorState(this.message);
//   final String message;
//   @override
//   // TODO: implement props
//   List<Object?> get props => [message];
// }