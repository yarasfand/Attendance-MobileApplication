import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api_intigration_files/emp_leave_request_api_files/emp_leave_request_bloc.dart';
import '../../../../api_intigration_files/emp_post_request_api_files/emp_post_request_bloc.dart';
import '../../../../api_intigration_files/models/emp_leave_request_model.dart';
import '../../../../api_intigration_files/models/submission_model.dart';
import '../../../../api_intigration_files/repository/emp_leave_request_repository.dart';
import '../../../../api_intigration_files/repository/emp_post_leave_request_repository.dart';

class LeaveRequestForm extends StatefulWidget {
  @override
  _LeaveRequestFormState createState() => _LeaveRequestFormState();
}

class _LeaveRequestFormState extends State<LeaveRequestForm> {
  final _reasonController = TextEditingController();
  final _leaveDurationController = TextEditingController();

  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  final EmpPostRequestBloc _postRequestBloc = EmpPostRequestBloc(
    submissionRepository:
        SubmissionRepository(), // Provide your repository here
  );

  Future<void> getSharedData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    empId = pref.getInt("employee_id") ?? 0;
  }

  @override
  void initState() {
    super.initState();
    // Initialize controllers with default values
    getSharedData();
  }

  late final empId;
  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _fromDate) {
      setState(() {
        _fromDate = picked;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _toDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _toDate) {
      setState(() {
        _toDate = picked;
      });
    }
  }

  Map<String, int> _reasonToLTypeId = {
    "Annual": 1,
    "Outstation Duty": 2,
    "SL": 3,
  };
  String _selectedLeaveDuration = "Full Day";
  String _selectedReason = "Annual";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return EmpLeaveRequestBloc(
          RepositoryProvider.of<EmpLeaveRepository>(context),
        )..add(EmpLeaveRequestLoadingEvent());
      },
      child: BlocConsumer<EmpLeaveRequestBloc, EmpLeaveRequestState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is EmpLeaveRequestLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is EmpLeaveRequestLoadedState) {
            int selectedTypeId = 0;
            List<EmpLeaveModel> userList = state.users;
            final employeeLeave1 = userList.isNotEmpty
                ? userList[0]
                : EmpLeaveModel(leaveTypeId: 0, ltypeCode: '', ltypeName: '');
            final employeeLeave2 = userList.length > 1
                ? userList[1]
                : EmpLeaveModel(leaveTypeId: 0, ltypeCode: '', ltypeName: '');
            final employeeLeave3 = userList.length > 2
                ? userList[2]
                : EmpLeaveModel(leaveTypeId: 0, ltypeCode: '', ltypeName: '');

            selectedTypeId = employeeLeave1.leaveTypeId ?? 0;

            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Leave Request Form',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
                centerTitle: true,
                backgroundColor: const Color(0xFFE26142),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From Date',
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            onTap: () => _selectFromDate(context),
                            decoration: InputDecoration(
                              hintText: 'Select Date',
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            controller: TextEditingController(
                              text: "${_fromDate.toLocal()}".split(' ')[0],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'To Date',
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            onTap: () => _selectToDate(context),
                            decoration: InputDecoration(
                              hintText: 'Select Date',
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            controller: TextEditingController(
                              text: "${_toDate.toLocal()}".split(' ')[0],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Reason',
                      style: TextStyle(fontSize: 16),
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedReason,
                      items: [
                        employeeLeave1.ltypeName,
                        employeeLeave2.ltypeName,
                        employeeLeave3.ltypeName,
                      ].map((String reason) {
                        return DropdownMenuItem<String>(
                          value: reason,
                          child: Text(reason),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedReason = value!;
                          _reasonController.text = _selectedReason;
                          selectedTypeId = _reasonToLTypeId[value] ?? 0;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Leave Duration',
                      style: TextStyle(fontSize: 16),
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedLeaveDuration,
                      items: [
                        "Full Day",
                        "Half Day",
                      ].map((String duration) {
                        return DropdownMenuItem<String>(
                          value: duration,
                          child: Text(duration),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLeaveDuration = value!;
                          _leaveDurationController.text =
                              _selectedLeaveDuration;
                        });
                      },
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () async {
                        final selectedLeaveDuration =
                            _leaveDurationController.text;
                        final selectedReason = _reasonController.text;
                        final selectedTypeId =
                            _reasonToLTypeId[selectedReason] ?? 0;

                        final submissionModel = SubmissionModel(
                          employeeId: empId.toString(),
                          fromDate:
                              "${_fromDate.toLocal().toIso8601String().split('T')[0]}T00:00:00Z",
                          toDate:
                              "${_toDate.toLocal().toIso8601String().split('T')[0]}T00:00:00Z",
                          reason: selectedReason,
                          leaveId: selectedTypeId,
                          leaveDuration: selectedLeaveDuration,
                          status: 'UnApproved',
                          applicationDate:
                              "${DateTime.now().toIso8601String().split('T')[0]}T00:00:00Z",
                          remark: '',
                        );

                        _postRequestBloc.add(Create(
                          submissionModel.employeeId,
                          submissionModel.fromDate,
                          submissionModel.toDate,
                          submissionModel.reason,
                          submissionModel.leaveId,
                          submissionModel.leaveDuration,
                          submissionModel.status,
                          submissionModel.applicationDate,
                          submissionModel.remark,
                        ));

                        await Future.delayed(const Duration(seconds: 2));

                        if (_postRequestBloc.state is SubmissionSuccess) {
                          print("Successful");
                          Fluttertoast.showToast(
                            msg: "Request submitted successfully",
                          );
                        } else if (_postRequestBloc.state is SubmissionError) {
                          print("Not Successful");

                          Fluttertoast.showToast(
                            msg:
                                "Error: ${(_postRequestBloc.state as SubmissionError).error}",
                          );
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is EmpLeaveRequestErrorState) {
            return Text("Error: ${state.message}");
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
