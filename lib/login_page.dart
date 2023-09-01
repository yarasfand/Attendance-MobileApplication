import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/login_bloc/loginEvents.dart';
import 'package:project/login_bloc/loginStates.dart';
import 'package:project/login_bloc/loginbloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Dashboard/homepage.dart';
import 'Dashboard/mydrawerbuilding/mainpageintegeration.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _passwordController = TextEditingController();

  bool _obsecureText = true;
  static const String KEY_LOGIN = "Login";

  late bool _isButtonPressed = false;

  Future<void> _onLoginButtonPressed() async {
    setState(() {
      _isButtonPressed = true;
    });

    // Simulate some delay for demonstration purposes
    await Future.delayed(const Duration(seconds: 1));

    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(KEY_LOGIN, true); // User is logged in now

    Navigator.pushReplacement(
      context,
      PageTransition(
          child: const MainPage(),
          duration: const Duration(seconds: 1),
          type: PageTransitionType.fade),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ClipPath(
              clipper: HalfCircleClipper(),
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.orange,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white, // Shadow color
                                  blurRadius: 4, // Spread of the shadow
                                  offset: Offset(0, 8), // Offset from the card
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/pioneer_logo_app1.png',
                              fit: BoxFit.cover,
                              height: 150,
                              width: 300,
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(seconds: 2),
                margin: const EdgeInsets.all(20),
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.height * 0.65
                        : MediaQuery.of(context).size.width *
                            0.55, // Adjust the dimensions as needed
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, -2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      BlocBuilder<SignInBloc, SignInState>(
                        builder: (BuildContext context, state) {
                          if (state is SignInNotValidState) {
                            return Text(state.message,
                                style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                  letterSpacing: 0,
                                  fontSize: 15,
                                  color: Colors.red,
                                )));
                          } else {
                            return Container();
                          }
                        },
                      ),
                      Text(
                        "LOG IN",
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Coorporate ID',
                          suffixIcon: Image.asset(
                            'assets/icons/username.png',
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'User Name',
                          suffixIcon: Image.asset('assets/icons/profile.png'),
                        ),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        onChanged: (value) {
                          BlocProvider.of<SignInBloc>(context).add(
                              SignInTextChangedEvent(
                                  password: _passwordController.text));
                        },
                        obscureText: _obsecureText,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: Image.asset('assets/icons/password.png'),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text("Show Password"),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _obsecureText = !_obsecureText;
                              });
                            },
                            child: Checkbox(
                              value: !_obsecureText,
                              onChanged: (value) {
                                setState(() {
                                  _obsecureText = !value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<SignInBloc, SignInState>(
                        builder: (BuildContext context, state) {
                          return ElevatedButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(
                                  const Size(250, 50)), // Set your desired size
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              backgroundColor: (state is SigninValidState)
                                  ? MaterialStateProperty.all(Colors.orange)
                                  : MaterialStateProperty.all(Colors
                                      .grey), // Set your desired background color
                              elevation:
                                  MaterialStateProperty.all(3), // Set elevation
                              shadowColor: MaterialStateProperty.all(
                                  Colors.grey), // Set shadow color
                            ),
                            onPressed: () {
                              _onLoginButtonPressed();
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.5);
    path.quadraticBezierTo(
        size.width * 0.5, size.height, size.width, size.height * 0.5);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
