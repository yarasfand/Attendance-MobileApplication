import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/admin/adminGeofence/screens/adminGeofencing.dart';
import 'package:project/admin/pendingLeavesApproval/model/ApproveManualPunchRepository.dart';
import 'package:project/admin/pendingLeavesApproval/screens/PendingLeavesPage.dart';
import 'package:project/constants/AppColor_constants.dart';

class GeoFenceMainPage extends StatefulWidget {
  const GeoFenceMainPage({Key? key}) : super(key: key);

  @override
  State<GeoFenceMainPage> createState() => _GeoFenceMainPageState();
}

class _GeoFenceMainPageState extends State<GeoFenceMainPage> {
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
                        child: AdminGeofencing(),
                        type: PageTransitionType.rightToLeft,duration: Duration(seconds: 1)));
                // Implement the action for Set Geofence here.
              },
            ),
          ),
          Expanded(
            child: CardButton(
              text: 'GeoFence Approval',
              image: Image.asset(
                  'assets/icons/geoapproval.png'), // Replace with your image path
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
        ],
      ),
    );
  }
}

class CardButton extends StatelessWidget {
  final String text;
  final Image image;
  final VoidCallback onPressed;

  CardButton(
      {required this.text, required this.image, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(16.0),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 50,
                height: 50,
                child: image,
              ),
              SizedBox(width: 16.0),
              Text(
                text,
                style: GoogleFonts.aboreto(
                    fontSize: 24.0,
                    fontWeight:
                        FontWeight.bold // Adjust the font size as needed
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
