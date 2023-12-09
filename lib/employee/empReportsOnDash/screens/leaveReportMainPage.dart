import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/constants/AppBar_constant.dart';
import 'package:project/constants/AppColor_constants.dart';

import 'leave_history_page.dart';
import 'leave_request_application_page.dart';

class LeaveRequestPage extends StatelessWidget {
  late final bool viaDrawer;
  LeaveRequestPage({required this.viaDrawer});

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
      appBar: viaDrawer ? null
        : AppBar(
            backgroundColor: AppBarStyles.appBarBackgroundColor,
        iconTheme: IconThemeData(color: AppBarStyles.appBarIconColor),
        title: Text("Leaves",style: AppBarStyles.appBarTextStyle,),
        centerTitle: true,

      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => LeaveRequestForm(),
                      ));
                },
                child: CardWidget(
                  image: Image.asset("assets/images/request.png"),
                  text: 'LEAVE APPLICATION',
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => LeavesHistoryPage(),
                      ));
                },
                child: CardWidget(
                  image: Image.asset("assets/images/history.png"),
                  text: 'LEAVES DETAILS',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final Image image;
  final String text;

  CardWidget({required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width *
          0.8, // Adjust card width as needed
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.secondaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50, width: 50, child: image),
            const SizedBox(height: 20),
            Text(
              text,
              style: const TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
