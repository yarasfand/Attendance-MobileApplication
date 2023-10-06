part of 'geo_fence_bloc.dart';

abstract class GeoFenceEvent {}

class GeoFenceSubmitEvent extends GeoFenceEvent {
  final GeoFenceModel geoFenceModel;

  GeoFenceSubmitEvent(this.geoFenceModel);
}