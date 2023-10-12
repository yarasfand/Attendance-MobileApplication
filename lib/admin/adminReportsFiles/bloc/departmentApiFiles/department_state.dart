part of 'department_bloc.dart';

abstract class DepartmentState {}

class DepartmentInitial extends DepartmentState {}

class DepartmentLoading extends DepartmentState {}

class DepartmentLoaded extends DepartmentState {
  final List<Department> departments;

  DepartmentLoaded(this.departments);
}

class DepartmentError extends DepartmentState {
  final String error;

  DepartmentError(this.error);
}
