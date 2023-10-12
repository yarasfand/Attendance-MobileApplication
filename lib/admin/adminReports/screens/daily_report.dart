import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project/admin/adminReports/screens/present_report.dart';

import '../../../introduction/bloc/bloc_internet/internet_bloc.dart';
import '../../../introduction/bloc/bloc_internet/internet_state.dart';
import 'adminAbsent_report_page.dart';
import 'adminAttendance_report_page.dart';
import 'constants.dart';

class AdminDailyReportsPage extends StatefulWidget {
  const AdminDailyReportsPage({Key? key});

  @override
  State<AdminDailyReportsPage> createState() => _AdminDailyReportsPageState();
}

class _AdminDailyReportsPageState extends State<AdminDailyReportsPage> {
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
    return BlocBuilder<InternetBloc, InternetStates>(
      builder: (context, state) {
        if(state is InternetGainedState)
          {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AdminkbackgrounColorAppBar,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              'Daily Reports',
              style: AdminkAppBarTextTheme,
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
                        '${currentDate.day}/${currentDate.month}/${currentDate
                            .year} ${currentDate.hour}:${currentDate.minute}',
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
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => AdminPresentReport(),
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
                        builder: (context) => AdminAbsentReports(),
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
                        builder: (context) => const AdminAttendanceReport(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }
        else if(state is InternetLostState)
          {
            return Expanded(
              child: Scaffold(
                body: Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No Internet Connection!",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Lottie.asset('assets/no_wifi.json'),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        else{ return Expanded(
          child: Scaffold(
            body: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No Internet Connection!",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Lottie.asset('assets/no_wifi.json'),
                  ],
                ),
              ),
            ),
          ),
        );}
      }
    );
  }

  Widget buildReportCard(BuildContext context,
      String title,
      IconData icon,
      String mainInfo,
      String secondaryInfo,
      VoidCallback onTap,) {
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
