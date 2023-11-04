import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/AdminProfileRepository.dart';
import 'admin_profile_event.dart';
import 'admin_profile_state.dart';

class AdminProfileBloc extends Bloc<AdminProfileEvent, AdminProfileState> {
  final AdminProfileRepository repository;

  AdminProfileBloc(this.repository) : super(AdminProfileInitial()) {
    on<FetchAdminProfile>((event, emit) async {
      await _mapFetchAdminProfileToState(event, emit);
    });

    on<UpdateDrawerEvent>((event, emit) {
      // Handle the event to update the drawer (you can add logic here)
    });
  }

  Future<void> _mapFetchAdminProfileToState(FetchAdminProfile event, Emitter<AdminProfileState> emit) async {
    emit(AdminProfileLoading());

    try {
      final adminProfile = await repository.fetchAdminProfile(event.corporateId, event.employeeId);
      if (adminProfile != null) {
        emit(AdminProfileLoaded(adminProfile: adminProfile));
      } else {
        emit(AdminProfileError(error: 'Admin profile data is null.'));
      }
    } catch (e) {
      emit(AdminProfileError(error: 'Error fetching admin profile data: $e'));
    }
  }
}
