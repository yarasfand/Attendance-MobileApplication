import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/admin/adminProfile/models/AdminProfileRepository.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/constants/globalObjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../No_internet/no_internet.dart';
import '../../../introduction/bloc/bloc_internet/internet_bloc.dart';
import '../../../introduction/bloc/bloc_internet/internet_state.dart';
import '../../../login/bloc/loginBloc/loginbloc.dart';
import '../../../login/screens/loginPage.dart';
import '../../adminDashboard/screen/adminMain.dart';
import '../bloc/admin_profile_bloc.dart';
import '../bloc/admin_profile_event.dart';
import '../bloc/admin_profile_state.dart';
import 'AdminEditProfilePage.dart';
import 'adminProfile.dart';

class AdminProfilePage extends StatefulWidget {
  AdminProfilePage({Key? key}) : super(key: key);

  @override
  AdminProfilePageState createState() => AdminProfilePageState();
}

class AdminProfilePageState extends State<AdminProfilePage> {
  late AdminProfileBloc adminProfileBloc;
  UserProfile userProfile = UserProfile('Loading...', 'Loading...');

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

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  @override
  void dispose() {
    adminProfileBloc.close();
    super.dispose();
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

  String formatDate(String dateString) {
    final DateTime? joinedDate = DateTime.tryParse(dateString);
    return joinedDate != null ? DateFormat.yMMMd().format(joinedDate) : '---';
  }

  void _launchDialer(String phoneNumber) async {
    final url = Uri(scheme: 'tel:$phoneNumber');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching dialer: $e');
    }
  }

  void _launchSms(String phoneNumber) async {
    final url = 'sms:$phoneNumber';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching SMS: $e');
    }
  }

  void _launchEmail(String email) async {
    final url = 'mailto:$email';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching email: $e');
    }
  }

  bool isInternetLost = false;

  Future<void> fetchProfileData() async {
    adminProfileBloc.add(FetchAdminProfile(
      corporateId: GlobalObjects.adminCorpId ?? 'ptsoffice',
      employeeId: 'ptsadmin',
    ));
  }

  @override
  Widget build(BuildContext context) {
    adminProfileBloc =
        AdminProfileBloc(AdminProfileRepository());
    adminProfileBloc.add(FetchAdminProfile(
      corporateId: GlobalObjects.adminCorpId ?? 'ptsoffice',
      employeeId: 'ptsadmin',
    ));

    return BlocConsumer<InternetBloc, InternetStates>(
      listener: (context, state) {
        if (state is InternetLostState) {
          isInternetLost = true;
          Future.delayed(Duration(seconds: 2), () {
            Navigator.push(
              context,
              PageTransition(
                child: NoInternet(),
                type: PageTransitionType.rightToLeft,
              ),
            );
          });
        } else if (state is InternetGainedState) {
          if (isInternetLost) {
            Navigator.pop(context);
          }
          isInternetLost = false;
        }
      },
      builder: (context, state) {
        if (state is InternetGainedState) {
          return Scaffold(
            body: BlocBuilder<AdminProfileBloc, AdminProfileState>(
              bloc: adminProfileBloc,
              builder: (context, state) {
                if (state is AdminProfileLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is AdminProfileLoaded) {
                  final adminProfile = state.adminProfile;
                  final joinedDate = formatDate(adminProfile.onDate);
                  userProfile = UserProfile(adminProfile.userName ?? '---',
                      adminProfile.email ?? '---');

                  GlobalObjects.adminName = adminProfile.userName;
                  GlobalObjects.adminMail = adminProfile.email;

                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, MediaQuery.of(context).size.height / 15, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WillPopScope(
                            onWillPop: () async {
                              return _onBackPressed(context)
                                  .then((value) => value ?? false);
                            },
                            child: const SizedBox(),
                          ),
                          Card(
                            elevation: 4.0,
                            margin: const EdgeInsets.all(32.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Center(
                                    child: CircleAvatar(
                                      backgroundImage:
                                          AssetImage('assets/icons/userr.png'),
                                      radius: 70,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          adminProfile.userName ?? '---',
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                        Text(
                                          adminProfile.email ?? '---',
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          'Joined $joinedDate',
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(16),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(16),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Card(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                50),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(5),
                                                      child: IconButton(
                                                        icon: const Icon(
                                                            Icons.call,
                                                            color: Colors.white),
                                                        onPressed: () {
                                                          _launchDialer(
                                                              adminProfile
                                                                  .mobile);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Card(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                50),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(5),
                                                      child: IconButton(
                                                        icon: const Icon(
                                                            Icons.message,
                                                            color: Colors.white),
                                                        onPressed: () {
                                                          _launchSms(adminProfile
                                                              .mobile);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Card(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                50),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(5),
                                                      child: IconButton(
                                                        icon: const Icon(
                                                            Icons.mail,
                                                            color: Colors.white),
                                                        onPressed: () {
                                                          _launchEmail(
                                                              adminProfile.email);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SizedBox(height: 10),
                                  _buildTileWidget(
                                    title: 'Edit Profile',
                                    icon: Icons.edit,
                                    onTap: () async {
                                      final result = await Navigator.push(
                                        context,
                                        PageTransition(
                                          child: const AdminEditProfilePage(),
                                          type: PageTransitionType.rightToLeft,
                                        ),
                                      );
                                      if (result == true) {
                                        // Refresh the admin profile data when the user returns from EditProfile
                                        fetchProfileData();
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _buildTileWidget(
                                    title: 'Logout',
                                    icon: Icons.logout,
                                    onTap: () => _logout(context),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else if (state is AdminProfileError) {
                  return Center(
                    child: Text(
                      "Error: ${state.error}",
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                  );
                } else if (state is InternetLostState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No Internet Connection!",
                          style: GoogleFonts.roboto(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Lottie.asset('assets/no_wifi.json'),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No Internet Connection!",
                          style: GoogleFonts.roboto(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Lottie.asset('assets/no_wifi.json'),
                      ],
                    ),
                  );
                }
              },
            ),
          );
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _buildTileWidget({
    required String title,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 1 / 14,
                  width: MediaQuery.of(context).size.width * 5 / 6,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryColor,
                          AppColors.secondaryColor,
                        ]),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text(""),
                      Text(
                        "${title}",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Icon(
                            icon,
                            size: 25.0,
                            color: AppColors.primaryColor,
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
