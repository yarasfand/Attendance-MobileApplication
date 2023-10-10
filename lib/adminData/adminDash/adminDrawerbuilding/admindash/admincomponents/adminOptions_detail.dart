import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/adminData/adminDash/AdminOptions_seprateFiles/ManualAttendance_files/ManualMarkAttendance.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Options",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: defaultPadding),
          const AdminStorageInfoCard(
            svgSrc: "assets/icons/master.png",
            title: "Master",
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) {
                    return  ManualMarkAttendance();
                  },
                ),
              );
            },
            child: const AdminStorageInfoCard(
              svgSrc: "assets/icons/present.png",
              title: "Mark Attendance",
            ),
          ),
          const SizedBox(height: 5),
          const AdminStorageInfoCard(
            svgSrc: "assets/icons/leave.png",
            title: "Leaves",
          ),
          const SizedBox(height: 5),
          const AdminStorageInfoCard(
            svgSrc: "assets/icons/report.png",
            title: "Report",
          ),
          const SizedBox(height: 5),
          const AdminStorageInfoCard(
            svgSrc: "assets/icons/gps.png",
            title: "GPS Tracker",
          ),
          const SizedBox(height: 5),
          const AdminStorageInfoCard(
            svgSrc: "assets/icons/lock.png",
            title: "Access Control",
          ),
        ],
      ),
    );
  }
}
