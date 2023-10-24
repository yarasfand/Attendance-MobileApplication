import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project/constants/AppColor_constants.dart';
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

class EmpMainPage extends StatefulWidget {
  const EmpMainPage({Key? key}) : super(key: key);

  @override
  State<EmpMainPage> createState() => _EmpMainPageState();
}

class _EmpMainPageState extends State<EmpMainPage> {
  final EmpDashboardkBloc dashBloc = EmpDashboardkBloc();
  EmpProfileModel? empProfile;
  late EmpProfileRepository _profileRepository;

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
    _profileRepository = EmpProfileRepository();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      final profileData = await _profileRepository.getData();
      if (profileData.isNotEmpty) {
        setState(() {
          empProfile = profileData[0];
        });
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
                  child: EmpAppBar(
                    pageHeading: _getPageInfo(item),
                  ),
                ),
                drawer: Drawer(
                  child: Column(
                    children: [
                      UserAccountsDrawerHeader(
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                        ),
                        accountName: Text(empProfile?.empName ?? ""),
                        accountEmail: Text(empProfile?.emailAddress ?? ""),
                        currentAccountPicture: const CircleAvatar(
                          backgroundImage: AssetImage(
                            "assets/icons/userr.png",
                          ),
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
          });

  Widget getDrawerPage() {
    return BlocBuilder<EmpDashboardkBloc, EmpDashboardkState>(
      bloc: dashBloc,
      builder: (context, state) {
        if (state is NavigateToProfileState) {
          return EmpProfilePage();
        } else if (state is NavigateToHomeState) {
          return EmpDashboard();
        } else if (state is NavigateToReportsState) {
          return ReportsMainPage(viaDrawer: true,);
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

  String _getPageInfo(EmpDrawerItem item) {
    switch (item) {
      case EmpDrawerItems.home:
        return "HOME";
      case EmpDrawerItems.reports:
        return "REPORTS";
      case EmpDrawerItems.profile:
        return "PROFILE";
      case EmpDrawerItems.logout:
        return "";
      default:
        return "HOME"; // Set the default title
    }
  }
}
