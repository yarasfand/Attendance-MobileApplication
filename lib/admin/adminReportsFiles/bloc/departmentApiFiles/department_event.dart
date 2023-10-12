part of 'department_bloc.dart';

abstract class DepartmentEvent {}

class FetchDepartments extends DepartmentEvent {
  final String corporateId;

  FetchDepartments(this.corporateId);
}
