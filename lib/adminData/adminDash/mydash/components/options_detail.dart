import 'package:flutter/material.dart';
import '../constants/constants.dart';
import 'options_card.dart';

class StorageDetails extends StatelessWidget {
  const StorageDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Options",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          StorageInfoCard(
            svgSrc: "assets/icons/master.png",
            title: "Master",
          ),
          SizedBox(height: 5),
          StorageInfoCard(
            svgSrc: "assets/icons/present.png",
            title: "Mark Attendance",
          ),
          SizedBox(height: 5),
          StorageInfoCard(
            svgSrc: "assets/icons/leave.png",
            title: "Leaves",
          ),
          SizedBox(height: 5),
          StorageInfoCard(
            svgSrc: "assets/icons/report.png",
            title: "Report",
          ),
          SizedBox(height: 5),
          StorageInfoCard(
            svgSrc: "assets/icons/gps.png",
            title: "GPS Tracker",
          ),
          SizedBox(height: 5),
          StorageInfoCard(
            svgSrc: "assets/icons/lock.png",
            title: "Access Control",
          ),
        ],
      ),
    );
  }
}
