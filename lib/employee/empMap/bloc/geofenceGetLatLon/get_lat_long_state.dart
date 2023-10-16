part of 'get_lat_long_bloc.dart';

@immutable
abstract class GetLatLongState {}

class GetLatLongInitial extends GetLatLongState {}

class GetLatLongLoading extends GetLatLongState {}

class GetLatLongSuccess extends GetLatLongState {
  final getLatLongData;
  GetLatLongSuccess(this.getLatLongData);
}

class GetLatLongError extends GetLatLongState {
  final String error;
  GetLatLongError(this.error);
}
