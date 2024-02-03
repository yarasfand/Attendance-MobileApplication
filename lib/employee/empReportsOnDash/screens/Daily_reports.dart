import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/constants/AppBar_constant.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/DailyReport_repository.dart';
import '../models/DailyReports_model.dart';

class DailyReportsPage extends StatefulWidget {
  const DailyReportsPage({Key? key}) : super(key: key);

  @override
  State<DailyReportsPage> createState() => _DailyReportsPageState();
}

String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat("dd MMMM yyyy", 'en_US');
  return formatter.format(dateTime);
}

class _DailyReportsPageState extends State<DailyReportsPage> {
  DateTime _selectedDate = DateTime.now();
  final DailyReportsRepository _repository = DailyReportsRepository();
  List<DailyReportsModel> _dailyReports = [];
  String empCode = "";
  bool isLoading = false; // Add a loading indicator variable
  String formattedSelectedDate = ""; // Add this property

  @override
  void initState() {
    super.initState();
    formattedSelectedDate =
        showFormatDateTime(_selectedDate); // Format the current date
    _fetchAndDisplayReports(
        formatDateTime(_selectedDate)); // Fetch data for the current date
  }

  String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    return formatter.format(dateTime);
  }

  String showFormatDateTime(DateTime dateTime) {
    final formatter = DateFormat("d MMMM y", 'en_US');
    return formatter.format(dateTime);
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      final outputFormatter = DateFormat("d MMMM y", 'en_US');
      final formattedDate = outputFormatter.format(picked);

      setState(() {
        _selectedDate = picked;
        formattedSelectedDate = formattedDate; // Update formattedSelectedDate
      });

      final formattedDateTime =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(picked);
      _fetchAndDisplayReports(formattedDateTime);
    }
  }

  void _fetchAndDisplayReports(String formattedDate) async {
    try {
      setState(() {
        isLoading = true;
      });

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? corporateId = prefs.getString('corporate_id');
      final int? employeeId = prefs.getInt('employee_id');
      empCode = prefs.getString('empCode')!;

      if (corporateId != null && employeeId != null) {
        final DateFormat inputFormatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
        final DateTime parsedDateTime = inputFormatter.parse(formattedDate);

        final DateFormat outputFormatter = DateFormat("dd MMMM yyyy", 'en_US');
        String formattedSelectedDate = outputFormatter.format(parsedDateTime);

        final response = await _repository.getDailyReports(
          reportDate: parsedDateTime,
        );

        if (response is List<DailyReportsModel>) {
          setState(() {
            _dailyReports = response;
            formattedSelectedDate =
                formattedSelectedDate; // Store the formatted date
            isLoading = false;
          });
        } else {
          print('API response is not a List of DailyReportsModel');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print('Corporate ID or Employee ID is null');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching reports: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  bool isDateSelected(int index) {
    final currentDate = _selectedDate.add(Duration(days: index));
    return currentDate.day == _selectedDate.day &&
        currentDate.month == _selectedDate.month &&
        currentDate.year == _selectedDate.year;
  }

  // DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Report', style: AppBarStyles.appBarTextStyle),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Center(
                child: Card(
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
                          height: 70,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 14,
                            padding: EdgeInsets.only(bottom: 20),
                            itemBuilder: (context, index) {
                              final currentDate =
                                  _selectedDate.add(Duration(days: index - 6));
                              return GestureDetector(
                                onTap: () {
                                  // Handle date selection here
                                  setState(() {
                                    _selectedDate = currentDate;
                                    formattedSelectedDate =
                                        showFormatDateTime(_selectedDate);
                                  });
                                },
                                child: Container(
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: isDateSelected(index - 6)
                                        ? Colors.blueAccent
                                        : Colors.transparent,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        DateFormat('E').format(currentDate),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: isDateSelected(index - 6)
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "${currentDate.day}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: isDateSelected(index - 6)
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
                        Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              DropdownButton<String>(
                                value: '${_selectedDate.year}',
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedDate = DateTime(
                                      int.parse(newValue!),
                                      _selectedDate.month,
                                      _selectedDate.day,
                                    );
                                    formattedSelectedDate =
                                        showFormatDateTime(_selectedDate);
                                  });
                                },
                                items: <String>[
                                  '2022',
                                  '2023',
                                  '2024',
                                  '2025'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  );
                                }).toList(),
                              ),
                              DropdownButton<String>(
                                value: DateFormat('MMMM').format(_selectedDate),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    final selectedMonth =
                                        DateFormat('MMMM').parse(newValue!);
                                    _selectedDate = DateTime(
                                      _selectedDate.year,
                                      selectedMonth.month,
                                      _selectedDate.day,
                                    );
                                    formattedSelectedDate =
                                        showFormatDateTime(_selectedDate);
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
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  );
                                }).toList(),
                              ),
                              Text(
                                '${_selectedDate.month}/${_selectedDate.year}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Visibility(
              visible: !isLoading, // Show data when not loading
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: _dailyReports.length,
                  itemBuilder: (context, index) {
                    final report = _dailyReports[index];
                    return DailyInfoCard(report: report, empCode: empCode);
                  },
                ),
              ),
              replacement: Center(
                // Show loading indicator when loading
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColors.primaryColor,
            ),
            child: ElevatedButton(
              onPressed: () {
                // Format the selected date before passing it to the function
                String formattedDate = formatDateTime(_selectedDate);
                _fetchAndDisplayReports(formattedDate);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors
                    .transparent, // Set to transparent to use the Container's color
                elevation: 0, // Set to 0 to remove the default button elevation
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Text(
                'Fetch Reports',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);

    for (var i = 0; i < size.width; i++) {
      final x = i.toDouble();
      final y = 3 * sin(x / 10) + size.height - 10;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class DailyInfoCard extends StatelessWidget {
  final DailyReportsModel report;
  String empCode;
  DailyInfoCard({required this.report, required this.empCode});

  String formatTime(DateTime? time) {
    if (time != null) {
      final formatter = DateFormat.jm(); // Display time in AM/PM format
      return formatter.format(time);
    }
    return '---';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            padding: EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Data Table Template
                Container(
                  child: Material(
                    elevation: 8, // Set your desired elevation
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(8.0)),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(8.0)),
                        color: AppColors.primaryColor,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                      width: double.infinity,
                      child: Text(
                        'Daily Info',
                        style: GoogleFonts.albertSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(8.0)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 2),
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'ID',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 30),
                            padding: EdgeInsets.all(8),
                            child: Center(
                                child: Text(
                              'Status',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            )),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.white, // Divider color
                                ),
                              ),
                            ),
                            child: Text(
                              empCode ?? "---",
                              style: GoogleFonts.openSans(
                                fontSize: 18, // Set your desired font size
                                fontWeight: FontWeight.bold,
                                color:
                                    Colors.black, // Set your desired text color
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 78),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.white, // Divider color
                                ),
                              ),
                            ),
                            child: Text(
                              report.status ?? "---",
                              style: GoogleFonts.openSans(
                                fontSize: 18, // Set your desired font size
                                fontWeight: FontWeight.bold,
                                color:
                                    Colors.black, // Set your desired text color
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shift In',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    fontFamily:
                                        'YourFont', // Replace 'YourFont' with your preferred font
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height > 700
                                            ? 8
                                            : 0),
                                Container(
                                  width: 80,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    formatTime(report.shiftStartTime) ?? '---',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height > 700
                                            ? 16
                                            : 0),
                                Text(
                                  'Punch In',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    fontFamily:
                                        'YourFont', // Replace 'YourFont' with your preferred font
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height > 700
                                            ? 8
                                            : 0),
                                Container(
                                  width: 80,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    formatTime(report.in1) ?? '---',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),

                            SizedBox(
                                width: MediaQuery.of(context).size.height > 700
                                    ? 16
                                    : 10), // Add spacing between the columns
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shift Out',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    fontFamily:
                                        'YourFont', // Replace 'YourFont' with your preferred font
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height > 700
                                            ? 8
                                            : 0),
                                Container(
                                  width: 80,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    formatTime(report.shiftEndTime) ?? '---',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height > 700
                                            ? 16
                                            : 0),
                                Text(
                                  'Punch Out',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    fontFamily:
                                        'YourFont', // Replace 'YourFont' with your preferred font
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height > 700
                                            ? 8
                                            : 0),
                                Container(
                                  width: 80,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        formatTime(report.out2) ?? '---',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
