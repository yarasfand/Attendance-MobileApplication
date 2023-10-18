import 'package:flutter/material.dart';
import 'package:project/admin/adminOptionsReport/screens/AdminDailyReportsEmployeListPage.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'AdminReportsEmployeeListPage.dart';

class AdminMonthlyAndDailyReportsMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leave Page',
          style: TextStyle(color: AppColors.brightWhite, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.brightWhite),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity, // Make the width full
              child: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminDailyReportEmployeeListPage(),)),
                child: LeaveCard(
                  title: 'DAILY REPORTS',
                  image: Image.asset('assets/icons/submission.png'),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity, // Make the width full
              child: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminReportEmployeeListPage(),)),
                child: LeaveCard(
                  title: 'MONTHLY REPORTS',
                  image: Image.asset('assets/icons/approval.png'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LeaveCard extends StatelessWidget {
  final String title;
  final Image image;

  LeaveCard({required this.title, required this.image});

@override
Widget build(BuildContext context) {
  return Card(
    elevation: 4.0,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: image, // Use the provided image here
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
}
