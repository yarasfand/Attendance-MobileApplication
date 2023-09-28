
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../models/user_model.dart';
import '../repository/user_repository.dart';

part 'api_intigration_event.dart';
part 'api_intigration_state.dart';

class ApiIntigrationBloc
    extends Bloc<ApiIntigrationEvent, ApiIntigrationState> {
  final UserRepository _userRepository;
  ApiIntigrationBloc(this._userRepository) : super(ApiLoadingState()) {
    on<ApiLoadingEvent>((event, emit) async {
      emit(ApiLoadingState());
      try{
        final users=await _userRepository.getData();
        emit(ApiLoadedState(users));
      }
      catch (e) {
        print("API Error: $e"); // Add this line to print the error message
        emit(ApiErrorState("Failed to fetch data from the API: $e"));
      }
      // print("hey you emit first state");
    });

  }
}
