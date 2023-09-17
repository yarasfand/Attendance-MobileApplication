import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:project/employeeData/employeeDash/empDrawerPages/EmpReports/EmpSalary_pages/salary_report_details_page.dart';
class EmpSalaryReportPage extends StatefulWidget {
  const EmpSalaryReportPage({super.key});

  @override
  State<EmpSalaryReportPage> createState() => _EmpSalaryReportPageState();
}

class _EmpSalaryReportPageState extends State<EmpSalaryReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Salary Report',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor:
        const Color(0xFFE26142), // Match the GPS Tracker Page's theme
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_month),
                Text(
                  DateFormat('MMMM dd, yyyy').format(DateTime.now()), // Format the current date
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                onTap: () {
                  // Handle button tap here

                    Navigator.push(context, CupertinoPageRoute(builder: (context) => EmpSalaryReportDetail(),),);

                },
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 24,
                        color: Color(
                            0xFFE26142), // Match the GPS Tracker Page's theme
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Salary Report',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
