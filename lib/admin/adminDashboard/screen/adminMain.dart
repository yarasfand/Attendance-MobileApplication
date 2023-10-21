import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project/admin/pendingLeavesApproval/model/ApproveManualPunchRepository.dart';
import 'package:project/admin/pendingLeavesApproval/screens/PendingLeavesPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/AppColor_constants.dart';
import '../../../introduction/bloc/bloc_internet/internet_bloc.dart';
import '../../../introduction/bloc/bloc_internet/internet_state.dart';
import '../../../login/bloc/loginBloc/loginbloc.dart';
import '../../../login/screens/loginPage.dart';
import '../../adminGeofence/screens/GeoFenceMainPage.dart';
import '../../adminGeofence/screens/adminGeofencing.dart';
import '../../adminProfile/screens/adminProfilePage.dart';
import '../../adminReports/screens/adminReports_page.dart';
import '../bloc/admin_dash_bloc.dart';
import 'adminAppbar.dart';
import 'adminHome.dart';
import 'admindDrawer.dart';
import 'adminDraweritems.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({Key? key}) : super(key: key);

  @override
  State<AdminMainPage> createState() => _MainPageState();
}

class _MainPageState extends State<AdminMainPage> {
  final AdminDashBloc dashBloc = AdminDashBloc();

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

  AdminDrawerItem item = AdminDrawerItems.home;

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
                  child: AdminAppBar(
                    pageHeading: _getPageInfo(item),
                  ),
                ),
                drawer: Drawer(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
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
                        child: MyDrawer(
                          onSelectedItems: (selectedItem) {
                            setState(() {
                              item = selectedItem;
                              Navigator.of(context).pop();
                            });

                            switch (item) {
                              case AdminDrawerItems.home:
                                dashBloc.add(NavigateToHomeEvent());
                                break;

                              case AdminDrawerItems.geofence:
                                dashBloc.add(NavigateToGeofenceEvent());
                                break;

                              case AdminDrawerItems.reports:
                                dashBloc.add(NavigateToReportsEvent());
                                break;

                              case AdminDrawerItems.profile:
                                dashBloc.add(NavigateToProfileEvent());
                                break;

                              case AdminDrawerItems.logout:
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
    return BlocBuilder<AdminDashBloc, AdminDashboardkState>(
        bloc: dashBloc,
        builder: (context, state) {
          if (state is NavigateToProfileState) {
            return AdminProfilePage();
          } else if (state is NavigateToGeofenceState) {
            return GeoFenceMainPage();
          } else if (state is NavigateToHomeState) {
            return AdminDashboard();
          } else if (state is NavigateToReportsState) {
            return AdminReportsPage();
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
                        builder: (context) => const AdminMainPage(),
                      ),
                    ); // Close the dialog
                    // Close the dialog
                  },
                ),
                TextButton(
                  child: const Text('Logout'),
                  onPressed: () {
                    // Add the logic to perform logout here
                    _logout(context); // Close the dialog
                  },
                ),
              ],
            );
          } else {
            return AdminDashboard();
          }
        });
  }

  String _getPageInfo(AdminDrawerItem item) {
    switch (item) {
      case AdminDrawerItems.home:
        return "Home";
      case AdminDrawerItems.geofence:
        return "Geofence";
      case AdminDrawerItems.profile:
        return "Profile";
      case AdminDrawerItems.reports:
        return "Reports";
      case AdminDrawerItems.logout:
        return "";
      default:
        return "Home"; // Set the default title
    }
  }
}
