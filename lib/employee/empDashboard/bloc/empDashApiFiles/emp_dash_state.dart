part of 'emp_dash_bloc.dart';

@immutable
abstract class EmpDashState extends Equatable {}

class EmpDashLoadingState extends EmpDashState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class EmpDashLoadedState extends EmpDashState {
  EmpDashLoadedState(this.users);
  final List<EmpDashModel> users;
  @override
  // TODO: implement props
  List<Object?> get props => [users];
}

class EmpDashErrorState extends EmpDashState {
  EmpDashErrorState(this.message);
  final String message;
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}