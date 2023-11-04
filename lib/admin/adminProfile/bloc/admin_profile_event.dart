import 'package:equatable/equatable.dart';

abstract class AdminProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchAdminProfile extends AdminProfileEvent {
  final String corporateId;
  final String employeeId;

  FetchAdminProfile({required this.corporateId, required this.employeeId});

  @override
  List<Object> get props => [corporateId, employeeId];
}

class UpdateDrawerEvent extends AdminProfileEvent {
  // You can add any relevant data or parameters needed for the update here

  @override
  List<Object> get props => [];
}
