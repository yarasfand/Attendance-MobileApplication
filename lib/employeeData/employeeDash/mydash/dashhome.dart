import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'homepage.dart';
import 'myappbar.dart';

class MyDashboard extends StatelessWidget {
  final VoidCallback openDrawer;

  const MyDashboard({
    super.key, required this.openDrawer
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: MyAppBar(
          openDrawer: openDrawer,
        ),
      ),
      body: DashHome(),
    );
  }
}