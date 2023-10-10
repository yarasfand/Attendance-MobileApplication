part of 'admin_geofence_bloc.dart';

@immutable
abstract class GeofenceEvent {}

class GeofenceSubmitEvent extends GeofenceEvent {
  final AdminGeofenceModel geofenceModel;

  GeofenceSubmitEvent(this.geofenceModel);
}
