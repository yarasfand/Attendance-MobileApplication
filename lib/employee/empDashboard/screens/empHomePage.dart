import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:project/constants/AnimatedTextPopUp.dart';
import 'package:project/constants/globalObjects.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/constants/AppBar_constant.dart';
import 'package:project/constants/AppColor_constants.dart';
import '../../../Sqlite/sqlite_helper.dart';
import '../../../introduction/bloc/bloc_internet/internet_bloc.dart';
import '../../../introduction/bloc/bloc_internet/internet_state.dart';
import '../../empMap/models/attendanceGeoFencingModel.dart';
import '../../empMap/models/attendanceGeoFencingRepository.dart';
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
import 'empDrawer.dart';
import 'empDrawerItems.dart';

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
  EmpDrawerItem item = EmpDrawerItems.home;
  final EmpDashRepository _repository = EmpDashRepository();
  late List<EmpDashModel> empDashData;
  final EmpAttendanceRepository _attendanceRepository =
      EmpAttendanceRepository();
  late EmpAttendanceModel empAttendanceData;
  bool loadingData = false;

  Future<void> attendDoneNowNull() async {
    try {
      final dbHelper = EmployeeDatabaseHelper.instance;
      final db = await dbHelper.database;

      await db.transaction((txn) async {
        await txn.rawUpdate('''
        UPDATE employeeAttendanceData
        SET long = ?, lat = ?, location = ?, dateTime = ?, attendeePic = ?
      ''', [null, null, null, null, null]);
      });
      print("Data set to null successfully");
    } catch (e) {
      print("Error setting data to null: $e");
    }
  }

  Future<void> _markPresentifAttendancePending() async {
    try {
      final dbHelper = EmployeeDatabaseHelper.instance;
      final attendData = await dbHelper.getAttendanceData();
      String? empCode = attendData['location'];

      String? g1 = attendData['location'];
      print('Get them, $g1');
      print("$empCode");

      if (empCode != "0" && empCode != null) {
        String imageInString = attendData['attendeePic'];
        List<int> imageBytes = imageInString.codeUnits;
        final base64Image = base64Encode(imageBytes);

        DateTime dateTimeConverted = DateTime.parse(attendData['dateTime']);
        final geoFenceModel = GeofenceModel(
          cardno: attendData['empCode'],
          location: attendData['location'],
          lan: attendData['lat'],
          long: attendData['long'],
          imageData: base64Image,
          imeiNo: null,
          temp1: '',
          temp2: '',
          attendanceType: null,
          remark1: null,
          imagepath: '',
          punchDatetime: dateTimeConverted,
        );
        final geoFenceRepository = GeoFenceRepository("location");
        try {
          await geoFenceRepository.postData(geoFenceModel);
          await attendDoneNowNull();
          print("Data posted successfully");
        } catch (e) {
          print("Data not posted: $e");
        }
        print("Data set to null successfully");

        String formattedDateTime =
            DateFormat('MMM dd, yyyy hh:mm a').format(dateTimeConverted);
        showCustomSuccessAlertEditEmployee(context,
            "Pending Attendance Marked Successfully $formattedDateTime");
      } else if (empCode == "0" || empCode == null) {
        print("hello");
        return;
      }

      final attendData1 = await dbHelper.getAttendanceData();
      String? h = attendData1['lat'];
      String? g = attendData1['location'];
      print('Get them $h, $g');
    } catch (e) {
      print("Error Posting/Setting Attendance data: $e");
    }
  }

  @override
  void initState() {
    print("init in emp home called");
    checkLocationPermission();
    checkLocationPermissionAndFetchLocation();
    if (GlobalObjects.empProfilePic == null ||
        GlobalObjects.empCode == null ||
        GlobalObjects.empAbsent == null ) {
      setState(() {
        print("i am in");
        loadingData = true;
      });
      fetchProfileData();
    }

    Future.delayed(const Duration(seconds: 5), () {
      _markPresentifAttendancePending();
    });
  }

  String? profileImageUrl;

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
        final profileData = await dbHelper.getEmployeeProfileData();

        setState(() {
          GlobalObjects.empCode = profileData['empCode'];
          GlobalObjects.empProfilePic = profileData['profilePic'];
          GlobalObjects.empName = profileData['empName'];
          GlobalObjects.empMail = profileData['emailAddress'];
          GlobalObjects.empIn1 = empAttendanceData.in1;
          GlobalObjects.empOut2 = empAttendanceData.out2;
          GlobalObjects.empStatus = empAttendanceData.status?.toString() ?? '';
          GlobalObjects.empPresent = empDashData[0].presentCount.toString() ?? '';
          GlobalObjects.empAbsent = empDashData[0].absentCount.toString() ?? '';
          GlobalObjects.empLeaves = empDashData[0].leaveCount.toString() ?? '';
          setState(() {
            loadingData = false;
          });
        });
      }
    } catch (e) {
      print("Error fetching profile data: $e");
    } finally {
      setState(() {
        GlobalObjects.empIn1 = empAttendanceData.in1;
        GlobalObjects.empOut2 = empAttendanceData.out2;
        GlobalObjects.empStatus = empAttendanceData.status?.toString() ?? '';
        GlobalObjects.empPresent = empDashData[0].presentCount.toString() ?? '';
        GlobalObjects.empAbsent = empDashData[0].absentCount.toString() ?? '';
        GlobalObjects.empLeaves = empDashData[0].leaveCount.toString() ?? '';
      });
    }
  }

  Future<void> _refreshEmpHomePage() async {
    try {
      final dbHelper = EmployeeDatabaseHelper.instance;
      int loggedInEmployeeId = await dbHelper.getLoggedInEmployeeId();

      if (loggedInEmployeeId > 0) {
        final profileRepository = EmpProfileRepository();
        final profileData = await profileRepository.getData();

        if (profileData.isNotEmpty) {
          EmpProfileModel? empProfile = profileData.first;
          final profileImage = empProfile.profilePic;

          final db = await dbHelper.database;
          await db.transaction((txn) async {
            await txn.rawInsert('''
            INSERT OR REPLACE INTO employeeProfileData (empCode, profilePic, empName, emailAddress)
            VALUES (?, ?, ?, ?)
          ''', [
              empProfile.empCode,
              profileImage,
              empProfile.empName,
              empProfile.emailAddress
            ]);
          });

          GlobalObjects.empCode = empProfile.empCode;
          GlobalObjects.empProfilePic = profileImage;
          GlobalObjects.empName = empProfile.empName;
          GlobalObjects.empMail = empProfile.emailAddress;
          setState(() {
            GlobalObjects.empCode = empProfile.empCode;
            GlobalObjects.empProfilePic = profileImage;
            GlobalObjects.empName = empProfile.empName;
            GlobalObjects.empMail = empProfile.emailAddress;
            savedEmpCode = empProfile.empCode;
            profileImageUrl = profileImage;
          });
        }

        // Print the profile data for verification
        await dbHelper.printProfileData();
      }
    } catch (e) {
      print("Error fetching profile data: $e");
    } finally {
      setState(() {});
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

  Widget buildProfileImage(String? profileImage) {
    if (profileImage != null && profileImage.isNotEmpty) {
      try {
        return ClipOval(
          child: Image.memory(
            Uint8List.fromList(
              base64Decode(profileImage),
            ),
            width: 100,
            height: 45,
          ),
        );
      } catch (e) {
        print("Error decoding profile image: $e");
        // Return a default image if there's an error decoding the image
        return Image.asset(
          'assets/icons/userrr.png',
          width: 100,
          height: 45,
        );
      }
    } else {
      // Load default image if profileImage is null or empty
      return Image.asset(
        'assets/icons/userrr.png',
        width: 100,
        height: 45,
      );
    }
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
    return BlocConsumer<InternetBloc, InternetStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is InternetGainedState) {
          return loadingData
              ? Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    showDialog(
                      context: context,
                      barrierDismissible:
                          false, // Prevent user from dismissing the dialog
                      builder: (BuildContext context) {
                        return Scaffold(
                          body: Center(child: CircularProgressIndicator()),
                        );
                      },
                    );

                    // Simulate a delay for 2 seconds (replace this with your actual data fetching logic)
                    await Future.delayed(Duration(seconds: 2));

                    // Close the dialog
                    Navigator.of(context).pop();

                    // Fetch profile data
                    await fetchProfileData();
                  },
                  child: Scaffold(
                    appBar: AppBar(
                      leading: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: IconButton(
                          icon: const FaIcon(FontAwesomeIcons.bars),
                          color: Colors.white,
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                      ),
                      backgroundColor: AppColors.primaryColor,
                      elevation: 0,
                      title: Padding(
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width / 4.5, 30, 0, 0),
                        child: const Row(
                          children: [
                            Text(
                              "Home",
                              style: AppBarStyles.appBarTextStyle,
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 35, 10, 0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible:
                                      false, // Prevent user from dismissing the dialog
                                  builder: (BuildContext context) {
                                    return Scaffold(
                                      body: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  },
                                );

                                // Simulate a delay for 2 seconds (replace this with your actual data fetching logic)
                                await Future.delayed(Duration(seconds: 2));

                                // Close the dialog
                                Navigator.of(context).pop();

                                // Fetch profile data
                                await fetchProfileData();
                              },
                              icon: Icon(Icons.refresh, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                      toolbarHeight: MediaQuery.of(context).size.height / 10,
                    ),
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          WillPopScope(
                            onWillPop: () async {
                              return _onBackPressed(context)
                                  .then((value) => value ?? false);
                            },
                            child: const SizedBox(),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: screenHeight / 80),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                        child: buildProfileImage(
                                            GlobalObjects.empProfilePic),
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
                                        background: AppColors.secondaryColor,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                const SizedBox(
                                  width: 10,
                                ),
                                ProfileInfoCard(
                                  firstText: "IN",
                                  secondText: GlobalObjects.empIn1 ?? "---",
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                ProfileInfoCard(
                                  firstText: "Status",
                                  secondText:
                                      GlobalObjects.empStatus!.isNotEmpty
                                          ? GlobalObjects.empStatus
                                          : "---",
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                ProfileInfoCard(
                                  firstText: "OUT",
                                  secondText: GlobalObjects.empOut2 ?? "---",
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'ID ${GlobalObjects.empCode}',
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
                                        GlobalObjects.empPresent.toString(),
                                    secondText: "Total Present",
                                    icon: Image.asset(
                                      "assets/icons/Attend.png",
                                      width: screenWidth / 15,
                                    ),
                                  ),
                                  ProfileInfoBigCard(
                                    firstText:
                                        GlobalObjects.empAbsent.toString(),
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
                                        GlobalObjects.empLeaves.toString(),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                        background: AppColors.secondaryColor,
                                      ),
                                      onTap: () {
                                        Navigator.push(context,
                                            CupertinoPageRoute(
                                          builder: (context) {
                                            // return LeaveRequestForm();
                                            return LeaveRequestPage(
                                              viaDrawer: false,
                                            );
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
                                                    .rightToLeft));
                                      },
                                      child: ItemDashboard(
                                        showShadow: false,
                                        title: 'Reports',
                                        customIcon: Image.asset(
                                          "assets/icons/report.png",
                                          width: 50,
                                          height: 45,
                                        ),
                                        background: AppColors.secondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
        } else if (state is InternetLostState) {
          return Expanded(
            child: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Slow or No Internet Connection!",
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
    );
  }
}

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
