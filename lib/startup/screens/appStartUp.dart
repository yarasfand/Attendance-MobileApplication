import 'package:flutter/material.dart';
import 'package:project/employee/empDashboard/screens/employeeMain.dart';
import 'package:project/admin/adminDashboard/screen/adminMain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../introduction/screens/screen.dart';
import '../../login/screens/loginPage.dart';

class AppStartup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData>(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator
        } else {
          if (snapshot.hasData) {
            final userData = snapshot.data;
            if (userData!.isLoggedIn) {
              if (userData.isEmployee) {
                return const EmpMainPage(); // User is an employee, show the employee page
              } else {
                return const AdminMainPage(); // User is an admin, show the admin page
              }
            } else {
              // Check if the user has visited the login page
              return FutureBuilder<bool>(
                future: hasVisitedLoginPage(),
                builder: (context, loginSnapshot) {
                  if (loginSnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    // Check if the user has visited the login page
                    return FutureBuilder<bool>(
                      future: hasVisitedLoginPage(),
                      builder: (context, loginSnapshot) {
                        if (loginSnapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          final hasVisitedLogin = loginSnapshot.data ?? false;
                          if (!hasVisitedLogin) {
                            // User hasn't visited the login page, show the IntroScreen
                            return const Screen1();
                          } else {
                            // User has visited the login page, do not show the IntroScreen
                            return LoginPage();
                          }
                        }
                      },
                    );
                  }
                },
              );
            }
          }
          // Handle error or no user data scenario
          return const Text("Error or no user data");
        }
      },
    );
  }

  Future<bool> hasVisitedLoginPage() async {
    final sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getBool('intro_screen_visited') ?? false;
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
