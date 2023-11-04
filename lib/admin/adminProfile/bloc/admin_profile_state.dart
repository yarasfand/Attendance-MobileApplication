import 'package:equatable/equatable.dart';

import '../models/AdminProfileModel.dart';

abstract class AdminProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class AdminProfileInitial extends AdminProfileState {}

class AdminProfileLoading extends AdminProfileState {}

class AdminProfileLoaded extends AdminProfileState {
  final AdminProfileModel adminProfile;

  AdminProfileLoaded({required this.adminProfile});

  @override
  List<Object> get props => [adminProfile];
}

class AdminProfileError extends AdminProfileState {
  final String error;

  AdminProfileError({required this.error});

  @override
  List<Object> get props => [error];
}
class AdminProfileDrawerUpdatedState extends AdminProfileState{}