import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../models/CustomLeaveRequestModel.dart';
import '../../models/CustomLeaveRequestRepository.dart'; // Replace with the actual import path

part 'custom_leave_request_event.dart';
part 'custom_leave_request_state.dart';

class CustomLeaveRequestBloc
    extends Bloc<CustomLeaveRequestEvent, CustomLeaveRequestState> {
  final CustomLeaveRequestRepository repository = CustomLeaveRequestRepository();

  CustomLeaveRequestBloc() : super(CustomLeaveRequestInitial()) {
    on<PostCustomLeaveRequest>((event, emit) async {
      emit(CustomLeaveRequestLoading());
      try {
        await repository.postCustomLeaveRequest(event.leaveRequest);
        emit(CustomLeaveRequestSuccess());
      } catch (e) {
        emit(CustomLeaveRequestFailure(error: e.toString()));
      }
    });
  }

  @override
  Stream<CustomLeaveRequestState> mapEventToState(
      CustomLeaveRequestEvent event,
      ) async* {
    // You can remove the existing code for handling PostCustomLeaveRequest event here
  }
}
