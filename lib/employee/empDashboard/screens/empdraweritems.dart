import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'empDrawer.dart';

class EmpDrawerItems{
  static const home = EmpDrawerItem(title: 'Home', icon: FontAwesomeIcons.house);
  static const profile = EmpDrawerItem(title: 'Profile', icon: FontAwesomeIcons.solidUser);
  static const geoPunch = EmpDrawerItem(title: 'Geo Punch', icon: FontAwesomeIcons.mapLocationDot);
  static const reports = EmpDrawerItem(title: 'Reports', icon: FontAwesomeIcons.solidClipboard);
  static const logout = EmpDrawerItem(title: 'Log Out', icon: FontAwesomeIcons.signOut);
  static const leaves = EmpDrawerItem(title: 'Leaves', icon: FontAwesomeIcons.solidCalendar);

  static final List <EmpDrawerItem> all = [
    home,
    profile,
    geoPunch,
    leaves,
    reports,
    logout,
  ];
}