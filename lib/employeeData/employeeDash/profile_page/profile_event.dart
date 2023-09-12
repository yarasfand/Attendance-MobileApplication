part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}
abstract class ProfileActionEvent extends ProfileEvent{}
class NavigateToViewPageEvent extends ProfileActionEvent{}
