part of 'geo_fence_bloc.dart';

abstract class GeoFenceState {}

class GeoFenceInitialState extends GeoFenceState {}

class GeoFenceLoadingState extends GeoFenceState {}

class GeoFenceSuccessState extends GeoFenceState {}

class GeoFenceErrorState extends GeoFenceState {
  final String error;

  GeoFenceErrorState(this.error);
}