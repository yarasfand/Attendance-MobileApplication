import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:project/constants/globalObjects.dart';
import 'package:project/employee/empDashboard/screens/generalAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../introduction/bloc/bloc_internet/internet_bloc.dart';
import '../../../introduction/bloc/bloc_internet/internet_state.dart';
import '../../empMap/screens/employeemap.dart';
import '../../empProfilePage/models/empProfileModel.dart';
import '../../empProfilePage/models/empProfileRepository.dart';
import '../../empProfilePage/screens/profilepage.dart';
import '../../empReportsOnDash/screens/ReportsMainPage.dart';
import '../../empReportsOnDash/screens/leaveReportMainPage.dart';
import '../bloc/empDashApiFiles/emp_dash_bloc.dart';
import '../models/empDashModel.dart';
import '../models/empDashRepository.dart';
import '../models/emp_attendance_status_model.dart';
import '../models/emp_attendance_status_repository.dart';
import '../models/emp_attendane_dash_api_files/emp_attendance_bloc.dart';

class EmpDashHome extends StatefulWidget {
  const EmpDashHome({Key? key}) : super(key: key);

  @override
  State<EmpDashHome> createState() => HomePageState();
}

class HomePageState extends State<EmpDashHome> {
  String? savedCorporateID;
  String? savedEmpCode;
  late bool locationError = true;
  double? lat;
  double? long;
  var initProfile = EmpProfilePageState();

  @override
  void initState() {
    print("init in emp home called");

    super.initState();
    checkLocationPermission();
    checkLocationPermissionAndFetchLocation();
    _retrieveCorporateID();
    fetchProfileData();
  }

  EmpProfileRepository _profileRepository = EmpProfileRepository();
  String? profileImageUrl;

  Future<void> fetchProfileData() async {
    try {

      final profileData = await _profileRepository.getData();
      if (profileData.isNotEmpty) {
        EmpProfileModel? empProfile = profileData.first;
        final profileImage = empProfile.profilePic;

        if (profileImage != null && profileImage.isNotEmpty) {
          setState(() {
            EmpProfileModel? empProfile = profileData.first;
            profileImageUrl = profileImage;
            GlobalObjects.empProfilePic = empProfile.profilePic;
            GlobalObjects.empName = empProfile.empName;
            GlobalObjects.empMail = empProfile.emailAddress;
            print(GlobalObjects.empProfilePic);
          });
        }
        if (profileImage == null) {
          setState(() {
            GlobalObjects.empProfilePic = null;
          });
        }

      }
    } catch (e) {
      print("Error fetching profile data: $e");
    }
  }

  Future<bool?> _onBackPressed(BuildContext context) async {
    bool? exitConfirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Exit'),
        content: Text('Are you sure you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );

    if (exitConfirmed == true) {
      exitApp();
      return true;
    } else {
      return false;
    }
  }

  void exitApp() {
    SystemNavigator.pop();
  }

  Widget buildProfileImage() {
    if (GlobalObjects.empProfilePic != null && GlobalObjects.empProfilePic!.isNotEmpty) {
      return ClipOval(
        child: Image.memory(
          Uint8List.fromList(base64Decode(GlobalObjects.empProfilePic!)),
          width: 100,
          height: 45,
        ),
      );
    } else if (GlobalObjects.empProfilePic == null) {
      return Image.asset(
        'assets/icons/userrr.png',
        width: 100,
        height: 45,
      );
    } else {
      return Image.asset(
        'assets/icons/userrr.png',
        width: 100,
        height: 45,
      );
    }
  }

  Future<void> _retrieveCorporateID() async {
    final sharedPref = await SharedPreferences.getInstance();
    savedCorporateID = sharedPref.getString('corporate_id');
    savedEmpCode = sharedPref.getString('empCode');
    setState(() {});
  }

  Future<void> checkLocationPermission() async {
    Geolocator.getServiceStatusStream().listen((status) {
      if (status == ServiceStatus.enabled) {
        setState(() {
          locationError = false;
        });
      } else {
        setState(() {
          locationError = true;
        });
      }
    });
  }

  Future<void> checkLocationPermissionAndFetchLocation() async {
    final permission = await Geolocator.checkPermission();
    final serviceStatus = await Geolocator.isLocationServiceEnabled();

    if (permission != LocationPermission.denied || serviceStatus) {
      try {
        setState(() {
          locationError = false;
        });
      } catch (e) {
        print('Error getting location: $e');
        setState(() {
          locationError = true;
        });
      }
    } else {
      locationError = true;
    }
  }

  void onTapMaps() {
    if (locationError) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Turn On Location'),
            content:
                const Text('Please turn on your location to use this feature.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmployeeMap(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double lowerButtonsHorizontal;
    double lowerButtonsVertical;

    if (screenWidth <= 360) {
      lowerButtonsHorizontal = 10;
      lowerButtonsVertical = 5;
    } else {
      lowerButtonsHorizontal = 10;
      lowerButtonsVertical = 35;
    }

    //FIRST APPROACH
    return BlocProvider(
      create: (context) {
        return EmpAttendanceBloc(
          RepositoryProvider.of<EmpAttendanceRepository>(context),
        )..add(EmpAttendanceLoadingEvent());
      },
      child: BlocConsumer<InternetBloc, InternetStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is InternetGainedState) {
            return BlocProvider(
              create: (context) {
                return EmpDashBloc(EmpDashRepository())
                  ..add(EmpDashLoadingEvent());
              },
              child: BlocBuilder<EmpDashBloc, EmpDashState>(
                builder: (context, empDashState) {
                  if (empDashState is EmpDashLoadedState) {
                    // Handle the loaded state here
                    List<EmpDashModel> userList = empDashState.users;
                    final employee = userList[0];

                    return BlocBuilder<EmpAttendanceBloc, EmpAttendanceState>(
                      builder: (context, state) {
                        if (state is EmpAttendanceLoadedState) {
                          List<EmpAttendanceModel> userList = state.users;
                          final employeeAttendance = userList[0];
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                //ASK WETHER TO EXIT APP OR NOT
                                WillPopScope(
                                  onWillPop: () async {
                                    return _onBackPressed(context)
                                        .then((value) => value ?? false);
                                  },
                                  child: const SizedBox(),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: screenHeight / 80),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GridView.count(
                                        shrinkWrap: true,
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 70,
                                        mainAxisSpacing: 20,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: ClipOval(
                                              child: buildProfileImage(),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: onTapMaps,
                                            child: ItemDashboard(
                                              showShadow: false,
                                              title: 'Mark Attendance',
                                              customIcon: Image.asset(
                                                "assets/icons/locate.png",
                                                width: 100,
                                                height: 45,
                                              ),
                                              background:
                                                  AppColors.secondaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 75,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      ProfileInfoCard(
                                        firstText: "IN",
                                        secondText: employeeAttendance.in1 !=
                                                null
                                            ? DateFormat('HH:mm:ss')
                                                .format(employeeAttendance.in1!)
                                            : "---",
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      ProfileInfoCard(
                                          firstText: "Status",
                                          secondText:
                                              employeeAttendance.status ??
                                                  "---"),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      ProfileInfoCard(
                                        firstText: "OUT",
                                        secondText:
                                            employeeAttendance.out2 != null
                                                ? DateFormat('HH:mm:ss').format(
                                                    employeeAttendance.out2!)
                                                : "---",
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'ID ${savedEmpCode ?? ''}',
                                  style: const TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Table(
                                  children: [
                                    TableRow(
                                      children: [
                                        ProfileInfoBigCard(
                                          firstText:
                                              employee.presentCount.toString(),
                                          secondText: "Total Present",
                                          icon: Image.asset(
                                            "assets/icons/Attend.png",
                                            width: screenWidth / 15,
                                          ),
                                        ),
                                        ProfileInfoBigCard(
                                          firstText:
                                              employee.absentCount.toString(),
                                          secondText: "Total Absent",
                                          icon: Image.asset(
                                            "assets/icons/absence.png",
                                            width: 28,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Table(
                                  children: [
                                    TableRow(
                                      children: [
                                        ProfileInfoBigCard(
                                          firstText:
                                              employee.leaveCount.toString(),
                                          secondText: "Total Leaves",
                                          icon: Image.asset(
                                            "assets/icons/leave.png",
                                            width: 28,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  width: screenWidth,
                                  padding: EdgeInsets.symmetric(
                                      vertical: lowerButtonsVertical,
                                      horizontal: lowerButtonsHorizontal),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GridView.count(
                                        shrinkWrap: true,
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 50,
                                        mainAxisSpacing: 20,
                                        children: [
                                          GestureDetector(
                                            child: ItemDashboard(
                                              showShadow: false,
                                              title: 'Leave Request',
                                              customIcon: Image.asset(
                                                "assets/icons/leave.png",
                                                width: 100,
                                                height: 45,
                                              ),
                                              background:
                                                  AppColors.secondaryColor,
                                            ),
                                            onTap: () {
                                              Navigator.push(context,
                                                  CupertinoPageRoute(
                                                builder: (context) {
                                                  // return LeaveRequestForm();
                                                  return LeaveRequestPage(viaDrawer: false,);
                                                },
                                              ));
                                            },
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      child: ReportsMainPage(
                                                        viaDrawer: false,
                                                      ),
                                                      type: PageTransitionType
                                                          .rightToLeft)
                                              );
                                            },
                                            child: ItemDashboard(
                                              showShadow: false,
                                              title: 'Reports',
                                              customIcon: Image.asset(
                                                "assets/icons/report.png",
                                                width: 50,
                                                height: 45,
                                              ),
                                              background:
                                                  AppColors.secondaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          );
                        } else if (state is EmpAttendanceLoadingState) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is EmpAttendanceErrorState) {
                          return Text("Error: ${state.message}");
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    );
                  } else if (empDashState is EmpDashErrorState) {
                    // Handle the error state here
                    return Text("Error: ${empDashState.message}");
                  } else {
                    // Handle other states or return a loading indicator
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            );
          } else if (state is InternetLostState) {
            return Expanded(
              child: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "No Internet Connection!",
                        style: TextStyle(
                          color: Colors.red,
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
                            color: Colors.red,
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
      ),
    );
  }
}

// ... The rest of code for ItemDashboard, ProfileInfoCard, TwoLineItem, ProfileInfoBigCard.
class ItemDashboard extends StatelessWidget {
  final String title;
  final Widget customIcon;
  final Color background;
  final bool showShadow;

  const ItemDashboard({
    Key? key,
    required this.title,
    required this.customIcon,
    required this.background,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double fontSize = constraints.maxWidth * 0.075;

        return Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(10),
            boxShadow: showShadow
                ? [
                    BoxShadow(
                      offset: const Offset(4, 10),
                      color: background.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.secondaryColor,
                  shape: BoxShape.circle,
                ),
                child: customIcon,
              ),
              const SizedBox(height: 10),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  final firstText, secondText, hasImage, imagePath;

  const ProfileInfoCard(
      {super.key,
      this.firstText,
      this.secondText,
      this.hasImage = false,
      this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: hasImage
            ? Center(
                child: Image.asset(
                  imagePath,
                  width: 25,
                  height: 25,
                ),
              )
            : TwoLineItem(
                firstText: firstText,
                secondText: secondText,
              ),
      ),
    );
  }
}

class TwoLineItem extends StatelessWidget {
  final String firstText, secondText;

  const TwoLineItem(
      {super.key, required this.firstText, required this.secondText});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          firstText,
          style: const TextStyle(
            fontSize: 16.0,
            color: AppColors.darkGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          secondText,
          style: const TextStyle(
            fontSize: 14.0,
            color: AppColors.darkGrey,
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }
}

class ProfileInfoBigCard extends StatelessWidget {
  final String firstText, secondText;
  final Widget icon;

  const ProfileInfoBigCard(
      {super.key,
      required this.firstText,
      required this.secondText,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardwidth;

    if (screenWidth <= 360) {
      cardwidth = screenWidth / 200;
    } else {
      cardwidth = screenWidth / 15;
    }

    return Card(
      color: AppColors.secondaryColor,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          top: cardwidth,
          bottom: 5,
          right: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: icon,
            ),
            Text(
              firstText,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              secondText,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
