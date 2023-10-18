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
