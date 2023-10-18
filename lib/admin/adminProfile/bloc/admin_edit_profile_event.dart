import 'package:equatable/equatable.dart';

import '../models/AdminEditProfileModel.dart';

abstract class AdminEditProfileEvent extends Equatable {
  const AdminEditProfileEvent();

  @override
  List<Object> get props => [];
}

class UpdateAdminProfileEvent extends AdminEditProfileEvent {
  final AdminEditProfile adminEditProfile;

  UpdateAdminProfileEvent(this.adminEditProfile);

  @override
  List<Object> get props => [adminEditProfile];
}
