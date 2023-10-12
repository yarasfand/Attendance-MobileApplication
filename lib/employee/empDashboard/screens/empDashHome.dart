import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'empHomePage.dart';
import 'empAppbar.dart';

class EmpDashboard extends StatelessWidget {

  final VoidCallback openDrawer;

  const EmpDashboard({
    super.key, required this.openDrawer
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: EmpAppBar(
          openDrawer: openDrawer,
        ),
      ),
      body: const EmpDashHome(),
    );
  }
}