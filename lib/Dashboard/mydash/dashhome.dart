import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../mydrawerbuilding/myappbar.dart';
import 'dashbody.dart';

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
      body: MyDashBody(),
    );
  }
}