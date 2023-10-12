part of 'emp_profile_api_bloc.dart';

@immutable
abstract class EmpProfileApiState extends Equatable{}

class EmpProfileLoadingState extends EmpProfileApiState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class EmpProfileLoadedState extends EmpProfileApiState {
  EmpProfileLoadedState(this.users);
  final List<EmpProfileModel> users;
  @override
  // TODO: implement props
  List<Object?> get props => [users];
}

class EmpProfileErrorState extends EmpProfileApiState {
  EmpProfileErrorState(this.message);
  final String message;
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
