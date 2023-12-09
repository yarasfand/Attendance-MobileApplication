import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/constants/AppBar_constant.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:project/introduction/bloc/bloc_internet/internet_bloc.dart';
import 'package:project/introduction/bloc/bloc_internet/internet_state.dart';
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

class _SubmitAttendanceState extends State<SubmitAttendance> with TickerProviderStateMixin{

  late AnimationController addToCartPopUpAnimationController;
  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedInTime;
  TimeOfDay? selectedOutTime;
  bool isInternetLost = false;

  ButtonStyle commonButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.brightWhite, // Button background color
    padding: const EdgeInsets.all(16), // Padding around the button
    textStyle: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Colors.black, // Text color
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
    // TODO: implement initState
    super.initState();
  }

  void showPopupWithMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addToCartPopUpSuccess(
            addToCartPopUpAnimationController,
            message
        );
      },
    );
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
            create: (context) => ManualPunchBloc(repository: ManualPunchRepository()),
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Punch Attendance', style: AppBarStyles.appBarTextStyle),
                backgroundColor: AppBarStyles.appBarBackgroundColor,
                iconTheme: const IconThemeData(color: AppBarStyles.appBarIconColor),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Card(

                        elevation: 4.0,
                        margin: const EdgeInsets.all(16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              const Text(
                                'Select Date and Time',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Select Date
                              ElevatedButton(
                                onPressed: () => _selectDate(context),
                                style: commonButtonStyle,
                                child: Text(
                                  "${selectedDate.toLocal()}".split(' ')[0],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.blueAccent, // Text color
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              ElevatedButton(
                                onPressed: () => _selectTime(context, selectedInTime, (time) {
                                  setState(() {
                                    selectedInTime = time;
                                  });
                                }),
                                style: commonButtonStyle,
                                child: Text(
                                  selectedInTime != null
                                      ? selectedInTime!.format(context)
                                      : 'Select In Time',
                                ),
                              ),
                              const SizedBox(height: 10),

                              ElevatedButton(
                                onPressed: () => _selectTime(context, selectedOutTime, (time) {
                                  setState(() {
                                    selectedOutTime = time;
                                  });
                                }),
                                style: commonButtonStyle,
                                child: Text(
                                  selectedOutTime != null
                                      ? selectedOutTime!.format(context)
                                      : 'Select Out Time',
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),


                      Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            headingRowColor: const MaterialStatePropertyAll(AppColors.primaryColor),
                            columns: const [
                              DataColumn(label: Text('ID', style: TextStyle(color: Colors.white))),
                              DataColumn(label: Text('Name', style: TextStyle(color: Colors.white))),
                              DataColumn(label: Text('Remarks', style: TextStyle(color: Colors.white))),
                            ],
                            rows: widget.selectedEmployees.map((employee) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(employee.empCode ?? '')),
                                  DataCell(Text(employee.empName ?? '')),
                                  DataCell(Text(employee.remarks ?? '')),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.only(left:50,right: 50),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: AppColors.primaryColor, // Change the text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50), // Adjust the button's border radius
                            ),
                            padding: const EdgeInsets.all(16), // Add padding around the button text
                          ),
                          onPressed: () {
                            final List<PunchData> requestDataList = [];

                            for (final employee in widget.selectedEmployees) {
                              final formattedDate =
                              DateFormat("yyyy-MM-dd").format(selectedDate);
                              final formattedInTime = selectedInTime != null
                                  ? DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedInTime!.hour,
                                selectedInTime!.minute,
                              ))
                                  : '2023-10-10T09:00:00';

                              final formattedOutTime = selectedOutTime != null
                                  ? DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedOutTime!.hour,
                                selectedOutTime!.minute,
                              ))
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
                            Timer(const Duration(seconds: 2), () {
                              addToCartPopUpAnimationController.reverse();
                              Navigator.pop(context);
                            });
                            showPopupWithMessage("Marked successfully!");
                          },
                          child: const Text('Submit Attendance'),
                        ),
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

  Widget _buildTimePicker({
    required String title,
    TimeOfDay? selectedTime,
    required Function(TimeOfDay) onTimeSelected,
  }) {
    return Row(
      children: [
        Text("$title: "),
        TextButton(
          onPressed: () => _selectTime(context, selectedTime, onTimeSelected),
          child: Text(
            selectedTime != null
                ? selectedTime.format(context)
                : 'Select $title',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
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
}
