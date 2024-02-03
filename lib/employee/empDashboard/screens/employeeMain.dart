import 'dart:convert';
import 'dart:typed_data';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:project/constants/globalObjects.dart';
import 'package:project/employee/empDashboard/screens/empHomePage.dart';
import 'package:project/employee/empReportsOnDash/screens/leaveReportMainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Sqlite/sqlite_helper.dart';
import '../../../introduction/bloc/bloc_internet/internet_bloc.dart';
import '../../../introduction/bloc/bloc_internet/internet_state.dart';
import '../../../login/bloc/loginBloc/loginbloc.dart';
import '../../../login/screens/loginPage.dart';
import '../../empMap/screens/employeemap.dart';
import '../../empProfilePage/models/empProfileModel.dart';
import '../../empProfilePage/models/empProfileRepository.dart';
import '../../empProfilePage/screens/profilepage.dart';
import '../../empReportsOnDash/screens/ReportsMainPage.dart';
import '../bloc/employeeDashboardBloc/EmpDashboardk_bloc.dart';
import 'empDrawer.dart';
import 'empDrawerItems.dart';
import 'generalAppBar.dart';

class EmpMainPage extends StatefulWidget {
  const EmpMainPage({Key? key}) : super(key: key);

  @override
  State<EmpMainPage> createState() => EmpMainPageState();
}

class EmpMainPageState extends State<EmpMainPage> {
  final EmpDashboardkBloc dashBloc = EmpDashboardkBloc();
  EmpProfileModel? empProfile;
  EmpDrawerItem item = EmpDrawerItems.home;
  final PageStorageBucket bucket = PageStorageBucket();

  Future<bool> _logout(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', false);
      prefs.setBool('isEmployee', false);

      // Get the employee ID from the SQLite table
      final dbHelper = EmployeeDatabaseHelper();
      int employeeId = await dbHelper.getLoggedInEmployeeId();

      if (employeeId > 0) {
        await dbHelper.deleteAllEmployeeData();

        // Delete profile data
        await dbHelper.deleteProfileData();

        await dbHelper.deleteAttendenceData();

      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => SignInBloc(),
            child: LoginPage(),
          ),
        ),
      );

      // Data successfully deleted
      return true;
    } catch (e) {
      print("Error during logout: $e");
      print("Logout failed: Data not deleted");
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    profileRepository = EmpProfileRepository();

    print("Drawer opens and closed");
    fetchProfileData();
  }

  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  EmpProfileRepository profileRepository = EmpProfileRepository();
  String? profileImageUrl;
  Future<void> fetchProfileData() async {
    try {
      final profileData = await profileRepository.getData();
      if (profileData.isNotEmpty) {
        EmpProfileModel? empProfile = profileData.first;
        final profileImage = empProfile.profilePic;

        setState(() {
          profileImageUrl = profileImage;
          GlobalObjects.empProfilePic = empProfile.profilePic;
          GlobalObjects.empName = empProfile.empName;
          GlobalObjects.empMail = empProfile.emailAddress;
        });
      } else if (profileData.isNotEmpty) {
        final sharedPrefEmp = await SharedPreferences.getInstance();
        setState(() {
          GlobalObjects.empName = sharedPrefEmp.getString('empName');
          GlobalObjects.empMail = sharedPrefEmp.getString('empMail');
        });
      }
    } catch (e) {
      print("Error fetching profile data: $e");
    }
  }

  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<InternetBloc, InternetStates>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is InternetGainedState) {
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: AppBar().preferredSize,
                child: GenAppBar(
                  pageHeading:
                      _getStyledTitle(item), // Use _getStyledTitle here
                ),
              ),
              drawer: Drawer(
                child: Column(
                  children: [
                    UserAccountsDrawerHeader(
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                      ),
                      accountName: Text(GlobalObjects.empName ?? ""),
                      accountEmail: Text(GlobalObjects.empMail ?? ""),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: GlobalObjects.empProfilePic != null &&
                                GlobalObjects.empProfilePic!.isNotEmpty
                            ? Image.memory(
                                Uint8List.fromList(
                                    base64Decode(GlobalObjects.empProfilePic!)),
                              ).image
                            : AssetImage('assets/icons/userrr.png'),
                      ),
                    ),
                    Container(
                      child: EmpDrawer(
                        onSelectedItems: (selectedItem) {
                          setState(() {
                            Navigator.of(context).pop();
                            item = selectedItem;
                          });
                          switch (item) {
                            case EmpDrawerItems.home:
                              dashBloc.add(NavigateToHomeEvent());
                              break;
                            case EmpDrawerItems.reports:
                              dashBloc.add(NavigateToReportsEvent());
                              break;
                            case EmpDrawerItems.profile:
                              dashBloc.add(NavigateToProfileEvent());
                              break;
                            case EmpDrawerItems.geoPunch:
                              dashBloc.add(NavigateToGeoPunchEvent());
                              break;
                            case EmpDrawerItems.leaves:
                              dashBloc.add(NavigateToLeaveEvent());
                              break;
                            case EmpDrawerItems.logout:
                              dashBloc.add(NavigateToLogoutEvent());
                              break;

                            default:
                              dashBloc.add(NavigateToHomeEvent());
                              break;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.white,
              body: getDrawerPage(),
            );
          } else if (state is InternetLostState) {
            return Scaffold(
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
            );
          } else {
            return Scaffold(
              body: Container(),
            );
          }
        },
      );

  Widget getDrawerPage() {
    return PageStorage(
      bucket: _bucket,
      child: BlocBuilder<EmpDashboardkBloc, EmpDashboardkState>(
        bloc: dashBloc,
        builder: (context, state) {
          if (state is NavigateToProfileState) {
            return EmpProfilePage(

              onProfileEdit: () {
                // Call fetchProfileData when the profile is edited
                fetchProfileData();
              },
            );
          } else if (state is NavigateToLeaveState) {
            print("This is leave state");
            return LeaveRequestPage(
              viaDrawer: true,
            );
          }else if (state is NavigateToGeoPunchState) {
            print("This is leave state");
            return EmployeeMap(viaDrawer: true);
          } else if (state is NavigateToHomeState) {
            return EmpDashHome();
          } else if (state is NavigateToReportsState) {
            return ReportsMainPage(viaDrawer: true);
          } else if (state is NavigateToLogoutState) {
            // Use Future.delayed to execute after the build is complete
            Future.delayed(Duration.zero, () {
              CoolAlert.show(
                context: context,
                type: CoolAlertType.confirm,
                title: 'Confirm Logout',
                text: 'Are you sure?',
                confirmBtnText: 'Logout',
                cancelBtnText: 'Cancel',
                onConfirmBtnTap: () async {
                  await _logout(context);
                },
                onCancelBtnTap: () {

                },
              );
            });

            return const EmpDashHome(); // Assuming AdminDashboard is the default screen
          } else {
            return EmpDashHome();
          }
        },
      ),
    );
  }

  String _getStyledTitle(EmpDrawerItem item) {
    switch (item) {
      case EmpDrawerItems.leaves:
        return "Leave";
      case EmpDrawerItems.home:
        return "Home";
      case EmpDrawerItems.reports:
        return "Reports";
      case EmpDrawerItems.profile:
        return "Profile";
      case EmpDrawerItems.geoPunch:
        return "Geo Punch";
      case EmpDrawerItems.logout:
        return "Home"; // You can return an empty string if needed
      default:
        return "Home"; // Set the default title
    }
  }
}
