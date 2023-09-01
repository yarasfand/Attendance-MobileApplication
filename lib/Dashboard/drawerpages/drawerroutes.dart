import 'package:flutter/material.dart';
import 'package:project/Dashboard/drawerpages/profile.dart';
import 'package:project/Dashboard/drawerpages/report.dart';
import 'package:project/Dashboard/homepage.dart';
import 'package:project/profile_page/profilepage.dart';
import '../mydrawerbuilding/mainpageintegeration.dart';
import 'attendance.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/dashboard': (context) => MainPage(),
  '/attendance': (context) => attendance(),
  '/report': (context) => reports(),
  '/profile': (context) => ProfilePage(),
  '/logout': (context) => HomePage(),
};