
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/empProfileModel.dart';
import '../../models/empProfileRepository.dart';

part 'emp_profile_api_event.dart';
part 'emp_profile_api_state.dart';

class EmpProfileApiBloc extends Bloc<EmpProfileApiEvent, EmpProfileApiState> {
  final EmpProfileRepository _empProfileRepository;
  EmpProfileApiBloc(this._empProfileRepository) : super(EmpProfileLoadingState()) {
    on<EmpProfileLoadingEvent>((event, emit) async {
      emit(EmpProfileLoadingState());
      try{
        final users=await _empProfileRepository.getData();
        emit(EmpProfileLoadedState(users));
      }
      catch (e) {
        print("API Error: $e"); // Add this line to print the error message
        emit(EmpProfileErrorState("Failed to fetch data from the API: $e"));
      }
      // print("hey you emit first state");
    });

  }
}
