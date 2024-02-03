import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/admin/adminOptionsReport/screens/AdminMonthlyAndDailyReportsMainPage.dart';
import 'package:project/constants/AppColor_constants.dart';
import '../../adminReportsFiles/screens/AdminReportsMainPage.dart';
import '../../adminmanualAttendance/screens/ManualMarkAttendance.dart';
import 'adminOptions_card.dart';
import 'adminconstants.dart';

class AdminStorageDetails extends StatelessWidget {
  const AdminStorageDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).size.height > 720
          ? EdgeInsets.all(defaultPadding)
          : EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Quick Access",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: defaultPadding),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManualMarkAttendance(),
                  ));
            },
            child: AdminStorageInfoCard(
              title: 'Manual Punch',
              imageOrIcon: Image.asset('assets/icons/manualPunchAdmin.png'),
            )

          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AdminReportsMainPage(viaDrawer: false),
                  ));
            },
            child:AdminStorageInfoCard(
              title: 'Leave',
              imageOrIcon: Icon(FontAwesomeIcons.solidCalendar),
            ),

          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminMonthlyAndDailyReportsMainPage(
                    viaDrawer: false,
                  ),
                )),
            child: AdminStorageInfoCard(
              title: 'Report',
              imageOrIcon: Icon(FontAwesomeIcons.solidClipboard),
            )

          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
