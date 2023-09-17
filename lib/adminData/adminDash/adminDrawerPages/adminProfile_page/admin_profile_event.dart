

import 'package:flutter/Material.dart';

@immutable
abstract class AdminProfileEvent {}
abstract class ProfileActionEvent extends AdminProfileEvent{}
class AdminNavigateToViewPageEvent extends ProfileActionEvent{}
