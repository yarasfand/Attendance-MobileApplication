import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/constants/AnimatedTextPopUp.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:project/constants/globalObjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Sqlite/admin_sqliteHelper.dart';
import '../../Sqlite/sqlite_helper.dart';
import '../../admin/adminProfile/models/AdminProfileRepository.dart';
import '../../employee/empDashboard/models/empDashModel.dart';
import '../../employee/empDashboard/models/empDashRepository.dart';
import '../../employee/empDashboard/models/emp_attendance_status_model.dart';
import '../../employee/empDashboard/models/emp_attendance_status_repository.dart';
import '../../employee/empDashboard/models/user_repository.dart';
import '../../employee/empProfilePage/models/empProfileModel.dart';
import '../../employee/empProfilePage/models/empProfileRepository.dart';
import '../../introduction/bloc/bloc_internet/internet_bloc.dart';
import '../../introduction/bloc/bloc_internet/internet_state.dart';
import '../bloc/loginBloc/loginEvents.dart';
import '../bloc/loginBloc/loginStates.dart';
import '../bloc/loginBloc/loginbloc.dart';
import 'halfCircleClipper.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

enum UserType { employee, admin }

class LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController addToCartPopUpAnimationController;
  final EmpDashRepository _repository = EmpDashRepository();
  late List<EmpDashModel> empDashData;
  final EmpAttendanceRepository _attendanceRepository =
      EmpAttendanceRepository();
  late EmpAttendanceModel empAttendanceData;
  @override
  void initState() {
    addToCartPopUpAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    saveEmpAllToShared();
    super.initState();
  }

  @override
  void dispose() {
    addToCartPopUpAnimationController.dispose();
    super.dispose();
  }

  UserType? _selectedUserType = UserType.employee;
  final _passwordController = TextEditingController();
  final _CoorporateIdController = TextEditingController();
  final _UserController = TextEditingController();
  bool _obscureText = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late bool _isButtonPressed = false;
  static const String KEY_LOGIN = "Login";
  final UserRepository userRepository = UserRepository();
  String? corporateId;

  void handleAdminLogin(
    String enteredCorporateID,
    String enteredUsername,
    String enteredPassword,
    String enteredRole,
  ) async {
    try {
      final employeeData = await userRepository.getData(
        corporateId: enteredCorporateID,
        username: enteredUsername,
        password: enteredPassword,
        role: enteredRole,
      );

      if (employeeData.isNotEmpty) {
        _saveAdminDataToSharedPreferences(enteredUsername, enteredCorporateID);

        // Set GlobalObjects values
        GlobalObjects.adminusername = enteredUsername;
        GlobalObjects.adminCorpId = enteredCorporateID;

        _loginAsAdmin();
      } else {
        showCustomFailureAlert(context, "User Not Found!");
      }
    } catch (e) {
      showCustomFailureAlert(context, "User Not Found!");
    }
  }

  void _saveAdminDataToSharedPreferences(
      String username, String corporateId) async {
    final sharedPref = await SharedPreferences.getInstance();
    GlobalObjects.adminusername = username;
    GlobalObjects.adminCorpId = corporateId;
    sharedPref.setString('admin_username', username);
    sharedPref.setString('admin_corporateId', corporateId);
  }

  void _handleEmployeeLogin(
    String enteredCorporateID,
    String enteredUsername,
    String enteredPassword,
    String enteredRole,
  ) async {
    try {
      final employeeData = await userRepository.getData(
        corporateId: enteredCorporateID,
        username: enteredUsername,
        password: enteredPassword,
        role: enteredRole,
      );

      if (employeeData.isNotEmpty) {
        final cardNo = employeeData[0].cardNo;
        final empCode = employeeData[0].empCode;
        final employeeId = employeeData[0].empId;
        await saveEmployeeToDatabase(
            employeeId, enteredUsername, enteredCorporateID);

        _saveCardNoToSharedPreferences(cardNo, empCode, employeeId);
        _loginAsEmployee();
      } else {
        showCustomFailureAlert(context, "User Not Found!");
      }
    } catch (e) {
      showCustomFailureAlert(context, "User Not Found!");
    }
  }

  String? savedEmpCode;

  Future<void> fetchProfileData() async {
    try {
      final dbHelper = EmployeeDatabaseHelper.instance;
      int loggedInEmployeeId = await dbHelper.getLoggedInEmployeeId();

      // Dash
      empDashData = await _repository.getData();
      empAttendanceData = await _attendanceRepository.getData();

      // Insert data into employeeHomePageData table
      await dbHelper.insertEmployeeHomePageData(
        inTime: empAttendanceData.in1?.toString() ?? '',
        outTime: empAttendanceData.out2?.toString() ?? '',
        status: empAttendanceData.status ?? '',
        present: empDashData[0].presentCount.toString(),
        absent: empDashData[0].absentCount.toString(),
        leaves: empDashData[0].leaveCount.toString(),
      );
      if (loggedInEmployeeId > 0) {
        final profileRepository = EmpProfileRepository();
        final profileData = await profileRepository.getData();

        if (profileData.isNotEmpty) {
          EmpProfileModel? empProfile = profileData.first;
          final profileImage = empProfile.profilePic;

          // Insert or replace into employeeProfileData table
          await dbHelper.insertProfileData(
            empCode: empProfile.empCode,
            profilePic: profileImage,
            empName: empProfile.empName,
            emailAddress: empProfile.emailAddress,
          );

          // Insert or replace into profileTable
          await dbHelper.insertProfilePageData(
            empCode: empProfile.empCode,
            profilePic: profileImage,
            empName: empProfile.empName,
            emailAddress: empProfile.emailAddress,
            joinDate: empProfile.dateofJoin.toIso8601String() ?? '',
            phoneNumber: empProfile.phoneNo ?? '',
            password: empProfile.password ?? '',
            fatherName: empProfile.fatherName ?? '',
          );

          // Update global objects and UI state
          GlobalObjects.empCode = empProfile.empCode;
          GlobalObjects.empProfilePic = profileImage;
          GlobalObjects.empName = empProfile.empName;
          GlobalObjects.empMail = empProfile.emailAddress;
          GlobalObjects.empFatherName = empProfile.fatherName;
          GlobalObjects.empPassword = empProfile.password;
          GlobalObjects.empJoinDate = empProfile.dateofJoin;
          GlobalObjects.empPhone = empProfile.phoneNo;
          GlobalObjects.empIn1 = empAttendanceData.in1;
          GlobalObjects.empOut2 = empAttendanceData.out2;
          GlobalObjects.empStatus = empAttendanceData.status?.toString() ?? '';
          GlobalObjects.empPresent =
              empDashData[0].presentCount.toString() ?? '';
          GlobalObjects.empAbsent = empDashData[0].absentCount.toString() ?? '';
          GlobalObjects.empLeaves = empDashData[0].leaveCount.toString() ?? '';
          setState(() {
            savedEmpCode = empProfile.empCode;
            profileImageUrl = profileImage;
            GlobalObjects.empCode = empProfile.empCode;
            GlobalObjects.empProfilePic = profileImage;
            GlobalObjects.empName = empProfile.empName;
            GlobalObjects.empMail = empProfile.emailAddress;
            GlobalObjects.empFatherName = empProfile.fatherName;
            GlobalObjects.empPassword = empProfile.password;
            GlobalObjects.empJoinDate = empProfile.dateofJoin;
            GlobalObjects.empPhone = empProfile.phoneNo;
            GlobalObjects.empIn1 = empAttendanceData.in1;
            GlobalObjects.empOut2 = empAttendanceData.out2;
            GlobalObjects.empStatus =
                empAttendanceData.status?.toString() ?? '';
            GlobalObjects.empPresent =
                empDashData[0].presentCount.toString() ?? '';
            GlobalObjects.empAbsent =
                empDashData[0].absentCount.toString() ?? '';
            GlobalObjects.empLeaves =
                empDashData[0].leaveCount.toString() ?? '';
          });
        }

        // Print profile data for debugging
        await dbHelper.printProfileData();
      }
    } catch (e) {
      print("Error fetching and saving profile data: $e");
    } finally {
      setState(() {});
    }
  }

  Future<void> saveEmployeeToDatabase(
      int employeeId, String username, String corporateId) async {
    try {
      final dbHelper = EmployeeDatabaseHelper();
      await dbHelper.insertEmployee(employeeId, corporateId);

      final List<Map<String, dynamic>> savedData =
          await dbHelper.getEmployees();

      if (savedData.isNotEmpty) {
        fetchProfileData();
        print("Data saved successfully!");
        print(savedData);
      } else {
        print("Failed to save data!");
      }
    } catch (e) {
      print("Error saving employee data to SQLite: $e");
    }
  }

  void _loginAsEmployee() async {
    showCustomSuccessAlertEmployee(context, "Login Successful!");
    await fetchProfileData();
  }

  String? profileImageUrl;
  Future<void> saveEmpAllToShared() async {
    try {
      final repository = AdminProfileRepository();
      final employeeData = await repository
          .fetchAdminProfile(GlobalObjects.adminCorpId.toString());

      if (employeeData != null) {
        final sharedPrefEmp = await SharedPreferences.getInstance();

        setState(() {
          sharedPrefEmp.setString('empName', employeeData.userName);
          sharedPrefEmp.setString('empMail', employeeData.email);
          GlobalObjects.adminusername = employeeData.userName;
          GlobalObjects.adminMail = employeeData.email;
        });
      }
    } catch (e) {
      print("Error fetching profile data: $e");
    }
  }

  void _saveCardNoToSharedPreferences(
      String cardNo, String empCode, int employeeId) async {
    final sharedPrefEmp = await SharedPreferences.getInstance();
    sharedPrefEmp.setString('cardNo', cardNo);
    sharedPrefEmp.setString('empCode', empCode);
    sharedPrefEmp.setInt('employee_id', employeeId);
    GlobalObjects.empCode = empCode;
    GlobalObjects.empId = employeeId;
  }

  void _loginAsAdmin() async {
    print("Start _loginAsAdmin");

    // Extract the admin's data
    String? username = GlobalObjects.adminusername;
    String? corporateId = GlobalObjects.adminCorpId;

    print("Username: $username, Corporate ID: $corporateId");

    // Check for null values
    if (username != null && corporateId != null) {
      try {
        await saveAdminToDatabase(username, corporateId);
        showCustomSuccessAlertAdmin(context, "Login Successful!");
        print("Admin data saved successfully!");
      } catch (e) {
        print("Error saving admin data to SQLite: $e");
        // Handle the error gracefully, e.g., show an error message to the user
      }
    } else {
      print("Error: Admin data is null.");
    }

    print("End _loginAsAdmin");
  }

  Future<void> saveAdminToDatabase(String username, String corporateId) async {
    try {
      if (username != null && corporateId != null) {
        final adminDbHelper = AdminDatabaseHelper();
        await adminDbHelper
            .insertAdmin({'username': username, 'corporate_id': corporateId});
        print("Admin data saved successfully!");
      } else {
        print("Error: Received null values for username or corporateId.");
      }
    } catch (e) {
      // Rethrow the exception to let the calling function handle it
      throw Exception("Error saving admin data to SQLite: $e");
    }
  }

  void showPopupWithMessageFailed(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addToCartPopUpFailed(addToCartPopUpAnimationController, message);
      },
    );
  }

  void showPopupWithMessageSuccess(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addToCartPopUpSuccess(
            addToCartPopUpAnimationController, message);
      },
    );
  }

  void showPopupWithMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addToCartPopUpNoCrossMessage(
            addToCartPopUpAnimationController, message);
      },
    );
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
      String enteredRole = '';

      // Set the role based on the selected user type
      if (_selectedUserType == UserType.employee) {
        enteredRole = 'employee';
      } else if (_selectedUserType == UserType.admin) {
        enteredRole = 'admin';
      }
      sharedPref.setString('role', enteredRole);
      // saving corporateId
      final sharedPrefEmp = await SharedPreferences.getInstance();
      sharedPrefEmp.setString('corporate_id', enteredCorporateID);
      sharedPrefEmp.setString('user_name', enteredUsername);
      sharedPrefEmp.setString('password', enteredPassword);

      if (_selectedUserType == UserType.employee) {
        corporateId = _CoorporateIdController.text;
        _handleEmployeeLogin(
          corporateId!,
          enteredUsername,
          enteredPassword,
          enteredRole,
        );
        var sharedPref = await SharedPreferences.getInstance();
        sharedPref.setBool('isLoggedIn', true);
        sharedPref.setBool('isEmployee', true);
      } else if (_selectedUserType == UserType.admin) {
        corporateId = _CoorporateIdController.text;

        GlobalObjects.adminCorpId = corporateId;
        handleAdminLogin(
          corporateId!,
          enteredUsername,
          enteredPassword,
          enteredRole,
        );
        var sharedPref = await SharedPreferences.getInstance();
        sharedPref.setBool('isLoggedIn', true);
        sharedPref.setBool('isEmployee', false);
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
      showCustomWarningAlert(context, "Please fill out all required fields");
    }
  }

  bool isInternetLost = false;

  double getSize() {
    double containerHeight = MediaQuery.of(context).size.height;

    if(containerHeight > 930)
      {
        return 0.78;
      }
    else if (containerHeight > 900) {
      return 0.7;
    }
    else if (containerHeight > 720) {
      return 0.7;
    } else if (containerHeight > 600) {
      return 0.68;
    } else {
      return 0.65;
    }
  }


  @override
  Widget build(BuildContext context) {


    print(MediaQuery.of(context).size.height);
    return BlocConsumer<InternetBloc, InternetStates>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is InternetGainedState) {
          // Check if internet was previously lost
          if (isInternetLost) {
            // Navigate back to the original page when internet is regained
            Navigator.pop(context);
          }
          isInternetLost = false; // Reset the flag
        }
      },
      builder: (context, state) {
        if (state is InternetGainedState) {
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 250,
                    child: Image.asset(
                      'assets/images/background.jpeg',
                      fit: BoxFit.fill, // Cover the entire screen
                      width: double
                          .infinity, // Make sure the image covers the entire width
                      height: double
                          .infinity, // Make sure the image covers the entire height
                    ),
                  ),
                  Container(
                    color: AppColors.primaryColor.withOpacity(0.7),
                  ),
                  Positioned(
                    top: 90,
                    left: MediaQuery.of(context).size.width * 0.5 - 150, // Adjust 120 according to your text width
                    child: Text(
                      'Pioneer Time System',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.5), // Shadow color with opacity
                            offset: Offset(2, 2), // Shadow offset
                            blurRadius: 5, // Blur radius
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 2),
                      height: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? MediaQuery.of(context).size.height * getSize()
                          : MediaQuery.of(context).size.width * 0.55,
                      width: double.infinity,
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Welcome",
                                      style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 32,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "Please login with your information",
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              TextFormField(
                                controller: _CoorporateIdController,
                                decoration: InputDecoration(
                                    labelText: 'Company Id',
                                    labelStyle: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                    suffixIcon:
                                        Icon(FontAwesomeIcons.fileLines)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter Company ID';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _UserController,
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  labelStyle: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                  suffixIcon: Icon(FontAwesomeIcons.pen),
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
                                  labelStyle: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                  suffixIcon: Icon(FontAwesomeIcons.lock),
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
                              Column(
                                children: [
                                  ChoiceChip(
                                    backgroundColor: AppColors.lightGray,
                                    selectedColor: AppColors.secondaryColor,
                                    elevation: 5,
                                    label: Container(
                                      width: 100, // Adjust the width as needed
                                      child: Center(
                                        child: _selectedUserType ==
                                                UserType.employee
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.account_circle,
                                                      color: Colors.white),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  const Text(
                                                    'Employee',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.account_circle,
                                                      color: Colors.white),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  const Text(
                                                    'Employee',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                    selected:
                                        _selectedUserType == UserType.employee,
                                    onSelected: (selected) {
                                      setState(() {
                                        _selectedUserType =
                                            selected ? UserType.employee : null;
                                      });
                                    },
                                    shape: StadiumBorder(), // Make it rounded
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    side: BorderSide.none, // Remove the border
                                  ),

                                  const SizedBox(
                                      height: 10), // Add some spacing
                                  ChoiceChip(
                                    backgroundColor: AppColors.lightGray,
                                    selectedColor: AppColors.secondaryColor,
                                    elevation: 5,
                                    label: Container(
                                      width: 100, // Adjust the width as needed
                                      child: Center(
                                        child: _selectedUserType ==
                                                UserType.admin
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.account_circle,
                                                      color: Colors.white),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  const Text(
                                                    'Admin',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.account_circle,
                                                      color: Colors.white),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  const Text(
                                                    'Admin',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                    selected:
                                        _selectedUserType == UserType.admin,
                                    onSelected: (selected) {
                                      setState(() {
                                        _selectedUserType =
                                            selected ? UserType.admin : null;
                                      });
                                    },
                                    shape: StadiumBorder(), // Make it rounded
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    side: BorderSide.none, // Remove the border
                                  )
                                ],
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
                                              AppColors.primaryColor),
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
                                              color: Colors.white,
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
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height >700? 100: 20,),
                              Text("All Rights Reserved | Powered by PTS",style: TextStyle(color: Colors.grey),),
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
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
