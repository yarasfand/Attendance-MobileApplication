import 'package:flutter/material.dart';
import '../adminConstants/adminconstants.dart';
import 'adminOptions_card.dart';

class AdminStorageDetails extends StatelessWidget {
  const AdminStorageDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: Color(0xFFE26142),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Options",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          AdminStorageInfoCard(
            svgSrc: "assets/icons/master.png",
            title: "Master",
          ),
          SizedBox(height: 5),
          AdminStorageInfoCard(
            svgSrc: "assets/icons/present.png",
            title: "Mark Attendance",
          ),
          SizedBox(height: 5),
          AdminStorageInfoCard(
            svgSrc: "assets/icons/leave.png",
            title: "Leaves",
          ),
          SizedBox(height: 5),
          AdminStorageInfoCard(
            svgSrc: "assets/icons/report.png",
            title: "Report",
          ),
          SizedBox(height: 5),
          AdminStorageInfoCard(
            svgSrc: "assets/icons/gps.png",
            title: "GPS Tracker",
          ),
          SizedBox(height: 5),
          AdminStorageInfoCard(
            svgSrc: "assets/icons/lock.png",
            title: "Access Control",
          ),
        ],
      ),
    );
  }
}
