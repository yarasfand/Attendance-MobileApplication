import 'dart:convert';
import 'dart:typed_data';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:project/constants/globalObjects.dart';
import 'package:project/employee/empReportsOnDash/screens/leaveReportMainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../introduction/bloc/bloc_internet/internet_bloc.dart';
import '../../../introduction/bloc/bloc_internet/internet_state.dart';
import '../../../login/bloc/loginBloc/loginbloc.dart';
import '../../../login/screens/loginPage.dart';
import '../../empProfilePage/models/empProfileModel.dart';
import '../../empProfilePage/models/empProfileRepository.dart';
import '../../empProfilePage/screens/profilepage.dart';
import '../../empReportsOnDash/screens/ReportsMainPage.dart';
import '../bloc/employeeDashboardBloc/EmpDashboardk_bloc.dart';
import 'empDashHome.dart';
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

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.setBool('isEmployee', false);

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

  EmpDrawerItem item = EmpDrawerItems.home;

  @override
  void initState() {
    super.initState();
    profileRepository = EmpProfileRepository();
    fetchProfileData();
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

        // Update your UI with other profile data here
      }
    } catch (e) {
      print("Error fetching profile data: $e");
    }
  }

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
    return BlocBuilder<EmpDashboardkBloc, EmpDashboardkState>(
      bloc: dashBloc,
      builder: (context, state) {
        if (state is NavigateToProfileState) {
          return EmpProfilePage(onRefreshData: () {
            fetchProfileData();
          });
        }
        else if (state is NavigateToLeaveState) {
          print("This is leave state");
          return LeaveRequestPage(viaDrawer: true,);
        } else if (state is NavigateToHomeState) {
          return EmpDashboard();
        } else if (state is NavigateToReportsState) {
          return ReportsMainPage(viaDrawer: true);
        }
        else if (state is NavigateToLogoutState) {
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmpMainPage(),
                  ),
                );
              },
            );
          });

          return const EmpDashboard(); // Assuming AdminDashboard is the default screen
        }
        else {
          return EmpDashboard();
        }
      },
    );
  }

  String _getStyledTitle(EmpDrawerItem item) {
    switch (item) {
      case EmpDrawerItems.leaves:
        return "Leaves";
      case EmpDrawerItems.home:
        return "Home";
      case EmpDrawerItems.reports:
        return "Reports";
      case EmpDrawerItems.profile:
        return "Profile";
      case EmpDrawerItems.logout:
        return ""; // You can return an empty string if needed
      default:
        return "Home"; // Set the default title
    }
  }
}
