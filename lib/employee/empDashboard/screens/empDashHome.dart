import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'empHomePage.dart';
import 'empAppbar.dart';

class EmpDashboard extends StatelessWidget {


  const EmpDashboard({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: const EmpDashHome(),
    );
  }
}