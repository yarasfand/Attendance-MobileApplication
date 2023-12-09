part of 'admin_dash_bloc.dart';

@immutable
abstract class AdminDashboardkEvent {}
abstract class AdminDashboardkActionEvent extends AdminDashboardkEvent {}
class NavigateToProfileEvent extends AdminDashboardkActionEvent{}
class NavigateToHomeEvent extends AdminDashboardkActionEvent{}
class NavigateToGeofenceEvent extends AdminDashboardkActionEvent{}
class NavigateToReportsEvent extends AdminDashboardkActionEvent{}
class NavigateToLogoutEvent extends AdminDashboardkActionEvent{}
class NavigateToLeavesEvent extends AdminDashboardkActionEvent{}
