import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/leaveSubmissionModel.dart';
import '../../models/leaveSubmissionRepository.dart';
import 'leave_submission_event.dart';
import 'leave_submission_state.dart';

class LeaveSubmissionBloc extends Bloc<LeaveSubmissionEvent, LeaveSubmissionState> {
  final LeaveSubmissionRepository repository;

  LeaveSubmissionBloc({required this.repository}) : super(LeaveSubmissionInitial()) {
    on<SubmitLeaveRequest>(_submitLeaveRequest);
  }

  void _submitLeaveRequest(SubmitLeaveRequest event, Emitter<LeaveSubmissionState> emit) async {
    if (event is SubmitLeaveRequest) {
      emit(LeaveSubmissionLoading());
      try {
        // Create a LeaveSubmissionModel instance with the data
        final leaveSubmissionModel = LeaveSubmissionModel(
          employeeId: "string",
          fromDate: "2023-10-09T07:48:56.683Z",
          toDate: "2023-10-09T07:48:56.683Z",
          reason: "string",
          leaveId: 0,
          leaveDuration: "string",
          status: "string",
          applicationDate: "2023-10-09T07:48:56.683Z",
          remark: "string",
        );

// Convert the model to JSON format
        final Map<String, dynamic> requestBody = leaveSubmissionModel.toJson();


        await repository.submitLeaveRequest(leaveSubmissionModel);

        emit(LeaveSubmissionSuccess());
      } catch (e) {
        emit(LeaveSubmissionError(error: e.toString()));
      }
    }
  }

  @override
  Stream<LeaveSubmissionState> mapEventToState(
      LeaveSubmissionEvent event,
      ) async* {
    if (event is SubmitLeaveRequest) {
      yield LeaveSubmissionLoading();
      try {
        final leaveSubmissionModel = LeaveSubmissionModel(
          employeeId: event.employeeId,
          fromDate: event.fromDate,
          toDate: event.toDate,
          reason: event.reason,
          leaveId: 1, // Replace with the appropriate value.
          leaveDuration: event.leaveDuration,
          status: 'string', // Replace with the appropriate value.
          applicationDate: DateTime.now().toIso8601String(),
          remark: event.remark,
        );

        await repository.submitLeaveRequest(leaveSubmissionModel);

        yield LeaveSubmissionSuccess();
      } catch (e) {
        yield LeaveSubmissionError(error: e.toString());
      }
    }
  }
}
