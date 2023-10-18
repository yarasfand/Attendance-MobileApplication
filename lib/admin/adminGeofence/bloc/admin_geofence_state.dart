import 'package:equatable/equatable.dart';

abstract class AdminGeoFenceState extends Equatable {
  const AdminGeoFenceState();

  @override
  List<Object> get props => [];
}

class GeoFenceInitial extends AdminGeoFenceState {}

class GeoFencePostedSuccessfully extends AdminGeoFenceState {}

class GeoFencePostFailed extends AdminGeoFenceState {
  final String error;

  GeoFencePostFailed({required this.error});

  @override
  List<Object> get props => [error];
}
