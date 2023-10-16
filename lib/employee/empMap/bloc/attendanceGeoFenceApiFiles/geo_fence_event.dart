part of 'geo_fence_bloc.dart';

abstract class GeoFenceEvent {}

class GeoFenceSubmitEvent extends GeoFenceEvent {
  final GeofenceModel geoFenceModel;

  GeoFenceSubmitEvent(this.geoFenceModel);
}