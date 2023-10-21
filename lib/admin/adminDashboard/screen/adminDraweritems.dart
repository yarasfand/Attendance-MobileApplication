import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'admindDrawer.dart';


class AdminDrawerItems{
  static const home = AdminDrawerItem(title: 'Home', icon: FontAwesomeIcons.house);
  static const profile = AdminDrawerItem(title: 'Profile', icon: FontAwesomeIcons.user);
  static const reports = AdminDrawerItem(title: 'Reports', icon: FontAwesomeIcons.clipboard);
  static const geofence = AdminDrawerItem(title: 'Geofence', icon: FontAwesomeIcons.mapLocationDot);
  static const logout = AdminDrawerItem(title: 'Log Out', icon: FontAwesomeIcons.signOut);


  static final List <AdminDrawerItem> all = [
    home,
    profile,
    geofence,
    reports,
    logout,
  ];
}