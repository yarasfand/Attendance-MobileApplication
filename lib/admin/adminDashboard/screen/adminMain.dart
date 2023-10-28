import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/admin/adminOptionsReport/screens/AdminMonthlyAndDailyReportsMainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import '../../../constants/AppColor_constants.dart';
import '../../../introduction/bloc/bloc_internet/internet_bloc.dart';
import '../../../introduction/bloc/bloc_internet/internet_state.dart';
import '../../../login/bloc/loginBloc/loginbloc.dart';
import '../../../login/screens/loginPage.dart';
import '../../adminGeofence/screens/GeoFenceMainPage.dart';
import '../../adminProfile/models/AdminProfileModel.dart';
import '../../adminProfile/models/AdminProfileRepository.dart';
import '../../adminProfile/screens/adminProfilePage.dart';
import '../../adminReports/screens/adminReports_page.dart';
import '../bloc/admin_dash_bloc.dart';
import 'adminAppbar.dart';
import 'adminDraweritems.dart';
import 'adminHome.dart';
import 'admindDrawer.dart';


class UserProfile {
  String name;
  String email;

  UserProfile(this.name, this.email);

  // Add a factory constructor for the Singleton pattern
  factory UserProfile.instance() => _singleton;
  static final UserProfile _singleton = UserProfile('Loading...', 'Loading...');
}

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({Key? key}) : super(key: key);

  @override
  State<AdminMainPage> createState() => _MainPageState();
}

class _MainPageState extends State<AdminMainPage> {
  final AdminDashBloc dashBloc = AdminDashBloc();
  final AdminProfileRepository profileRepository =
  AdminProfileRepository('http://62.171.184.216:9595');
  late String corporateId;
  late String username;
  late UserProfile userProfile;

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
          );
        },
      ),
    );
  }

  AdminDrawerItem item = AdminDrawerItems.home;
  AdminProfileModel? profileData;

  Future<void> refreshProfileData() async {
    try {
      final data = await profileRepository.fetchAdminProfile(corporateId, username);
      setState(() {
        userProfile.name = data!.userName;
        userProfile.email = data.email;
      });
    } catch (e) {
      print('Error fetching admin profile: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    userProfile = UserProfile.instance(); // Get the singleton instance

    // Load the user profile data
    loadSharedPrefs().then((_) {
      fetchAdminProfileData(corporateId, username);
    });
    refreshProfileData();
  }


  Future<void> fetchAdminProfileData(
      String corporateId, String username) async {
    try {
      final data =
      await profileRepository.fetchAdminProfile(corporateId, username);
      setState(() {
        userProfile.name = data!.userName;
        userProfile.email = data.email;
      });
    } catch (e) {
      print('Error fetching admin profile: $e');
    }
  }


  Future<void> loadSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    corporateId = prefs.getString('corporate_id') ?? '';
    username = prefs.getString('admin_username') ?? '';
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
              drawer:Drawer(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            refreshProfileData();
                          },
                          child: UserAccountsDrawerHeader(
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                             ),
                            accountName: Text(userProfile.name),
                            accountEmail: Text(userProfile.email),
                            currentAccountPicture: const CircleAvatar(
                              backgroundImage: AssetImage("assets/icons/userr.png"),
                            ),
                          ),
                        ),

                        MyDrawer(
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
                      ],
                    ),
                  ),

              ),
              backgroundColor: Colors.white,
              body: getDrawerPage(),
            );
          } else if (state is InternetLostState) {
            return Scaffold(
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
            );
          } else {
            return Scaffold(
              body: Container(),
            );
          }
        },
      );

  Widget getDrawerPage() {
    return BlocBuilder<AdminDashBloc, AdminDashboardkState>(
        bloc: dashBloc,
        builder: (context, state) {
          if (state is NavigateToProfileState) {
            return AdminProfilePage();
          } else if (state is NavigateToGeofenceState) {
            return const GeoFenceMainPage();
          } else if (state is NavigateToHomeState) {
            return const AdminDashboard();
          } else if (state is NavigateToReportsState) {
            return  AdminMonthlyAndDailyReportsMainPage(viaDrawer: true,);
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
                    );
                  },
                ),
                TextButton(
                  child: const Text('Logout'),
                  onPressed: () {
                    _logout(context);
                  },
                ),
              ],
            );
          } else {
            return const AdminDashboard();
          }
        });
  }

  String _getPageInfo(AdminDrawerItem item) {
    switch (item) {
      case AdminDrawerItems.home:
        return "HOME";
      case AdminDrawerItems.geofence:
        return "GEOFENCE";
      case AdminDrawerItems.profile:
        return "PROFILE";
      case AdminDrawerItems.reports:
        return "REPORTS";
      case AdminDrawerItems.logout:
        return "";
      default:
        return "HOME";
    }
  }
}
