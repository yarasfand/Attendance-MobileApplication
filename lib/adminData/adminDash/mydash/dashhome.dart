import 'package:flutter/material.dart';
import 'package:project/adminData/adminDash/mydash/screens/admin_page.dart';
import 'myappbar.dart';

class MyDashboard extends StatelessWidget {
  final VoidCallback openDrawer;

  const MyDashboard({
    super.key, required this.openDrawer
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: MyAppBar(
          openDrawer: openDrawer,
        ),
      ),
      body: AdminPage(),
    );
  }
}