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
import '../../empProfilePage/screens/profilepage.dart';
import '../../empReports/screens/reports_page_employee.dart';
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

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('Login', false);

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
                      Container(
                        height: MediaQuery.of(context).size.height ,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.secondaryColor,
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
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
          return EmpReportsPage();
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
        return "Home";
      case EmpDrawerItems.reports:
        return "Reports";
      case EmpDrawerItems.profile:
        return "Profile";
      case EmpDrawerItems.logout:
        return "";
      default:
        return "Home"; // Set the default title
    }
  }
}
