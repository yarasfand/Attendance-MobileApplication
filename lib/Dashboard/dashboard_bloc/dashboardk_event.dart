part of 'dashboardk_bloc.dart';

@immutable
abstract class DashboardkEvent {}
abstract class DashboardkActionEvent extends DashboardkEvent {}
class NavigateToProfileEvent extends DashboardkActionEvent{}
class NavigateToHomeEvent extends DashboardkActionEvent{}
class NavigateToAttendanceEvent extends DashboardkActionEvent{}
class NavigateToReportsEvent extends DashboardkActionEvent{}
class NavigateToLogoutEvent extends DashboardkActionEvent{}
