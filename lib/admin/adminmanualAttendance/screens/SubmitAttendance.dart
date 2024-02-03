import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project/constants/AppBar_constant.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:project/introduction/bloc/bloc_internet/internet_bloc.dart';
import 'package:project/introduction/bloc/bloc_internet/internet_state.dart';

import 'package:page_transition/page_transition.dart';

import '../../../No_internet/no_internet.dart';
import '../../../constants/AnimatedTextPopUp.dart';
import '../../adminReportsFiles/models/getActiveEmployeesModel.dart';
import '../bloc/manual_punch_bloc.dart';
import '../bloc/manual_punch_event.dart';
import '../models/punchDataModel.dart';
import '../models/punchRepository.dart';

class SubmitAttendance extends StatefulWidget {
  final List<GetActiveEmpModel> selectedEmployees;

  SubmitAttendance({required this.selectedEmployees});

  @override
  _SubmitAttendanceState createState() => _SubmitAttendanceState();
}

class _SubmitAttendanceState extends State<SubmitAttendance>
    with TickerProviderStateMixin {
  late AnimationController addToCartPopUpAnimationController;
  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedInTime;
  TimeOfDay? selectedOutTime;
  bool isInternetLost = false;

  ButtonStyle commonButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.brightWhite,
    padding: const EdgeInsets.all(16),
    textStyle: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  );

  @override
  void dispose() {
    addToCartPopUpAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    addToCartPopUpAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    super.initState();
  }

  void showPopupWithMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addToCartPopUpSuccess(
          addToCartPopUpAnimationController,
          message,
        );
      },
    );
  }

  bool isDateSelected(int index) {
    DateTime currentDate = selectedDate.add(Duration(days: index));
    // You may want to compare with your actual selected date logic
    return currentDate.day == selectedDate.day;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetBloc, InternetStates>(
      listener: (context, state) {
        if (state is InternetLostState) {
          isInternetLost = true;
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.push(
              context,
              PageTransition(
                child: const NoInternet(),
                type: PageTransitionType.rightToLeft,
              ),
            );
          });
        } else if (state is InternetGainedState) {
          if (isInternetLost) {
            Navigator.pop(context);
          }
          isInternetLost = false;
        }
      },
      builder: (context, state) {
        if (state is InternetGainedState) {
          return BlocProvider(
            create: (context) => ManualPunchBloc(
              repository: ManualPunchRepository(),
            ),
            child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Manual Punch',
                  style: AppBarStyles.appBarTextStyle,
                ),
                backgroundColor: AppBarStyles.appBarBackgroundColor,
                iconTheme: const IconThemeData(
                  color: AppBarStyles.appBarIconColor,
                ),
                centerTitle: true,
              ),
              body: Builder(
                builder: (context) => Padding(
                  padding:  EdgeInsets.all(MediaQuery.of(context).size.height>700?8.0:0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          // Date and Time Selection Heading
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Select Date and Time',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 8.0, right: 50.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'From:',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'To:',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Display selected dates
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Card for the first date
                                    Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "${selectedDate.toLocal()}"
                                              .split(' ')[0],
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Add some spacing between the date cards
                                    SizedBox(width: 16),

                                    // Card for the second date
                                    Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "${selectedDate.toLocal()}"
                                              .split(' ')[0],
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: MediaQuery.of(context).size.height>700?20:0),

                          // Card for Date Selection
                          Card(
                            elevation: 8.0,
                            margin: const EdgeInsets.all(16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 80, // Adjust height as needed
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 14,
                                      padding: EdgeInsets.only(
                                          bottom:
                                              6), // Add padding to the bottom
                                      itemBuilder: (context, index) {
                                        final currentDate = selectedDate
                                            .add(Duration(days: index - 6));
                                        return GestureDetector(
                                          onTap: () {
                                            // Handle date selection here
                                            setState(() {
                                              selectedDate = currentDate;
                                            });
                                          },
                                          child: Container(
                                            width: 50, // Adjust as needed
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 4),
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              color: isDateSelected(index - 6)
                                                  ? Colors.blueAccent
                                                  : Colors.transparent,
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  DateFormat('E')
                                                      .format(currentDate),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: isDateSelected(
                                                            index - 6)
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  "${currentDate.day}",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: isDateSelected(
                                                            index - 6)
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  // Dates Row

                                  const SizedBox(height: 20),

                                  // Dropdown for Year and Month Selection
                                  Card(
                                    elevation: 4.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          // Year Dropdown
                                          DropdownButton<String>(
                                            value:
                                                '${selectedDate.year}', // Set the initial selected year
                                            onChanged: (String? newValue) {
                                              // Handle the year selection
                                              setState(() {
                                                selectedDate = DateTime(
                                                    int.parse(newValue!),
                                                    selectedDate.month,
                                                    selectedDate.day);
                                              });
                                            },
                                            items: <String>[
                                              '2022',
                                              '2023',
                                              '2024',
                                              '2025'
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              );
                                            }).toList(),
                                          ),

                                          DropdownButton<String>(
                                            value: DateFormat('MMMM').format(
                                                selectedDate), // Set the initial selected month
                                            onChanged: (String? newValue) {
                                              // Handle the month selection
                                              setState(() {
                                                final selectedMonth =
                                                    DateFormat('MMMM')
                                                        .parse(newValue!);
                                                selectedDate = DateTime(
                                                    selectedDate.year,
                                                    selectedMonth.month,
                                                    selectedDate.day);
                                              });
                                            },
                                            items: <String>[
                                              'January',
                                              'February',
                                              'March',
                                              'April',
                                              'May',
                                              'June',
                                              'July',
                                              'August',
                                              'September',
                                              'October',
                                              'November',
                                              'December'
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              );
                                            }).toList(),
                                          ),

                                          // Display selected month and year together
                                          Text(
                                            '${selectedDate.month}/${selectedDate.year}', // Update with the concatenated values
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Card with Buttons
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16.0, top: 16.0),
                            child: Row(
                              children: <Widget>[
                                // Button for In Time Selection
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _selectTime(
                                      context,
                                      selectedInTime,
                                      (time) {
                                        setState(() {
                                          selectedInTime = time;
                                        });
                                      },
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                      elevation: 4.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    child: Text(
                                      selectedInTime != null
                                          ? 'In: ${selectedInTime!.format(context)}'
                                          : 'Select In Time',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                    width:
                                        10), // Adjust the spacing between buttons

                                // Button for Out Time Selection
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _selectTime(
                                      context,
                                      selectedOutTime,
                                      (time) {
                                        setState(() {
                                          selectedOutTime = time;
                                        });
                                      },
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      elevation: 4.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    child: Text(
                                      selectedOutTime != null
                                          ? 'Out: ${selectedOutTime!.format(context)}'
                                          : 'Select Out Time',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: SizedBox(
                              width: double
                                  .infinity, // Make the button take the full width
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  primary:
                                      Colors.white, // White background color
                                  onPrimary:
                                      AppColors.primaryColor, // Text color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Rounded corners
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
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 50),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: AppColors.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                   padding: EdgeInsets.all(MediaQuery.of(context).size.height>700?20:10),
                                ),
                                onPressed: () {
                                  _submitAttendance(context);
                                },
                                child: const Text('Submit',style: TextStyle(color: Colors.white,fontSize: 18),),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height > 700?10:5,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  void _submitAttendance(BuildContext context) {
    final List<PunchData> requestDataList = [];

    for (final employee in widget.selectedEmployees) {
      final formattedDate = DateFormat("yyyy-MM-dd").format(selectedDate);
      final formattedInTime = selectedInTime != null
          ? DateFormat("yyyy-MM-ddTHH:mm:ss").format(
              DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedInTime!.hour,
                selectedInTime!.minute,
              ),
            )
          : '2023-10-10T09:00:00';

      final formattedOutTime = selectedOutTime != null
          ? DateFormat("yyyy-MM-ddTHH:mm:ss").format(
              DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedOutTime!.hour,
                selectedOutTime!.minute,
              ),
            )
          : '2023-10-10T10:00:00';

      final inTime = PunchData(
        cardNo: employee.empCode ?? '',
        punchDatetime: formattedInTime,
        pDay: "N",
        isManual: "Y",
        payCode: "1999",
        machineNo: "1",
        datetime1: formattedOutTime,
        viewInfo: 0,
        showData: 0,
        remark: employee.remarks ?? '',
      );

      final outTime = PunchData(
        cardNo: employee.empCode ?? '',
        punchDatetime: formattedOutTime,
        pDay: "N",
        isManual: "Y",
        payCode: "1999",
        machineNo: "1",
        datetime1: formattedInTime,
        viewInfo: 0,
        showData: 0,
        remark: employee.remarks ?? '',
      );

      requestDataList.add(inTime);
      requestDataList.add(outTime);
    }

    context.read<ManualPunchBloc>().add(
          ManualPunchSubmitEvent(
            requestDataList: requestDataList,
          ),
        );
    addToCartPopUpAnimationController.forward();

    // Delay for a few seconds and then reverse the animation
    Timer(const Duration(seconds: 2), () {
      addToCartPopUpAnimationController.reverse();
      Navigator.pop(context);
    });
    showPopupWithMessage("Marked Successfully!");
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(
    BuildContext context,
    TimeOfDay? selectedTime,
    Function(TimeOfDay) onTimeSelected,
  ) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      onTimeSelected(pickedTime);
    }
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
