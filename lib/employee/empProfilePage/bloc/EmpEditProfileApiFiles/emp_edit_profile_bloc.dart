import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../models/EmpEditProfileRepository.dart';
import '../../models/empEditProfileModel.dart';

part 'emp_edit_profile_event.dart';
part 'emp_edit_profile_state.dart';

class EmpEditProfileBloc
    extends Bloc<EmpEditProfileEvent, EmpEditProfileState> {
  final EmpEditProfileRepository empEditProfileRepository;

  EmpEditProfileBloc({required this.empEditProfileRepository})
      : super(InitialState()) {
    on<Create>((event, emit) async* {
      // Debug print to check if the Create event is received
      print('Create event received');

      yield EmpEditProfileLoading();

      try {
        final empEditProfileModel = event.empEditProfileModel;
        await empEditProfileRepository.postData(empEditProfileModel);

        // Debug print to check if it reaches EmpEditProfileSuccess state
        print('Data submission successful');

        yield EmpEditProfileSuccess();
      } catch (e) {
        // Debug print to check if there's an error
        print('Error: $e');

        yield EmpEditProfileError(e.toString());
      }
    });

    on<SubmitEmpEditProfileData>((event, emit) async {
      // Debug print to check if the SubmitEmpEditProfileData event is received
      print('SubmitEmpEditProfileData event received');

      try {
        final empEditProfileModel = event.empEditProfileModel;
        // Call the repository method to post data
        await empEditProfileRepository.postData(empEditProfileModel);

        // Debug print to check if it reaches EmpEditProfileSuccess state
        print('Data submission successful');

        emit(EmpEditProfileSuccess());
      } catch (e) {
        // Debug print to check if there's an error
        print('Error: $e');

        emit(EmpEditProfileError(e.toString()));
      }
    });
  }
}

