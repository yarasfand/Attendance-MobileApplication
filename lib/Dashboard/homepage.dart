import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/Login%20Page/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Login Page/login_bloc/loginbloc.dart';
// Import your LoginPage

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('Login', false); // Set the login status to false

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Builder(
            builder: (context) => BlocProvider(
              create: (context) => SignInBloc(),
              child: LoginPage(),
            ),
          ); // Navigate back to LoginPage
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context), // Call the logout function
          ),
        ],
      ),
      body: Container(
        color: Colors.grey,
      ),
    );
  }
}
