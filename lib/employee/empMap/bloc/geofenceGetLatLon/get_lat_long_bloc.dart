import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/geofenceGetLatLongRepository.dart';

part 'get_lat_long_event.dart';
part 'get_lat_long_state.dart';

class GetLatLongBloc extends Bloc<GetLatLongEvent, GetLatLongState> {
  final GetLatLongRepo repository;

  GetLatLongBloc(this.repository) : super(GetLatLongInitial());

  @override
  Stream<GetLatLongState> mapEventToState(GetLatLongEvent event) async* {
    if (event is FetchDataEvent) {
      yield GetLatLongLoading();
      try {
        final getLatLongData = await repository.fetchData();
        yield GetLatLongSuccess(getLatLongData);
      } catch (e) {
        yield GetLatLongError('An error occurred: $e');
      }
    }
  }
}