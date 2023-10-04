
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../EmployeeModels/EmployeeDashModel.dart';
import '../EmployeeRespository/EmployeeDashRepository.dart';
part 'EmployeeDashevent.dart';
part 'EmployeeDashstate.dart';

class EmpDashBloc  extends Bloc<EmpDashEvent, EmpDashState> {
  final EmpDashRepository _empDashRepository;
  EmpDashBloc(this._empDashRepository) : super(EmpDashLoadingState()) {
    on<EmpDashLoadingEvent>((event, emit) async {
      emit(EmpDashLoadingState());
      try{
        final users=await _empDashRepository.getData();
        emit(EmpDashLoadedState(users));
      }
      catch (e) {
        print("API Error: $e"); // Add this line to print the error message
        emit(EmpDashErrorState("Failed to fetch data from the API: $e"));
      }
      // print("hey you emit first state");
    });

  }
}