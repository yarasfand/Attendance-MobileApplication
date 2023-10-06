part of 'emp_post_request_bloc.dart';



@immutable
abstract class EmpPostRequestState extends Equatable {}

class InitialState extends EmpPostRequestState {
  @override
  List<Object> get props => [];
}

class SubmissionLoading extends EmpPostRequestState {
  @override
  List<Object> get props => [];
}

class SubmissionSuccess extends EmpPostRequestState {
  @override
  List<Object> get props => [];
}

class SubmissionError extends EmpPostRequestState {
  final String error;
  SubmissionError(this.error);

  @override
  List<Object> get props => [error];
}
