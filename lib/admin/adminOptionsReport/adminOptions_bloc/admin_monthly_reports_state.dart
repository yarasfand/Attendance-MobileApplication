import 'package:equatable/equatable.dart';

import '../models/AdminMonthlyReportModel.dart';

abstract class AdminMonthlyReportsState extends Equatable {
  const AdminMonthlyReportsState();

  @override
  List<Object> get props => [];
}

class AdminMonthlyReportsInitial extends AdminMonthlyReportsState {}

class AdminMonthlyReportsLoading extends AdminMonthlyReportsState {}

class AdminMonthlyReportsLoaded extends AdminMonthlyReportsState {
  final List<AdminMonthlyReportsModel> reports;

  AdminMonthlyReportsLoaded({required this.reports});

  @override
  List<Object> get props => [reports];
}

class AdminMonthlyReportsError extends AdminMonthlyReportsState {
  final String errorMessage;

  AdminMonthlyReportsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
