import 'package:equatable/equatable.dart';

abstract class ManualPunchState extends Equatable {
  const ManualPunchState();
}

class ManualPunchInitial extends ManualPunchState {
  @override
  List<Object> get props => [];
}

class ManualPunchLoading extends ManualPunchState {
  @override
  List<Object> get props => [];
}

class ManualPunchSuccess extends ManualPunchState {
  @override
  List<Object> get props => [];
}

class ManualPunchError extends ManualPunchState {
  @override
  List<Object> get props => [];
}
