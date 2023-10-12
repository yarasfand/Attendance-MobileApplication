import 'package:equatable/equatable.dart';

import '../models/AdminDashBoard_model.dart';

class AdminDashboardState extends Equatable {
  final bool isLoading;
  final AdminDashBoard? dashboardData;
  final String? error;

  const AdminDashboardState({
    this.isLoading = false,
    this.dashboardData,
    this.error,
  });

  @override
  List<Object?> get props => [isLoading, dashboardData, error];

  AdminDashboardState copyWith({
    bool? isLoading,
    AdminDashBoard? dashboardData,
    String? error,
  }) {
    return AdminDashboardState(
      isLoading: isLoading ?? this.isLoading,
      dashboardData: dashboardData ?? this.dashboardData,
      error: error ?? this.error,
    );
  }
}
