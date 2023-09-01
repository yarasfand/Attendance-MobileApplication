import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'mydrawer.dart';


class DrawerItems{
  static const home = DrawerItem(title: 'Home', icon: FontAwesomeIcons.house);
  static const profile = DrawerItem(title: 'Profile', icon: FontAwesomeIcons.user);
  static const attendance = DrawerItem(title: 'Attendance', icon: FontAwesomeIcons.calendar);
  static const reports = DrawerItem(title: 'Reports', icon: FontAwesomeIcons.locationArrow);
  static const logout = DrawerItem(title: 'Log Out', icon: FontAwesomeIcons.signOut);


  static final List <DrawerItem> all = [
    home,
    profile,
    attendance,
    reports,
    logout,
  ];
}