import 'package:bloc/bloc.dart';
import 'admin_geofence_event.dart';
import 'admin_geofence_state.dart';

class AdminGeoFenceBloc extends Bloc<AdminGeofenceEvent, AdminGeoFenceState> {
  AdminGeoFenceBloc() : super(GeoFenceInitial()) {
    on<SetGeoFenceEvent>((event, emit) {
      try {
        final geofenceData = event.geofenceData;

        // Here, you can iterate through the geofenceData list and post data for each geofence
        for (final data in geofenceData) {
          // Call the repository or API to post data for each geofence
          // Example: await geoFenceRepository.postGeoFenceData(data);
        }

        emit(GeoFencePostedSuccessfully());
      } catch (e) {
        emit(GeoFencePostFailed(error: e.toString()));
      }
    });
  }
}
