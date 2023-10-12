import 'package:equatable/equatable.dart';

import '../../models/getActiveEmployeesModel.dart';

abstract class GetActiveEmployeeState extends Equatable {
  const GetActiveEmployeeState();
}

class GetEmployeeInitial extends GetActiveEmployeeState {
  @override
  List<Object> get props => [];
}

class GetEmployeeLoading extends GetActiveEmployeeState {
  @override
  List<Object> get props => [];
}

class GetEmployeeLoaded extends GetActiveEmployeeState {
  final List<GetActiveEmpModel> employees;

  GetEmployeeLoaded(this.employees);

  @override
  List<Object> get props => [employees];
}

class GetEmployeeError extends GetActiveEmployeeState {
  final String errorMessage;

  GetEmployeeError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
