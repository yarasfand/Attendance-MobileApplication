import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/constants/AppColor_constants.dart';

import '../../../constants/AppBar_constant.dart';

class AdminAppBar extends StatefulWidget {
  final String pageHeading;

  const AdminAppBar({
    Key? key,
    required this.pageHeading,
  }) : super(key: key);

  @override
  State<AdminAppBar> createState() => _AdminAppBarState();
}

class _AdminAppBarState extends State<AdminAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: FaIcon(FontAwesomeIcons.bars),
        color: Colors.white,
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      title: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 55.0), // Add right padding
          child: Text(
            widget.pageHeading, // Access pageHeading from the widget
            style:  AppBarStyles.appBarTextStyle,
          ),
        ),
      ),
    );
  }
}
