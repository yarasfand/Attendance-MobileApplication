abstract class AdminGeoFenceState {}

class InitialState extends AdminGeoFenceState {}

class PostingState extends AdminGeoFenceState {}

class PostedState extends AdminGeoFenceState {}

class ErrorState extends AdminGeoFenceState {
  final String errorMessage;

  ErrorState(this.errorMessage);
}
