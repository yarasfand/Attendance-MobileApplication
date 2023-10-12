
import 'package:equatable/equatable.dart';

abstract class GetActiveEmployeeEvent extends Equatable {
  const GetActiveEmployeeEvent();
}

class FetchEmployees extends GetActiveEmployeeEvent {
  final String corporateId;

  FetchEmployees(this.corporateId);

  @override
  List<Object> get props => [corporateId];
}
