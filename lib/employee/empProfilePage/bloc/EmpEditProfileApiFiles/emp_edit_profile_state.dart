part of 'emp_edit_profile_bloc.dart';

@immutable
abstract class EmpEditProfileState extends Equatable {}

class InitialState extends EmpEditProfileState {
  @override
  List<Object> get props => [];
}

class EmpEditProfileLoading extends EmpEditProfileState {
  @override
  List<Object> get props => [];
}

class EmpEditProfileSuccess extends EmpEditProfileState {
  @override
  List<Object> get props => [];
}

class EmpEditProfileError extends EmpEditProfileState {
  final String error;
  EmpEditProfileError(this.error);

  @override
  List<Object> get props => [error];
}

// Inside your emp_edit_profile_bloc.dart file
class EmpEditProfileFailure extends EmpEditProfileState {
  final String error;
  EmpEditProfileFailure(this.error);

  @override
  List<Object> get props => [error];
}
