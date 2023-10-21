import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
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
    prefs.setBool('Login', false); // Set the login status to false

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

  late double xoffset;
  late double yoffset;
  late double scaleFactor;
  bool isDragging = false;
  bool isDrawerOpen = false;
  EmpDrawerItem item = EmpDrawerItems.home;

  @override
  void initState() {
    super.initState();
    closeDrawer();
  }

  void openDrawer() {
    setState(() {
      xoffset = 230;
      yoffset = 170;
      scaleFactor = 0.6;
      isDrawerOpen = true;
    });
  }

  void closeDrawer() {
    setState(() {
      xoffset = 0;
      yoffset = 0;
      scaleFactor = 1;
      isDrawerOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<InternetBloc, InternetStates>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is InternetGainedState) {
              return Scaffold(
                backgroundColor: const Color(0xFFF2D2BD),
                body: Stack(
                  children: [
                    buildDrawer(),
                    buildPage(),
                  ],
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
            } else {
              return Scaffold(
                body: Container(),
              );
            }
          });

  Widget buildDrawer() => SafeArea(
        child: AnimatedOpacity(
          opacity: isDrawerOpen ? 1.0 : 0.0,
          duration: Duration(milliseconds: 300),
          child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
            child: Container(
              height: MediaQuery.of(context).size.height / 1,
              width: xoffset,
              child: EmpDrawer(
                onSelectedItems: (selectedItem) {
                  setState(() {
                    item = selectedItem;
                    closeDrawer();
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
          ),
        ),
      );

  Widget buildPage() {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          closeDrawer();
          return false;
        } else {
          return true;
        }
      },
      child: GestureDetector(
        onTap: closeDrawer,
        onHorizontalDragStart: (details) => isDragging = true,
        onHorizontalDragUpdate: (details) {
          const delta = 1;

          if (!isDragging) return;

          if (details.delta.dx > delta) {
            openDrawer();
          } else if (details.delta.dx < -delta) {
            closeDrawer();
          }
          isDragging = false;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: Matrix4.translationValues(xoffset, yoffset, 0)
            ..scale(scaleFactor),
          child: AbsorbPointer(
            absorbing: isDrawerOpen,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDrawerOpen ? 20 : 0),
              child: Container(
                color: isDrawerOpen
                    ? Colors.white12.withOpacity(0.23)
                    : const Color(0xFFFAF9F6),
                child: getDrawerPage(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getDrawerPage() {
    return BlocBuilder<EmpDashboardkBloc, EmpDashboardkState>(
      bloc: dashBloc,
      builder: (context, state) {
        if (state is NavigateToProfileState) {
          return EmpProfilePage(openDrawer: openDrawer);
        } else if (state is NavigateToHomeState) {
          return EmpDashboard(openDrawer: openDrawer);
        } else if (state is NavigateToReportsState) {
          return EmpReportsPage(
            openDrawer: openDrawer,
          );
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
          return EmpDashboard(openDrawer: openDrawer);
        }
      },
    );
  }
}
