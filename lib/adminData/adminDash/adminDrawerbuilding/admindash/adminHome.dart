import 'package:flutter/material.dart';
import 'adminAppbar.dart';
import 'adminScreens/admin_page.dart';

class AdminDashboard extends StatelessWidget {
  final VoidCallback openDrawer;

  const AdminDashboard({
    super.key, required this.openDrawer
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: AdminAppBar(
          openDrawer: openDrawer,
        ),
      ),
      body: AdminPage(),
    );
  }
}