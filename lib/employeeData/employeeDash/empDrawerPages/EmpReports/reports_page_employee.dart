import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'EmpDaily_Reports_Pages/daily_report.dart';
import 'EmpGps_Tracker_Pages/gps_tracker_report.dart';
import 'EmpMonthly_Report_Pages/monthly_report_page.dart';
import 'EmpSalary_pages/salary_report_page.dart';
import 'empconstants/empConstants.dart';

class EmpReportsPage extends StatelessWidget {
  final VoidCallback openDrawer;

  const EmpReportsPage({super.key, required this.openDrawer});

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();

    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Color(0xFFE26142),
        title: Text("Reports Page",style: EmpkAppBarTextTheme),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.bars),
          color: Colors.white,
          onPressed: openDrawer,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildCard(
                context,
                "Daily Report",
                Icons.access_alarm,
                EmpDailyReportsPage(), // Navigate to DailyReportsPage
              ),
              buildCard(
                context,
                "GPS TRACKER REPORT",
                Icons.calendar_today,
                EmpGpsTrackerReport(), // Navigate to MonthlyReportPage
              ),
              buildCard(
                context,
                "MONTHLY REPORT",
                Icons.calendar_today,
                EmpMonthlyReportPage(), // Navigate to MonthlyReportPage
              ),
              buildCard(
                context,
                "SALARY REPORT",
                Icons.monetization_on,
                EmpSalaryReportPage(), // Navigate to SalaryReportPage
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(
    BuildContext context,
    String title,
    IconData icon,
    Widget pageToNavigate, // Add a Widget parameter for the page to navigate
  ) {
    return Card(
      elevation: 4,
      color: Color(0xFFE26142),
      margin: EdgeInsets.all(16),
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
                color: Color(0xFFFDF7F5),
              ),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
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

// Define the other report pages similarly...
