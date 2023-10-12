import 'package:flutter/material.dart';

import 'EmployeeList.dart';
import 'LeaveApprovalPage.dart';


class AdminReportsMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeList(),)),
              child: LeaveCard(
                title: 'Leave Submission',
                icon: Icons.send,
              ),
            ),
            SizedBox(height: 20), // Add spacing between cards
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveApprovalPage(),)),
              child: LeaveCard(
                title: 'Leave Approval',
                icon: Icons.check,
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
  final IconData icon;

  LeaveCard({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 60,
              color: Colors.blue,
            ),
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
