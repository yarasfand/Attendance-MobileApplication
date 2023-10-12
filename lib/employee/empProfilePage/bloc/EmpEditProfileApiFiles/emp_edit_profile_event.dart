part of 'emp_edit_profile_bloc.dart';

@immutable
abstract class EmpEditProfileEvent extends Equatable {
  const EmpEditProfileEvent();

  @override
  List<Object> get props => [];
}

class Create extends EmpEditProfileEvent {
  final EmpEditProfileModel empEditProfileModel;

  const Create(this.empEditProfileModel);

  @override
  List<Object> get props => [empEditProfileModel];
}

class SubmitEmpEditProfileData extends EmpEditProfileEvent {
  final EmpEditProfileModel empEditProfileModel;

  const SubmitEmpEditProfileData(this.empEditProfileModel);

  @override
  List<Object> get props => [empEditProfileModel];
}
