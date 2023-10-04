import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../AdminModels/AdminModel.dart';
import '../AdminRepository/AdminRepository.dart';
part 'AdminApiState.dart';
part 'AdminApiEvent.dart';

class AdminApiBloc extends Bloc<AdminApiEvent, AdminApiState> {
  final AdminRepository _adminRepository;
  AdminApiBloc(this._adminRepository) : super(AdminApiLoadingState()) {
    on<AdminApiLoadingEvent>((event, emit) async {
      emit(AdminApiLoadingState());
      try {
        final users = await _adminRepository.getData();
        emit(AdminApiLoadedState(users));
      } catch (e) {
        print("API Error: $e"); // Add this line to print the error message
        emit(AdminApiErrorState("Failed to fetch data from the API: $e"));
      }
      // print("hey you emit first state");
    });
  }
}
