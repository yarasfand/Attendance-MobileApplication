import 'package:equatable/equatable.dart';

abstract class AdminEditProfileState extends Equatable {
  const AdminEditProfileState();

  @override
  List<Object> get props => [];
}

class AdminEditProfileInitial extends AdminEditProfileState {}

class AdminProfileUpdated extends AdminEditProfileState {
  final bool isUpdated;

  AdminProfileUpdated(this.isUpdated);

  @override
  List<Object> get props => [isUpdated];
}

class AdminProfileError extends AdminEditProfileState {
  final String error;

  AdminProfileError(this.error);

  @override
  List<Object> get props => [error];
}
