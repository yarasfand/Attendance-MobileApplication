import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/DailyReport_repository.dart';
import '../models/DailyReports_model.dart';

class DailyReportsPage extends StatefulWidget {
  const DailyReportsPage({Key? key}) : super(key: key);

  @override
  State<DailyReportsPage> createState() => _DailyReportsPageState();
}

class _DailyReportsPageState extends State<DailyReportsPage> {
  DateTime _selectedDate = DateTime.now();
  final DailyReportsRepository _repository = DailyReportsRepository();
  List<DailyReportsModel> _dailyReports = [];
  String empCode = "";

  String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
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
      setState(() {
        _selectedDate = picked;
      });

      _fetchAndDisplayReports(_selectedDate);
    }
  }

  void _fetchAndDisplayReports(DateTime selectedDate) async {
    try {
      final formattedDate = formatDateTime(selectedDate);

      final DateTime reportDateTime = DateTime.parse(formattedDate);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? corporateId = prefs.getString('corporate_id');
      final int? employeeId = prefs.getInt('employee_id');
      empCode = prefs.getString('empCode')!;

      if (corporateId != null && employeeId != null) {
        final response = await _repository.getDailyReports(
          corporateId: corporateId,
          employeeId: employeeId,
          reportDate: reportDateTime,
        );

        if (response is List<DailyReportsModel>) {
          setState(() {
            _dailyReports = response;
          });
        } else {
          print('API response is not a List of DailyReportsModel');
        }
      } else {
        print('Corporate ID or Employee ID is null');
      }
    } catch (e) {
      print('Error fetching reports: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daily Report',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              color: AppColors.primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Center(
                      child: Text(
                        '${_selectedDate.toLocal()}'.split(' ')[0],
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
                            _fetchAndDisplayReports(_selectedDate);
                          },
                          child: const Text('Fetch Reports'),
                        ),
                      ],
                    )

                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
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
    return 'N/A';
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
              value: empCode ?? 'N/A',
            ),
            DailyInfoSubCard(
              title: 'Shift Start Time',
              value: formatTime(report.shiftStartTime) ?? 'N/A',
            ),
            DailyInfoSubCard(
              title: 'Shift End Time',
              value: formatTime(report.shiftEndTime) ?? 'N/A',
            ),
            DailyInfoSubCard(
              title: 'Status',
              value: report.status ?? 'N/A',
            ),
            DailyInfoSubCard(
              title: 'Hours Worked',
              value: report.hoursWorked.toString() ?? 'N/A',
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
