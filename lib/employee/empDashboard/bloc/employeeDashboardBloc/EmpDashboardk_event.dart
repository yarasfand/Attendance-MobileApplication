part of 'EmpDashboardk_bloc.dart';

@immutable
abstract class EmpDashboardkEvent {}
abstract class DashboardkActionEvent extends EmpDashboardkEvent {}
class NavigateToProfileEvent extends DashboardkActionEvent{}
class NavigateToHomeEvent extends DashboardkActionEvent{}
class NavigateToReportsEvent extends DashboardkActionEvent{}
class NavigateToLogoutEvent extends DashboardkActionEvent{}
class NavigateToLeaveEvent extends DashboardkActionEvent{}
class RefreshDataEvent extends EmpDashboardkEvent {}


