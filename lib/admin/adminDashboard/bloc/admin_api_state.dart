part of 'admin_api_bloc.dart';

@immutable
abstract class AdminApiState extends Equatable {}

class AdminApiLoadingState extends AdminApiState {
  @override
  // TODO: implement props
  List<Object?> get props => [];

}
class AdminApiLoadedState extends AdminApiState {
  AdminApiLoadedState(this.users);
  final List<AdminModel> users;
  @override
  // TODO: implement props
  List<Object?> get props => [users];
}
class AdminApiErrorState extends AdminApiState {
  AdminApiErrorState(this.message);
  final String message;
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}