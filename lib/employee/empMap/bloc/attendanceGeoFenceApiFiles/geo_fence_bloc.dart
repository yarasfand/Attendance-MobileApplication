import 'dart:async';
import 'package:bloc/bloc.dart';

import '../../models/attendanceGeoFencingModel.dart';
import '../../models/attendanceGeoFencingRepository.dart';


part 'geo_fence_event.dart';
part 'geo_fence_state.dart';

class GeoFenceBloc extends Bloc<GeoFenceEvent, GeoFenceState> {
  final GeoFenceRepository geoFenceRepository; // Replace with your repository

  GeoFenceBloc({required this.geoFenceRepository}) : super(GeoFenceInitialState());

  @override
  Stream<GeoFenceState> mapEventToState(GeoFenceEvent event) async* {
    if (event is GeoFenceSubmitEvent) {
      // Handle the GeoFenceSubmitEvent here
      try {
        // Perform the submission logic here, use geoFenceRepository if needed
        // You can emit different states based on the result of your logic
        // For example:
        // yield GeoFenceSubmitting(); // You can create this state
        // final result = await geoFenceRepository.submitGeoFence(event.geoFenceModel);
        // if (result.isSuccess) {
        //   yield GeoFenceSubmitSuccess(); // You can create this state
        // } else {
        //   yield GeoFenceSubmitFailure(result.errorMessage); // You can create this state
        // }
      } catch (e) {
        // Handle any errors and yield an error state if necessary
        // For example:
        // yield GeoFenceSubmitFailure('An error occurred: $e');
      }
    }
  }
}