import 'dart:async';
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
import '../../../constants/AnimatedTextPopUp.dart';
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

class _LeaveSubmissionPageState extends State<LeaveSubmissionPage>
    with TickerProviderStateMixin {
  late AnimationController addToCartPopUpAnimationController;
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
    addToCartPopUpAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
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

  void showPopupWithFailedMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addToCartPopUpFailed(addToCartPopUpAnimationController, message);
      },
    );
  }

  void showPopupWithSuccessMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addToCartPopUpSuccess(
            addToCartPopUpAnimationController, message);
      },
    );
  }

  @override
  void dispose() {
    addToCartPopUpAnimationController.dispose();
    super.dispose();
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
        if (state is InternetGainedState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Leave Application",
                  style: AppBarStyles.appBarTextStyle),
              centerTitle: true,
              backgroundColor: AppColors.primaryColor,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: SingleChildScrollView(
              child: Container(
                margin: MediaQuery.of(context).size.height > 720 ? 
                  const EdgeInsets.only(top: 25, left: 25, right: 25):EdgeInsets.only(top: 25, left: 25, right: 25),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Container(
                          margin: EdgeInsets.only(left: 8),
                          child: Text(
                            "Leave Request",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
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

                            // From Date field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "From",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextFormField(
                                  controller: fromDateController,
                                  decoration: InputDecoration(
                                    labelText: "Select Date",
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.calendar_today),
                                      onPressed: () async {
                                        final selectedDate = await _selectDateTime(context);
                                        if (selectedDate != null) {
                                          fromDateController.text = _formatDate(selectedDate);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // To Date field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "To",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextFormField(
                                  controller: toDateController,
                                  decoration: InputDecoration(
                                    labelText: "Select Date",
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.calendar_today),
                                      onPressed: () async {
                                        final selectedDate = await _selectDateTime(context);
                                        if (selectedDate != null) {
                                          toDateController.text = _formatDate(selectedDate);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Leave Type field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Leave Type",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                DropdownButton<String>(
                                  isExpanded: true, // Set isExpanded to true
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
                                      selectedLeaveTypeId = leaveTypeMap[value] ?? 1;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Leave Duration field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Leave Duration",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                DropdownButton<String>(
                                  isExpanded: true, // Set isExpanded to true
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
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),


                    const SizedBox(height: 10),
                    Container(
                      child: SizedBox(
                        width: double
                            .infinity, // Make the button take the full width
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColors.primaryColor,
                            backgroundColor: Colors.white,
                            elevation: 5, // Text color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // Rounded corners
                            ),
                            padding: const EdgeInsets.all(10),
                          ),
                          onPressed: () {
                            _showBottomSheet(context);
                          },
                          child: const Text(
                            'Selected Employee(s)',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height>720? 30 : 20,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      width: double.infinity, // Set the width to take the full width
                      child: ElevatedButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String corporateId =
                              prefs.getString("corporate_id") ?? "ptsoffice";
                          print(corporateId);
                          var apiUrl =
                              'http://62.171.184.216:9595/api/admin/leave/addleave?CorporateId=$corporateId';

                          final fromDate = fromDateController.text;
                          final toDate = toDateController.text;
                          final applicationDate = _formatDate(DateTime.now());
                          final convertedApplicationDate = convertToBackendFormat(applicationDate);
                          final convertedFromDate = convertToBackendFormat(fromDate);
                          final convertedToDate = convertToBackendFormat(toDate);
                          print(convertedFromDate);
                          print(convertedToDate);
                          final reason = selectedLeaveType!.isNotEmpty
                              ? selectedLeaveType
                              : "Annual";
                          final leaveId =
                              selectedLeaveTypeId != 0 ? selectedLeaveTypeId : 1;
                          final leaveDuration = durationSelectedValue;
                          final status = "string";

                          List<Future<http.Response>> requests = [];

                          for (final employee in selectedEmployees) {
                            final leaveRequestList = {
                              "employeeId": employee.empId.toString(),
                              "fromDate": convertedFromDate,
                              "toDate": convertedToDate,
                              "reason": reason,
                              "leaveId": leaveId,
                              "leaveDuration": leaveDuration,
                              "status": status,
                              "applicationDate": convertedApplicationDate,
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

                            bool allRequestsSucceeded = responses
                                .every((response) => response.statusCode == 200);

                            if (allRequestsSucceeded) {
                              print("Added successfully");

                              addToCartPopUpAnimationController.forward();
                              Timer(const Duration(seconds: 2), () {
                                addToCartPopUpAnimationController.reverse();
                                Navigator.pop(context);
                              });
                              showPopupWithSuccessMessage(
                                  "Leave added successfully!");
                            } else {
                              print("Failed successfully");

                              addToCartPopUpAnimationController.forward();
                              Timer(const Duration(seconds: 2), () {
                                addToCartPopUpAnimationController.reverse();
                                Navigator.pop(context);
                              });
                              showPopupWithFailedMessage(
                                  "Some leave request failed!");
                            }
                          } catch (e) {
                            addToCartPopUpAnimationController.forward();
                            Timer(const Duration(seconds: 2), () {
                              addToCartPopUpAnimationController.reverse();
                              Navigator.pop(context);
                            });
                            showPopupWithFailedMessage("Failed to add leave!");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: MediaQuery.of(context).size.height>700 ? EdgeInsets.all(15): EdgeInsets.all(10),
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.white,
                              fontSize: 18
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height>700 ?  30 : 20,),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
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
    return DateFormat("yyyy-MM-dd h:mm a").format(dateTime);
  }

  String convertToBackendFormat(String inputDate) {
    // Parse the input date string
    final parsedDate = DateFormat("yyyy-MM-dd h:mm a").parse(inputDate);

    // Format the parsed date in the desired output format
    final formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(parsedDate);

    return formattedDate;
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return YourBottomSheet(widget.selectedEmployees);
      },
    );
  }
}

class YourBottomSheet extends StatelessWidget {
  final List<GetActiveEmpModel> selectedEmployees;

  YourBottomSheet(this.selectedEmployees);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: DraggableScrollableSheet(
        initialChildSize: 1, // Take up the entire screen initially
        minChildSize: 0.1, // Minimum height when fully collapsed
        maxChildSize: 1, // Maximum height when fully expanded
        expand: true,
        builder: (BuildContext context, ScrollController scrollController) {
          return SingleChildScrollView(
            reverse: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Draggable handle at the top
                Container(
                  height: 10,
                  width: 50,
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                SizedBox(height: 20,),
                // Content
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  margin: EdgeInsets.zero,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: selectedEmployees.length,
                    itemBuilder: (context, index) {
                      var employee = selectedEmployees[index];

                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${employee.empName ?? ""}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            employee.remarks.isEmpty
                                                ? "---"
                                                : employee.remarks,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            'ID: ${employee.empCode}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
