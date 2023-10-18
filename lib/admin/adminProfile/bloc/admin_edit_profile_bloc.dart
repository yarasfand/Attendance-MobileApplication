import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/AdminEditProfileRepository.dart';
import 'admin_edit_profile_event.dart';
import 'admin_edit_profile_state.dart';

class AdminEditProfileBloc extends Bloc<AdminEditProfileEvent, AdminEditProfileState> {
  final AdminEditProfileRepository adminEditProfileRepository;

  AdminEditProfileBloc(this.adminEditProfileRepository) : super(AdminEditProfileInitial());

  @override
  Stream<AdminEditProfileState> mapEventToState(AdminEditProfileEvent event) async* {
    if (event is UpdateAdminProfileEvent) {
      try {
        final isUpdated = await adminEditProfileRepository.updateAdminProfile(event.adminEditProfile);
        if (isUpdated) {
          yield AdminProfileUpdated(true);
        } else {
          yield AdminProfileUpdated(false);
        }
      } catch (error) {
        yield AdminProfileError('Error updating profile: $error');
      }
    }
  }
}
