import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/employee/empDashboard/screens/employeeMain.dart';
import 'package:project/admin/adminDashboard/screen/adminMain.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../introduction/screens/introScreen.dart';

class AppStartup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData>(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator
        } else {
          if (snapshot.hasData) {
            final userData = snapshot.data;
            if (userData!.isLoggedIn) {
              if (userData.isEmployee) {
                return EmpMainPage(); // User is an employee, show the employee page
              } else {
                return AdminMainPage(); // User is an admin, show the admin page
              }
            } else {
              return IntroScreen(); // User is not logged in, show the intro screen
            }
          }
          // Handle error or no user data scenario
          return Text("Error or no user data");
        }
      },
    );
  }

  Future<UserData> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false; // Use the correct key
    final isEmployee = prefs.getBool('isEmployee') ?? false; // Use the correct key

    return UserData(isLoggedIn, isEmployee);
  }
}

class UserData {
  final bool isLoggedIn;
  final bool isEmployee;

  UserData(this.isLoggedIn, this.isEmployee);
}
