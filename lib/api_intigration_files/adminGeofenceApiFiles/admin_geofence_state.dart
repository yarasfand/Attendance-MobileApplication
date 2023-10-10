part of 'admin_geofence_bloc.dart';

@immutable
abstract class GeofenceState {}

class GeofenceInitial extends GeofenceState {}

class GeofenceLoading extends GeofenceState {}

class GeofenceSuccess extends GeofenceState {}

class GeofenceFailure extends GeofenceState {
  final String error;

  GeofenceFailure(this.error);
}
