import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../employee/empDashboard/models/user_model.dart';
import '../../../employee/empDashboard/models/user_repository.dart';

part 'api_intigration_event.dart';
part 'api_intigration_state.dart';

class ApiIntigrationBloc
    extends Bloc<ApiIntigrationEvent, ApiIntigrationState> {
  final UserRepository _userRepository;
  ApiIntigrationBloc(this._userRepository) : super(ApiLoadingState()) {
    on<ApiLoadingEvent>((event, emit) async {
      print("ApiLoadingEvent emitted");
      emit(ApiLoadingState());
      try {
        // Pass the required parameters when calling getData
        final users = await _userRepository.getData(
          corporateId: event.corporateId,
          username: event.username,
          password: event.password,
          role: event.role,
        );
        emit(ApiLoadedState(users));
      } catch (e) {
        print("API Error: $e"); // Add this line to print the error message
        emit(ApiErrorState("Failed to fetch data from the API: $e"));
      }
    });
  }
}
