import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../models/AdminDailyReportsModel.dart';

class AdminReportsState extends Equatable {
  @override
  List<Object> get props => [];
}

class AdminReportsInitialState extends AdminReportsState {}

class AdminReportsLoadingState extends AdminReportsState {}

class AdminReportsLoadedState extends AdminReportsState {
  final List<AdminDailyReportsModel> reports;

  AdminReportsLoadedState({required this.reports});

  @override
  List<Object> get props => [reports];
}

class AdminReportsErrorState extends AdminReportsState {
  final String error;

  AdminReportsErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
