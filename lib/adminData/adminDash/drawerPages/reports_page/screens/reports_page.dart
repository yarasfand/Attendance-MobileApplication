import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/adminData/adminDash/drawerPages/reports_page/screens/resports_seprate_files/daily_report.dart';
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
        title: Text('Reports Page',style: kAppBarTextTheme),
        backgroundColor:kbackgrounColorAppBar,
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
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Text(
              //     '${currentDate.day}/${currentDate.month}/${currentDate.year} ${currentDate.hour}:${currentDate.minute}',
              //     style: TextStyle(
              //       fontSize: 18,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.blue,
              //     ),
              //   ),
              // ),

              buildCard(context,"Daily Report", Icons.access_alarm),
              buildCard(context,"GPS Report", Icons.location_on),
              buildCard(context,"Approved GPS Punch", Icons.check_circle_outline),
              buildCard(context,"GPS Tracker Report", Icons.gps_fixed),
              buildCard(context,"Monthly Report", Icons.calendar_today),
              buildCard(context,"Salary Report", Icons.monetization_on),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context,String title, IconData icon) {
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
            CupertinoPageRoute(fullscreenDialog: true,
                builder: (context) => DailyReportsPage()),
          );
          // Add your onTap action here
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

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TableCalendar(
          availableCalendarFormats: const {
            CalendarFormat.month: 'Month',
          },
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
          ),
          focusedDay: DateTime.now(),
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
        ),
      ),
    );
  }
}
