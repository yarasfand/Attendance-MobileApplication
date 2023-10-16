import 'package:equatable/equatable.dart';

import '../model/ApproveManualPunchModel.dart';

abstract class ApproveManualPunchEvent extends Equatable {
  const ApproveManualPunchEvent();

  @override
  List<Object> get props => [];
}

class ApproveManualPunchRequested extends ApproveManualPunchEvent {
  final List<ApproveManualPunchModel> manualPunches;

  const ApproveManualPunchRequested(this.manualPunches);

  @override
  List<Object> get props => [manualPunches];
}
