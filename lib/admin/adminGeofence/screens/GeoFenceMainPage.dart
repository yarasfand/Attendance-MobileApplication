import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/admin/adminGeofence/screens/adminGeofencing.dart';
import 'package:project/admin/pendingLeavesApproval/model/ApproveManualPunchRepository.dart';
import 'package:project/admin/pendingLeavesApproval/screens/PendingLeavesPage.dart';


class GeoFenceMainPage extends StatefulWidget {
  const GeoFenceMainPage({Key? key}) : super(key: key);

  @override
  State<GeoFenceMainPage> createState() => _GeoFenceMainPageState();
}

class _GeoFenceMainPageState extends State<GeoFenceMainPage> {
  bool isInternetLost = false;

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.all(30),
              width: double.infinity, // Make the width full
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const AdminGeofencing(),
                      type: PageTransitionType.rightToLeft,
                    ),
                  );
                },
                child: LeaveCard(
                  image: Image.asset("assets/icons/setGeofenceAdmin.png"),
                  title: 'Set Geofence',
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(30),
              width: double.infinity, // Make the width full
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: PendingLeavesPage(
                        approveRepository: ApproveManualPunchRepository(),
                      ),
                      type: PageTransitionType.rightToLeft,
                    ),
                  );
                },
                child: LeaveCard(
                  image: Image.asset("assets/icons/geoPunchAdmin.png"),
                  title: 'GeoPunch Approval',
                ),
              ),
            ),
          ),
          WillPopScope(
            onWillPop: () async {
              return _onBackPressed(context).then((value) => value ?? false);
            },
            child: const SizedBox(),
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
