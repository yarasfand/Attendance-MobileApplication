import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:project/constants/AppColor_constants.dart';

import '../../../introduction/bloc/bloc_internet/internet_bloc.dart';
import '../../../introduction/bloc/bloc_internet/internet_state.dart';
import 'AdminMonthly_report_page.dart';
import 'AdminSalary_report_page.dart';
import 'adminGps_tracker_report.dart';
import 'constants.dart';
import 'daily_report.dart';

class AdminReportsPage extends StatelessWidget {

  const AdminReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetBloc, InternetStates>(
        listener: (context, state) {
      // TODO: implement listener
    }, builder: (context, state) {
      if (state is InternetGainedState) {
        return Scaffold(

          body: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildCard(
                    context,
                    "Daily Report",
                    Icons.access_alarm,
                    const AdminDailyReportsPage(), // Navigate to DailyReportsPage
                  ),
                  buildCard(
                    context,
                    "GPS TRACKER REPORT",
                    Icons.calendar_today,
                    const AdminGpsTrackerReport(), // Navigate to MonthlyReportPage
                  ),
                  buildCard(
                    context,
                    "MONTHLY REPORT",
                    Icons.calendar_today,
                    const AdminMonthlyReportPage(), // Navigate to MonthlyReportPage
                  ),
                  buildCard(
                    context,
                    "SALARY REPORT",
                    Icons.monetization_on,
                    const AdminSalaryReportPage(), // Navigate to SalaryReportPage
                  ),
                ],
              ),
            ),
          ),
        );
      } else if (state is InternetLostState) {
        return Expanded(
          child: Scaffold(
            body: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "No Internet Connection!",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Lottie.asset('assets/no_wifi.json'),
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        return Expanded(
          child: Scaffold(
            body: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "No Internet Connection!",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
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
    });
  }

  Widget buildCard(
    BuildContext context,
    String title,
    IconData icon,
    Widget pageToNavigate, // Add a Widget parameter for the page to navigate
  ) {
    return Card(
      elevation: 4,
      color: AppColors.secondaryColor,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              fullscreenDialog: true,
              builder: (context) => pageToNavigate, // Use the provided page
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: const Color(0xFFFDF7F5),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
