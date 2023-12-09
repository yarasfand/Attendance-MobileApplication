import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/employee/empDashboard/screens/empHomePage.dart';
import '../../../constants/AppBar_constant.dart';
import '../../../constants/AppColor_constants.dart';

class GenAppBar extends StatelessWidget {
  final Key? key;
  final String pageHeading;

  const GenAppBar({
    this.key,
    required this.pageHeading,
  }) : super(key: key);

  void onRefresh()
  {
    print("On refresh called");
    HomePageState().fetchProfileData();
  }
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const FaIcon(FontAwesomeIcons.bars),
        color: Colors.white,
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      title: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 55.0),
          child: Text(
            pageHeading,
            style: AppBarStyles.appBarTextStyle,
          ),
        ),
      ),
    );
  }
}
