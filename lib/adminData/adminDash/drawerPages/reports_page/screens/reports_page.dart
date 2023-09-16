import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/adminData/adminDash/drawerPages/reports_page/screens/resports_seprate_files/daily_report.dart';
import 'package:project/adminData/adminDash/drawerPages/reports_page/screens/resports_seprate_files/gps_tracker_report.dart';
import 'package:project/adminData/adminDash/drawerPages/reports_page/screens/resports_seprate_files/monthly_report_page.dart';
import 'package:project/adminData/adminDash/drawerPages/reports_page/screens/resports_seprate_files/salary_report_page.dart';
import 'package:table_calendar/table_calendar.dart';
import '../constants/constants.dart';

class ReportsPage extends StatelessWidget {
  final VoidCallback openDrawer;

  const ReportsPage({super.key, required this.openDrawer});

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text('Reports Page', style: kAppBarTextTheme),
        backgroundColor: kbackgrounColorAppBar,
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
                DailyReportsPage(), // Navigate to DailyReportsPage
              ),
              buildCard(
                context,
                "GPS TRACKER REPORT",
                Icons.calendar_today,
                GpsTrackerReport(), // Navigate to MonthlyReportPage
              ),
              buildCard(
                context,
                "MONTHLY REPORT",
                Icons.calendar_today,
                MonthlyReportPage(), // Navigate to MonthlyReportPage
              ),
              buildCard(
                context,
                "SALARY REPORT",
                Icons.monetization_on,
                SalaryReportPage(), // Navigate to SalaryReportPage
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
