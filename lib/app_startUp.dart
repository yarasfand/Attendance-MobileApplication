import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'employeeData/employeeDash/mydrawerbuilding/employeeMain.dart';
import 'introduction_screens/intro_screen.dart';

class AppStartup extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      // Replace with your own logic to check shared preferences
      future: checkIfUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // if waiting for the state to return the loading
        } else {
          if (snapshot.data == true) {
            return MainPage(); // User is logged in, show HomePage
          } else {
            return IntroScreen(); // User is not logged in, show IntroScreen
          }
        }
      },
    );
  }

  Future<dynamic> checkIfUserLoggedIn() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var isLoggedIn = prefs.getBool('Login'); //it is that value that has been set


    return isLoggedIn;
  }
}