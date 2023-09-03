import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../mydrawerbuilding/myappbar.dart';
import 'dashbody.dart';

class MyDashboard extends StatelessWidget {

  const MyDashboard({
    super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: MyAppBar(),
      ),
      body: MyDashBody(),
    );
  }
}