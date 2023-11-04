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
    formattedSelectedDate = showFormatDateTime(_selectedDate); // Format the current date
    _fetchAndDisplayReports(formatDateTime(_selectedDate)); // Fetch data for the current date
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

      final formattedDateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(picked);
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
          corporateId: corporateId,
          employeeId: employeeId,
          reportDate: parsedDateTime,
        );

        if (response is List<DailyReportsModel>) {
          setState(() {
            _dailyReports = response;
            formattedSelectedDate = formattedSelectedDate; // Store the formatted date
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daily Report',
          style: AppBarStyles.appBarTextStyle
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          Card(
            elevation: 5,
            color: AppColors.secondaryColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Center(
                    child: Text(
                      formattedSelectedDate,
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _selectFromDate(context);
                        },
                        child: const Text('Select Date'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          String formattedDate = formatDateTime(_selectedDate);

                          _fetchAndDisplayReports(formattedDate);
                        },
                        child: const Text('Fetch Reports'),
                      ),
                    ],
                  )

                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
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
    return Card(
      color: Color(0xFF0F4C81), // Background color for the list items
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Info',
              style: GoogleFonts.openSans(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Add Daily info sub-cards here
            DailyInfoSubCard(
              title: 'ID',
              value: empCode ?? '---',
            ),
            DailyInfoSubCard(
              title: 'Shift Start Time',
              value: formatTime(report.shiftStartTime) ?? '---',
            ),
            DailyInfoSubCard(
              title: 'Shift End Time',
              value: formatTime(report.shiftEndTime) ?? '---',
            ),
            DailyInfoSubCard(
              title: 'Status',
              value: report.status ?? '---',
            ),
            DailyInfoSubCard(
              title: 'Hours Worked',
              value: report.hoursWorked.toString() ?? '---',
            ),
            DailyInfoSubCard(
              title: 'Punch InTime',
              value: formatTime(report.in1) ?? '---',
            ),
            DailyInfoSubCard(
              title: 'Punch OutTime',
              value: formatTime(report.out2) ?? '---',
            ),


          ],
        ),
      ),
    );
  }
}

class DailyInfoSubCard extends StatelessWidget {
  final String title;
  final String value;

  DailyInfoSubCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF5F5F5), // Background color for the sub-cards
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.openSans(
                textStyle: const TextStyle(
                  color: Color(0xFF0F52BA),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Text(
              value,
              style: GoogleFonts.openSans(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
