part of 'dashboardk_bloc.dart';

@immutable
abstract class DashboardkState {}

class DashboardkInitial extends DashboardkState {}

class NavigateToProfileState extends DashboardkState{}
class NavigateToHomeState extends DashboardkState{}
class NavigateToAttendanceState extends DashboardkState{}
class NavigateToReportsState extends DashboardkState{}
class NavigateToLogoutState extends DashboardkState{}
