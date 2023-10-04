import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import '../../UI/AdminUi/AdminReports/AdminMonthlyReportPages/AdminAttendanceReportMonthly.dart';
import '../EmployeeApi/EmployeeRespository/EmployeeUserRepository.dart';

part 'ApiIntegrationEvent.dart';
part 'ApiIntegrationState.dart';

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
        );
        emit(ApiLoadedState(users));
      } catch (e) {
        print("API Error: $e"); // Add this line to print the error message
        emit(ApiErrorState("Failed to fetch data from the API: $e"));
      }
    });
  }
}
