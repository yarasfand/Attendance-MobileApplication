import 'package:equatable/equatable.dart';

import '../models/punchDataModel.dart';


abstract class ManualPunchEvent extends Equatable {
  const ManualPunchEvent();
}

class ManualPunchSubmitEvent extends ManualPunchEvent {
  final List<PunchData> requestDataList;

  ManualPunchSubmitEvent({required this.requestDataList});

  @override
  List<Object?> get props => [requestDataList];
}

