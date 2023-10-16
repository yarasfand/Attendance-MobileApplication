import 'package:flutter/material.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'EmployeeList.dart';
import 'LeaveApprovalPage.dart';


class AdminReportsMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Page',style: TextStyle(color: AppColors.brightWhite,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.brightWhite),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeList(),)),
              child: LeaveCard(
                title: 'Leave Submission',
                image: Image.asset('assets/icons/submission.png'),
              ),
            ),
            SizedBox(height: 20), // Add spacing between cards
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveApprovalPage(),)),
              child: LeaveCard(
                title: 'Leave Approval',
                image: Image.asset('assets/icons/approval.png'),
              ),
            ),
          ],
        ),
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
          children: [
            SizedBox(
                height: 50,
                width: 50,
                child: image), // Use the provided image here
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
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
