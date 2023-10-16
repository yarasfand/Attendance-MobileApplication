import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:project/employee/empReports/screens/present_report.dart';

import 'absent_report_page.dart';
import 'attendance_report_page.dart';
import 'empConstants.dart';

class EmpDailyReportsPage extends StatefulWidget {
  const EmpDailyReportsPage({Key? key});

  @override
  State<EmpDailyReportsPage> createState() => _EmpDailyReportsPageState();
}

class _EmpDailyReportsPageState extends State<EmpDailyReportsPage> {
  DateTime currentDate = DateTime.now(); // Get the current date and time

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentDate = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Daily Reports',
          style: EmpkAppBarTextTheme,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    size: 32,
                    color: AppColors.darkGrey,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${currentDate.day}/${currentDate.month}/${currentDate.year} ${currentDate.hour}:${currentDate.minute}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey,
                    ),
                  ),
                ],
              ),
            ),
            buildReportCard(
              context,
              "Present Reports",
              Icons.check_circle_outline,
              "Total Present: 30",
              "Late Entries: 2",
              () {
                // Navigate to the Present Reports page
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => EmpPresentReport(),
                    ));
              },
            ),
            buildReportCard(
              context,
              "Absent Reports",
              Icons.cancel,
              "Total Absent: 10",
              "Unexcused Absences: 3",
              () {
                // Navigate to the Absent Reports page
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => EmpAbsentReports(),
                  ),
                );
              },
            ),
            buildReportCard(
              context,
              "Attendance Report",
              Icons.bar_chart,
              "Total Attendance: 90%",
              "Average Attendance: 95%",
              () {
                // Navigate to the Attendance Report page
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const EmpAttendanceReport(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReportCard(
    BuildContext context,
    String title,
    IconData icon,
    String mainInfo,
    String secondaryInfo,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      color: AppColors.navyBlue,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 32,
                color: const Color(0xFFFDF7F5),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFDF7F5),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                mainInfo,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFFFDF7F5),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                secondaryInfo,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFFDF7F5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
