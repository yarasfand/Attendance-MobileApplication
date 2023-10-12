import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/adminGeofencePostRepository.dart';
import 'admin_geofence_event.dart';
import 'admin_geofence_state.dart';


class AdminGeoFenceBloc extends Bloc<AdminGeoFenceEvent, AdminGeoFenceState> {
  final AdminGeoFenceRepository repository;

  AdminGeoFenceBloc(this.repository) : super(InitialState());

  @override
  Stream<AdminGeoFenceState> mapEventToState(AdminGeoFenceEvent event) async* {
    if (event is SetGeoFenceEvent) {
      yield PostingState();

      try {
        await repository.setGeoFence(event.data);
        yield PostedState();
      } catch (e) {
        yield ErrorState('Failed to post Geo-fence data: $e');
      }
    }
  }
}
