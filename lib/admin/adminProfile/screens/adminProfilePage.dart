import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/admin/adminProfile/models/AdminProfileRepository.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
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
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
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
    return joinedDate != null
        ? DateFormat.yMMMd().format(joinedDate)
        : '---';
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

  Future<void> _fetchProfileData() async {
    adminProfileBloc.add(FetchAdminProfile(
      corporateId: 'ptsoffice',
      employeeId: 'ptsadmin',
    ));
  }
  @override
  Widget build(BuildContext context) {
    adminProfileBloc = AdminProfileBloc(
        AdminProfileRepository('http://62.171.184.216:9595'));
    adminProfileBloc.add(FetchAdminProfile(
      corporateId: 'ptsoffice',
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
                  userProfile = UserProfile(adminProfile.userName ?? '---', adminProfile.email ?? '---');

                  return SingleChildScrollView(
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
                          color: Colors.white,
                          margin: const EdgeInsets.all(16),
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
                        const Divider(
                          color: Colors.grey,
                          thickness: 1.0,
                          height: 20,
                          indent: 16,
                          endIndent: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const SizedBox(height: 10),
                                GestureDetector(
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
                                      _fetchProfileData();

                                    }
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                        size: 32,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Edit Profile',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),


                                const SizedBox(height: 20),

                                const SizedBox(height: 20),
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: Colors.red,
                                      size: 32,
                                    ),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () => _logout(context),
                                      child: Text(
                                        'Logout',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
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
}
