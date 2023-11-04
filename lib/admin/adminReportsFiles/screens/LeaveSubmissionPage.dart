import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/constants/AppBar_constant.dart';
import 'package:project/introduction/bloc/bloc_internet/internet_bloc.dart';
import 'package:project/introduction/bloc/bloc_internet/internet_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../No_internet/no_internet.dart';
import '../../../constants/AppColor_constants.dart';
import '../models/getActiveEmployeesModel.dart';
import '../models/leaveTypeRepository.dart';

class LeaveSubmissionPage extends StatefulWidget {
  final List<GetActiveEmpModel> selectedEmployees;

  LeaveSubmissionPage({required this.selectedEmployees});
  @override
  State<LeaveSubmissionPage> createState() =>
      _LeaveSubmissionPageState(selectedEmployees: selectedEmployees);
}

class _LeaveSubmissionPageState extends State<LeaveSubmissionPage> {
  final List<GetActiveEmpModel> selectedEmployees;
  _LeaveSubmissionPageState({required this.selectedEmployees});
  final LeaveTypeRepository leaveTypeRepository = LeaveTypeRepository();
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  String? selectedLeaveType = "";
  int selectedLeaveTypeId = 0;
  List<String> leaveTypeNames = [];
  List<String> hardcodedValues = [];
  String selectedValue = "";
  String durationSelectedValue = "FullDay";
  Map<String, int> leaveTypeMap = {
    'Annual': 1, // Update with your actual leave type names and IDs
    'Outstation Duty': 2,
    'SL': 3,
    // Add more leave types as needed
  };
  @override
  void initState() {
    super.initState();
    leaveTypeRepository.fetchLeaveTypes().then((leaveTypes) {
      setState(() {
        leaveTypeNames =
            leaveTypes!.map((type) => type["ltypeName"] as String).toList();
        leaveTypeNames = leaveTypeNames.toSet().toList();
        hardcodedValues = leaveTypeNames;
        selectedValue = hardcodedValues[0];
      });
    });
  }

  bool isInternetLost = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetBloc, InternetStates>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is InternetLostState) {
          // Set the flag to true when internet is lost
          isInternetLost = true;
          Future.delayed(Duration(seconds: 2), () {
            Navigator.push(
              context,
              PageTransition(
                child: NoInternet(),
                type: PageTransitionType.rightToLeft,
              ),
            );
          });
        } else if (state is InternetGainedState) {
          // Check if internet was previously lost
          if (isInternetLost) {
            // Navigate back to the original page when internet is regained
            Navigator.pop(context);
          }
          isInternetLost = false; // Reset the flag
        }
      },
      builder: (context, state) {
        if (state is InternetGainedState)
          {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Leave Submission Page",
                  style: AppBarStyles.appBarTextStyle
                ),
                centerTitle: true,
                backgroundColor: AppColors.primaryColor,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  margin: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Card(

                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  "Leave Request",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "From Date",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        TextFormField(
                                          controller: fromDateController,
                                          decoration: InputDecoration(
                                            labelText: "Select Date",
                                            suffixIcon: IconButton(
                                              icon:
                                              const Icon(Icons.calendar_today),
                                              onPressed: () async {
                                                final selectedDate =
                                                await _selectDateTime(context);
                                                if (selectedDate != null) {
                                                  fromDateController.text =
                                                      _formatDate(selectedDate);
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "To Date",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        TextFormField(
                                          controller: toDateController,
                                          decoration: InputDecoration(
                                            labelText: "Select Date",
                                            suffixIcon: IconButton(
                                              icon:
                                              const Icon(Icons.calendar_today),
                                              onPressed: () async {
                                                final selectedDate =
                                                await _selectDateTime(context);
                                                if (selectedDate != null) {
                                                  toDateController.text =
                                                      _formatDate(selectedDate);
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Leave Type",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      DropdownButton<String>(
                                        value: selectedValue,
                                        items: hardcodedValues.map((value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedValue = value!;
                                            selectedLeaveType = value;
                                            selectedLeaveTypeId =
                                                leaveTypeMap[value] ?? 1;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Leave Duration",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      DropdownButton<String>(
                                        value: durationSelectedValue,
                                        items: const [
                                          DropdownMenuItem<String>(
                                            value: "FullDay",
                                            child: Text("Full Day"),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: "HalfDay",
                                            child: Text("Half Day"),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            durationSelectedValue = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    String corporateId = prefs.getString("corporate_id") ?? "ptsoffice";
                                    print(corporateId);
                                    var apiUrl =
                                        'http://62.171.184.216:9595/api/admin/leave/addleave?CorporateId=$corporateId';

                                    final fromDate = fromDateController.text;
                                    final toDate = toDateController.text;
                                    final reason = selectedLeaveType!.isNotEmpty
                                        ? selectedLeaveType
                                        : "Annual";
                                    final leaveId = selectedLeaveTypeId != 0
                                        ? selectedLeaveTypeId
                                        : 1;
                                    final leaveDuration = durationSelectedValue;
                                    final status = "string";
                                    final applicationDate =
                                    _formatDate(DateTime.now());

                                    List<Future<http.Response>> requests = [];

                                    for (final employee in selectedEmployees) {
                                      final leaveRequestList = {
                                        "employeeId": employee.empId.toString(),
                                        "fromDate": fromDate,
                                        "toDate": toDate,
                                        "reason": reason,
                                        "leaveId": leaveId,
                                        "leaveDuration": leaveDuration,
                                        "status": status,
                                        "applicationDate": applicationDate,
                                        "remark": employee.remarks,
                                      };

                                      final request = http.post(
                                        Uri.parse(apiUrl),
                                        headers: {
                                          'Content-Type': 'application/json',
                                        },
                                        body: json.encode([leaveRequestList]),
                                      );
                                      requests.add(request);
                                    }

                                    try {
                                      final responses = await Future.wait(requests);

                                      bool allRequestsSucceeded = responses.every(
                                              (response) => response.statusCode == 200);

                                      if (allRequestsSucceeded) {
                                        Fluttertoast.showToast(
                                          msg: "Leave Added Successfully",
                                          gravity: ToastGravity.BOTTOM,
                                        );
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: "Some leave requests failed",
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: AppColors.secondaryColor,
                                        );
                                      }
                                    } catch (e) {
                                      Fluttertoast.showToast(
                                        msg: "Failed to add leave: $e",
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: AppColors.secondaryColor,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.all(15),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 5.0,right: 5.0),
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // const Text(
                      //   "Selected Employees:",
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 18,
                      //   ),
                      // ),
                      Container(
                        decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                        child: DataTable(
                          headingRowColor: const MaterialStatePropertyAll(
                           AppColors.primaryColor
                          ),
                          columns: const [
                            DataColumn(
                                label: Text(
                                  "ID",
                                  style: TextStyle(color: Colors.white),
                                )),
                            DataColumn(
                                label: Text(
                                  "Name",
                                  style: TextStyle(color: Colors.white),
                                )),
                            DataColumn(
                                label: Text(
                                  "Remarks",
                                  style: TextStyle(color: Colors.white),
                                )),
                          ],
                          rows: selectedEmployees
                              .map((employee) => DataRow(
                            cells: [
                              DataCell(Text(employee.empId.toString())),
                              DataCell(Text(employee.empName.toString())),
                              DataCell(Text(employee.remarks)),
                            ],
                          ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        else {
          return Scaffold(
            body: Center(
                child: CircularProgressIndicator()),
          );
        }

      },
    );
  }

  Future<DateTime?> _selectDateTime(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    if (picked != null) {
      final TimeOfDay time = (await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      ))!;
      return DateTime(
          picked.year, picked.month, picked.day, time.hour, time.minute);
    } else {
      return null;
    }
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(dateTime);
  }
}
