import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Backend/EmployeeApi/EmployeeRespository/EmployeeUserRepository.dart';
import '../../Controller/AdminBlocInternet/AdminInternetBloc.dart';
import '../../Controller/AdminBlocInternet/AdminInternetState.dart';
import '../../Controller/LoginBloc/LoginBloc.dart';
import '../../Controller/LoginBloc/LoginEvents.dart';
import '../../Controller/LoginBloc/LoginStates.dart';
import '../AdminUi/AdminDashboard/adminMain.dart';
import '../EmployeeUi/EmployeeDashboard/employeeMain.dart';
import 'HalfCircleClipper.dart';

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
  bool _obscureText = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late bool _isButtonPressed = false;
  static const String KEY_LOGIN = "Login";
  final UserRepository userRepository =
      UserRepository(); // Create an instance of UserRepository

  void _handleAdminLogin(
    String enteredCorporateID,
    String enteredUsername,
    String enteredPassword,
  ) async {
    try {
      final employeeData = await userRepository.getData(
        corporateId: enteredCorporateID,
        username: enteredUsername,
        password: enteredPassword,
      );

      if (employeeData.isNotEmpty) {
        _loginAsAdmin();
      } else {
        _showErrorSnackbar(context, "User not found!");
      }
    } catch (e) {
      _showErrorSnackbar(context, "User not found!");
    }
  }

  void _handleEmployeeLogin(
    String enteredCorporateID,
    String enteredUsername,
    String enteredPassword,
  ) async {
    try {
      final employeeData = await userRepository.getData(
        corporateId: enteredCorporateID,
        username: enteredUsername,
        password: enteredPassword,
      );

      if (employeeData.isNotEmpty) {
        _loginAsEmployee();
      } else {
        _showErrorSnackbar(context, "User not found!");
      }
    } catch (e) {
      _showErrorSnackbar(context, "User not found!");
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text(message)),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _successScaffoldMessage(
      BuildContext context, String message) async {
    await ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text(message)),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _loginAsEmployee() async {
    await _successScaffoldMessage(context, "Login Successful");
    await Future.delayed(Duration(seconds: 2));

    Navigator.pushReplacement(
        context,
        PageTransition(
            child: const EmpMainPage(), type: PageTransitionType.rightToLeft));
  }

  void _loginAsAdmin() async {
    await _successScaffoldMessage(context, "Login Successful");
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(
        context,
        PageTransition(
            child: const AdminMainPage(),
            type: PageTransitionType.rightToLeft));
  }

  void _onLoginButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isButtonPressed = true;
      });

      await Future.delayed(const Duration(seconds: 1));
      var sharedPref = await SharedPreferences.getInstance();
      sharedPref.setBool(KEY_LOGIN, true);

      final enteredCorporateID = _CoorporateIdController.text;
      final enteredUsername = _UserController.text;
      final enteredPassword = _passwordController.text;

      // saving corporateId
      final sharedPrefEmp = await SharedPreferences.getInstance();
      sharedPrefEmp.setString('corporate_id', enteredCorporateID);
      sharedPrefEmp.setString('user_name', enteredUsername);
      sharedPrefEmp.setString('password', enteredPassword);

      if (_selectedUserType == UserType.employee) {
        // Execute employee-related functions
        _handleEmployeeLogin(
          enteredCorporateID,
          enteredUsername,
          enteredPassword,
        );
      } else if (_selectedUserType == UserType.admin) {
        // Execute admin-related functions
        _handleAdminLogin(
          enteredCorporateID,
          enteredUsername,
          enteredPassword,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid corporate ID, username, or password.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      setState(() {
        _isButtonPressed = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all required fields.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetBloc, InternetStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is InternetGainedState) {
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
                      color: const Color(0xFFE26142),
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
                                      color: Colors.white,
                                      blurRadius: 4,
                                      offset: Offset(0, 8),
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
                      height: MediaQuery.of(context).orientation ==
                              Orientation.portrait
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
                      child: Form(
                        key: _formKey,
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter Coorporate ID';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _UserController,
                                decoration: InputDecoration(
                                  labelText: 'User Name',
                                  suffixIcon:
                                      Image.asset('assets/icons/profile.png'),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter UserName';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _passwordController,
                                onChanged: (value) {
                                  BlocProvider.of<SignInBloc>(context).add(
                                    SignInTextChangedEvent(
                                      password: _passwordController.text,
                                    ),
                                  );
                                },
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  suffixIcon:
                                      Image.asset('assets/icons/password.png'),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  return null;
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text("Show Password"),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    child: Checkbox(
                                      value: !_obscureText,
                                      onChanged: (value) {
                                        setState(() {
                                          _obscureText = !value!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              ListTile(
                                title: const Text('Employee'),
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
                                title: const Text('Admin'),
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
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              const Color(0xFFE26142)),
                                      elevation: MaterialStateProperty.all(3),
                                      shadowColor: MaterialStateProperty.all(
                                          Colors.grey),
                                    ),
                                    onPressed: () {
                                      _onLoginButtonPressed();
                                    },
                                    child: _isButtonPressed
                                        ? const SizedBox(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                            ),
                                            width: 15.0,
                                            height: 15.0,
                                          )
                                        : const Text(
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
                  ),
                ],
              ),
            ),
          );
        } else if (state is InternetLostState) {
          return Expanded(
            child: Scaffold(
              body: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "No Internet Connection!",
                        style: TextStyle(
                          color: Color(0xFFE26142),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Lottie.asset('assets/no_wifi.json'),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Expanded(
            child: Scaffold(
              body: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "No Internet Connection!",
                        style: TextStyle(
                          color: Color(0xFFE26142),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Lottie.asset('assets/no_wifi.json'),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
