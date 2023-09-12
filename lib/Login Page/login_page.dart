import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/adminData/adminDash/mydrawerbuilding/adminMain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../employeeData/employeeDash/mydrawerbuilding/employeeMain.dart';
import 'half_circle_clipper.dart';
import 'login_bloc/loginEvents.dart';
import 'login_bloc/loginStates.dart';
import 'login_bloc/loginbloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum UserType { employee, admin }

class _LoginPageState extends State<LoginPage> {
  UserType? _selectedUserType = UserType.employee; // Default selection

  final _passwordController = TextEditingController();
  final _CoorporateIdController = TextEditingController();
  final _UserController = TextEditingController();
  bool _obsecureText = true;
  late bool _isButtonPressed = false;
  static const String KEY_LOGIN = "Login";

  Future<void> saveUserData(
      String corporateID, String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('corporateID', corporateID);
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  Future<void> _onLoginButtonPressed() async {
    setState(() {
      _isButtonPressed = true;
    });
    // Simulate some delay for demonstration purposes
    await Future.delayed(const Duration(seconds: 1));
    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(KEY_LOGIN, true); // User is logged in now

    if(_selectedUserType == UserType.employee){
      saveUserData(
        _CoorporateIdController.text,
        _UserController.text,
        _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        PageTransition(
          child:  MainPage(),
          duration: const Duration(seconds: 1),
          type: PageTransitionType.fade,
        ),
      );
    }
    else if(_selectedUserType == UserType.admin){
      saveUserData(
        _CoorporateIdController.text,
        _UserController.text,
        _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        PageTransition(
          child:  AdminMainPage(),
          duration: const Duration(seconds: 1),
          type: PageTransitionType.fade,
        ),
      );
    }
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
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(seconds: 2),
                margin: const EdgeInsets.all(20),
                height:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.height * 0.65
                    : MediaQuery.of(context).size.width * 0.55,
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
                            return Text(
                              state.message,
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  letterSpacing: 0,
                                  fontSize: 15,
                                  color: Colors.red,
                                ),
                              ),
                            );
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
                        controller: _CoorporateIdController,
                        decoration: InputDecoration(
                          labelText: 'Coorporate ID',
                          suffixIcon: Image.asset(
                            'assets/icons/username.png',
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _UserController,
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
                      ListTile(
                        title: Text('Employee'),
                        leading: Radio<UserType>(
                          value: UserType.employee,
                          groupValue: _selectedUserType,
                          onChanged: (UserType? value) {
                            setState(() {
                              _selectedUserType = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text('Admin'),
                        leading: Radio<UserType>(
                          value: UserType.admin,
                          groupValue: _selectedUserType,
                          onChanged: (UserType? value) {
                            setState(() {
                              _selectedUserType = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<SignInBloc, SignInState>(
                        builder: (BuildContext context, state) {
                          return ElevatedButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(
                                const Size(250, 50),
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              backgroundColor: (state is SigninValidState)
                                  ? MaterialStateProperty.all(Colors.orange)
                                  : MaterialStateProperty.all(Colors.grey),
                              elevation: MaterialStateProperty.all(3),
                              shadowColor:
                              MaterialStateProperty.all(Colors.grey),
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


