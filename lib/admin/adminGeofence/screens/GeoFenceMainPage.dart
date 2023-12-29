import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/admin/adminGeofence/screens/adminGeofencing.dart';
import 'package:project/admin/pendingLeavesApproval/model/ApproveManualPunchRepository.dart';
import 'package:project/admin/pendingLeavesApproval/screens/PendingLeavesPage.dart';
import '../../../No_internet/no_internet.dart';
import '../../../introduction/bloc/bloc_internet/internet_bloc.dart';
import '../../../introduction/bloc/bloc_internet/internet_state.dart';

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
            child: CardButton(
              text: 'Set Geofence',
              image: Image.asset(
                  'assets/icons/map.png'), // Replace with your image path
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: const AdminGeofencing(),
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 500),
                  ),
                );
                // Implement the action for Set Geofence here.
              },
            ),
          ),
          Expanded(
            child: CardButton(
              text: 'GeoPunch Approval',
              image: Image.asset('assets/icons/geoapproval.png'),
              // Replace with your image path
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: PendingLeavesPage(
                      approveRepository: ApproveManualPunchRepository(),
                    ),
                    type: PageTransitionType.rightToLeft,
                  ),
                );
                // Implement the action for GeoFence Approval here.
              },
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

class CardButton extends StatelessWidget {
  final String text;
  final Image image;
  final VoidCallback onPressed;

  CardButton({
    required this.text,
    required this.image,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin:
          const EdgeInsets.only(left: 30.0, right: 30.0, top: 50, bottom: 50),
      // Reduce the margin for a smaller card
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 40, // Adjust the width and height for a smaller image
                height: 40,
                child: image,
              ),
              const SizedBox(width: 12.0), // Reduce spacing
              Text(
                text,
                style: const TextStyle(
                  fontSize: 18.0, // Adjust the font size as needed
                  fontWeight: FontWeight.normal, // Use normal font weight
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
