import 'package:equatable/equatable.dart';

import '../models/adminGeofenceModel.dart';

abstract class AdminGeofenceEvent extends Equatable {
  const AdminGeofenceEvent();

  @override
  List<Object> get props => [];
}

class SetGeoFenceEvent extends AdminGeofenceEvent {
  final List<AdminGeoFenceModel> geofenceData;

  SetGeoFenceEvent(this.geofenceData);

  @override
  List<Object> get props => [geofenceData];
}
