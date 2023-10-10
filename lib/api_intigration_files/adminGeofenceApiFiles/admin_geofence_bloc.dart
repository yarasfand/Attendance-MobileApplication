import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../models/adminGeofenceModel.dart';
import '../repository/adminGeofencePostRepository.dart';

part 'admin_geofence_event.dart';
part 'admin_geofence_state.dart';
class AdminGeofenceBloc extends Bloc<GeofenceEvent, GeofenceState> {
  final GeofencePostRepository repository;

  AdminGeofenceBloc(this.repository) : super(GeofenceInitial());

  @override
  Stream<GeofenceState> mapEventToState(GeofenceEvent event) async* {
    if (event is GeofenceSubmitEvent) {
      yield GeofenceLoading();

      try {
        await repository.postData(event.geofenceModel);
        yield GeofenceSuccess();
      } catch (e) {
        yield GeofenceFailure(e.toString());
      }
    }
  }
}