import 'package:equatable/equatable.dart';

abstract class AdminDashboardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchDashboardData extends AdminDashboardEvent {
  final String corporateId;
  final DateTime date;

  FetchDashboardData({
    required this.corporateId,
    required this.date,
  });

  @override
  List<Object?> get props => [corporateId, date];
}
