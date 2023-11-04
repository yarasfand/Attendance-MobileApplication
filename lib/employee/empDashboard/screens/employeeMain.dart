import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project/constants/AppBar_constant.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:project/constants/globalObjects.dart';
import 'package:project/employee/empDashboard/screens/empAppbar.dart';
import 'package:project/employee/empDashboard/screens/empHomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../introduction/bloc/bloc_internet/internet_bloc.dart';
import '../../../introduction/bloc/bloc_internet/internet_state.dart';
import '../../../login/bloc/loginBloc/loginbloc.dart';
import '../../../login/screens/loginPage.dart';
import '../../empProfilePage/bloc/emProfileApiFiles/emp_profile_api_bloc.dart';
import '../../empProfilePage/models/empProfileModel.dart';
import '../../empProfilePage/models/empProfileRepository.dart';
import '../../empProfilePage/screens/profilepage.dart';
import '../../empReports/screens/reports_page_employee.dart';
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
  Widget build(BuildContext context) => BlocConsumer<InternetBloc, InternetStates>(
    listener: (context, state) {},
    builder: (context, state) {
      if (state is InternetGainedState) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: AppBar().preferredSize,
            child: GenAppBar(
              pageHeading: _getStyledTitle(item), // Use _getStyledTitle here
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
                    backgroundImage: GlobalObjects.empProfilePic != null && GlobalObjects.empProfilePic!.isNotEmpty
                        ? Image.memory(
                      Uint8List.fromList(base64Decode(GlobalObjects.empProfilePic!)),
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
            // Handle the refresh signal here in the drawer.
            // Update the drawer's UI or reload the data as needed.
            fetchProfileData(); // You can call the function to refresh the profile data here.
          });
        } else if (state is NavigateToHomeState) {
          return EmpDashboard();
        } else if (state is NavigateToReportsState) {
          return ReportsMainPage(viaDrawer: true);
        } else if (state is NavigateToLogoutState) {
          return AlertDialog(
            title: const Text("Confirm Logout"),
            content: const Text("Are you sure?"),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmpMainPage(),
                    ),
                  ); // Close the dialog
                },
              ),
              TextButton(
                child: const Text('Logout'),
                onPressed: () {
                  _logout(context); // Close the dialog
                },
              ),
            ],
          );
        } else {
          return EmpDashboard();
        }
      },
    );
  }

  String _getStyledTitle(EmpDrawerItem item) {
    switch (item) {
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
