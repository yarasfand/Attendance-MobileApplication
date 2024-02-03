import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:project/constants/AppBar_constant.dart';
import 'package:project/constants/AppColor_constants.dart';

import 'Daily_reports.dart';
import 'Monthly_reports.dart';

class ReportsMainPage extends StatelessWidget {
  late final bool viaDrawer;

  ReportsMainPage({required this.viaDrawer});

  Future<bool?> _onBackPressed(BuildContext context) async {
    bool? exitConfirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Exit'),
        content: Text('Are you sure you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );

    if (exitConfirmed == true) {
      exitApp();
      return true;
    } else {
      return false;
    }
  }

  void exitApp() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: viaDrawer
          ? null
          : AppBar(
              title: const Text(
                'Reports',
                style: AppBarStyles.appBarTextStyle
              ),
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
              centerTitle: true,
              backgroundColor: AppColors.primaryColor,
            ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          viaDrawer
              ? WillPopScope(
                  onWillPop: () async {
                    return _onBackPressed(context)
                        .then((value) => value ?? false);
                  },
                  child: const SizedBox(),
                )
              : SizedBox(),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(30),
              width: double.infinity, // Make the width full
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => MonthlyReportsPage(),
                      ));
                },
                child: LeaveCard(
                  image: Image.asset("assets/icons/monthlyReport.png"),
                  title: 'MONTHLY REPORT',
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(30),
              width: double.infinity, // Make the width full
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => DailyReportsPage(),
                      ));
                },
                child: LeaveCard(
                  image: Image.asset("assets/icons/dailyReport.png"),
                  title: 'DAILY REPORT',
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
              height: 100,
              width: 100,
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
