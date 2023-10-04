part of 'ApiIntegrationBloc.dart';


abstract class ApiIntigrationEvent extends Equatable{}

class ApiLoadingEvent extends ApiIntigrationEvent{
  final String corporateId;
  final String username;
  final String password;

  ApiLoadingEvent({
    required this.corporateId,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [corporateId, username, password];

}