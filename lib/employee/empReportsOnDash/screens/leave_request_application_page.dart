import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project/constants/AnimatedTextPopUp.dart';
import 'package:project/constants/AppBar_constant.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:project/constants/globalObjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/empLeaveRequestApiFiles/emp_leave_request_bloc.dart';
import '../bloc/empPostRequestApiFiles/emp_post_request_bloc.dart';
import '../models/empLeaveRequestModel.dart';
import '../models/empLeaveRequestRepository.dart';
import '../models/empPostLeaveRequestRepository.dart';
import '../models/submission_model.dart';

class LeaveRequestForm extends StatefulWidget {
  @override
  _LeaveRequestFormState createState() => _LeaveRequestFormState();
}

class _LeaveRequestFormState extends State<LeaveRequestForm>
    with TickerProviderStateMixin {
  late AnimationController addToCartPopUpAnimationController;

  final _reasonController = TextEditingController();
  final _reasonTextController = TextEditingController();
  final _leaveDurationController = TextEditingController();
  late String _currentTime;

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
    addToCartPopUpAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    super.initState();
    // Initialize controllers with default values
    getSharedData();
    _currentTime = DateFormat.yMd().add_jm().format(DateTime.now());

    // Create a timer to update the time every second
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateFormat.yMd().add_jm().format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    addToCartPopUpAnimationController.dispose();
    super.dispose();
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

  void showPopupWithMessage(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addToCartPopUpMessage(
          addToCartPopUpAnimationController,
          message,
              () {
            // Add the logic you want to execute when the pop-up is pressed
            Navigator.pop(context); // Close the pop-up
          },
        );
      },
    );
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

  void _popPage() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context);
    });

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }

  final Map<String, int> _reasonToLTypeId = {
    "Annual": 1,
    "Outstation Duty": 2,
    "SL": 3,
  };
  String _selectedLeaveDuration = "";
  String _selectedReason = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leave Form",
          style: AppBarStyles.appBarTextStyle,
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppBarStyles.appBarIconColor),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: BlocProvider(
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
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is EmpLeaveRequestLoadedState) {
                    int selectedTypeId = 0;
                    List<EmpLeaveModel> userList = state.users;
                    final employeeLeave1 = userList.isNotEmpty
                        ? userList[0]
                        : EmpLeaveModel(
                            leaveTypeId: 0, ltypeCode: '', ltypeName: '');
                    final employeeLeave2 = userList.length > 1
                        ? userList[1]
                        : EmpLeaveModel(
                            leaveTypeId: 0, ltypeCode: '', ltypeName: '');
                    final employeeLeave3 = userList.length > 2
                        ? userList[2]
                        : EmpLeaveModel(
                            leaveTypeId: 0, ltypeCode: '', ltypeName: '');

                    selectedTypeId = employeeLeave1.leaveTypeId ?? 0;

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          color: AppColors.brightWhite,
                          width: MediaQuery.of(context).size.width /
                              1.2, // Adjust the width as needed
                          child: Card(
                            color: AppColors.brightWhite,
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Leave Request Form',
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  const Text(
                                    'From Date',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: true,
                                          onTap: () => _selectFromDate(context),
                                          decoration: const InputDecoration(
                                            hintText: 'Select Date',
                                            suffixIcon:
                                                Icon(Icons.calendar_today),
                                          ),
                                          controller: TextEditingController(
                                            text: "${_fromDate.toLocal()}"
                                                .split(' ')[0],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'To Date',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: true,
                                          onTap: () => _selectToDate(context),
                                          decoration: const InputDecoration(
                                            hintText: 'Select Date',
                                            suffixIcon:
                                                Icon(Icons.calendar_today),
                                          ),
                                          controller: TextEditingController(
                                            text: "${_toDate.toLocal()}"
                                                .split(' ')[0],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Leave Type',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  DropdownButtonFormField<String>(
                                    value: _selectedReason,
                                    items: [
                                      "",
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
                                        _reasonController.text =
                                            _selectedReason;
                                        selectedTypeId =
                                            _reasonToLTypeId[value] ?? 0;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Reason for Leave',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextField(
                                    controller: _reasonTextController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter your reason for leave',
                                    ),
                                  ),

                                  const SizedBox(height: 16),
                                  // const Text(
                                  //   'Leave Duration',
                                  //   style: TextStyle(fontSize: 16),
                                  // ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Leave Duration',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  DropdownButtonFormField<String>(
                                    value: _selectedLeaveDuration,
                                    items: [
                                      "",
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
                                  const SizedBox(height: 32),
                                  ElevatedButton(
                                    style: (_reasonTextController.text == null ||
                                        _reasonTextController.text.isEmpty ||
                                        _reasonController.text == null ||
                                        _reasonController.text.isEmpty ||
                                        _leaveDurationController.text == null ||
                                        _leaveDurationController.text.isEmpty)
                                        ? ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      backgroundColor: Colors.grey,
                                      padding: EdgeInsets.all(16.0),
                                      minimumSize: Size(200, 40),
                                    )
                                        : ElevatedButton.styleFrom(

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      backgroundColor: Colors.blue,
                                      padding: EdgeInsets.all(16.0),
                                      minimumSize: Size(200, 40),
                                    ),
                                    onPressed: () async {
                                      if (_reasonTextController.text == null ||
                                          _reasonTextController.text.isEmpty ||
                                          _reasonController.text == null ||
                                          _reasonController.text.isEmpty ||
                                          _leaveDurationController.text == null ||
                                          _leaveDurationController.text.isEmpty) {
                                        GlobalObjects.checkForLeaveForm(
                                            context);
                                      } else {
                                        final selectedLeaveDuration =
                                            _leaveDurationController.text;
                                        final selectedTextReason =
                                            _reasonTextController
                                                .text; // Get the reason from the text field
                                        final selectedReason = _reasonController
                                            .text; // Get the reason from the text field
                                        print(
                                            "Selected Reason: $selectedReason ");
                                        final selectedTypeId =
                                            _reasonToLTypeId[selectedReason] ??
                                                0;

                                        final submissionModel = SubmissionModel(
                                          employeeId: empId.toString(),
                                          fromDate:
                                              "${_fromDate.toLocal().toIso8601String().split('T')[0]}T00:00:00Z",
                                          toDate:
                                              "${_toDate.toLocal().toIso8601String().split('T')[0]}T00:00:00Z",
                                          reason: selectedTextReason,
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

                                        await Future.delayed(
                                            const Duration(seconds: 2));

                                        if (_postRequestBloc.state
                                            is SubmissionSuccess) {
                                          print("Successful");
                                          addToCartPopUpAnimationController
                                              .forward();

                                          // Delay for a few seconds and then reverse the animation
                                          Timer(const Duration(seconds: 3), () {
                                            addToCartPopUpAnimationController
                                                .reverse();
                                          });
                                          showPopupWithMessage(
                                              "Request Submitted Successfully",context);

                                          _popPage();
                                        } else if (_postRequestBloc.state
                                            is SubmissionError) {
                                          print("Not Successful");
                                          addToCartPopUpAnimationController
                                              .forward();

                                          // Delay for a few seconds and then reverse the animation
                                          Timer(const Duration(seconds: 3), () {
                                            addToCartPopUpAnimationController
                                                .reverse();
                                          });
                                          showPopupWithMessage(
                                            "Error: ${(_postRequestBloc.state as SubmissionError).error}",context
                                          );
                                        }
                                      }
                                    },
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (state is EmpLeaveRequestErrorState) {
                    return Text("Error: ${state.message}");
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
