import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'admindDrawer.dart';


class DrawerItems{
  static const home = DrawerItem(title: 'Home', icon: FontAwesomeIcons.house);
  static const profile = DrawerItem(title: 'Profile', icon: FontAwesomeIcons.user);
  static const geofence = DrawerItem(title: 'Geofence', icon: FontAwesomeIcons.mapLocationDot);
  static const reports = DrawerItem(title: 'Reports', icon: FontAwesomeIcons.locationArrow);
  static const logout = DrawerItem(title: 'Log Out', icon: FontAwesomeIcons.signOut);


  static final List <DrawerItem> all = [
    home,
    profile,
    geofence,
    reports,
    logout,
  ];
}