import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/adminData/adminDash/drawerPages/reports_page/screens/resports_seprate_files/daily_reports_pages/present_report.dart';
import '../../constants/constants.dart';

class DailyReportsPage extends StatefulWidget {
  const DailyReportsPage({Key? key});

  @override
  State<DailyReportsPage> createState() => _DailyReportsPageState();
}

class _DailyReportsPageState extends State<DailyReportsPage> {
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
        backgroundColor: kbackgrounColorAppBar,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Daily Reports',
          style: kAppBarTextTheme,
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
                    color: Colors.green,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${currentDate.day}/${currentDate.month}/${currentDate.year} ${currentDate.hour}:${currentDate.minute}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
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
                Navigator.push(context, CupertinoPageRoute(builder: (context) => PresentReport(),));
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
                Navigator.pushNamed(context, '/absent_reports');
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
                Navigator.pushNamed(context, '/attendance_report');
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
      color: const Color(0xFFE26142),
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
