import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/admin/adminProfile/models/AdminProfileRepository.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/constants/globalObjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../login/bloc/loginBloc/loginbloc.dart';
import '../../../login/screens/loginPage.dart';
import '../bloc/admin_profile_bloc.dart';
import '../bloc/admin_profile_event.dart';
import '../bloc/admin_profile_state.dart';
import 'AdminEditProfilePage.dart';

typedef void RefreshDataCallbackAdmin();

class AdminProfilePage extends StatefulWidget {
  final RefreshDataCallbackAdmin? onRefreshData;

  AdminProfilePage({Key? key, this.onRefreshData}) : super(key: key);

  @override
  AdminProfilePageState createState() => AdminProfilePageState();
}

class AdminProfilePageState extends State<AdminProfilePage> {
  late AdminProfileBloc adminProfileBloc;

  void _logout(BuildContext context) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.warning,
      text: 'Do you want to logout?',
      confirmBtnText: 'Logout!',
      cancelBtnText: 'No',
      confirmBtnColor: Colors.blue,
      onConfirmBtnTap: () async {
        // Handle logout logic
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
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchProfileData();
    if (GlobalObjects.adminusername == null ||
        GlobalObjects.adminphonenumber == null) {
      fetchProfileData();
    }
  }

  @override
  void dispose() {
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
      print("Exiting the app");
      exitApp();
      return true;
    } else {
      return false;
    }
  }

  void exitApp() {
    exit(0);
  }

  String formatDate(String dateString) {
    final DateTime? joinedDate = DateTime.tryParse(dateString);
    return joinedDate != null ? DateFormat.yMMMd().format(joinedDate) : '---';
  }

  void call(String number) => launch("tel:$number");
  void sendSms(String number) => launch("sms:$number");
  void sendEmail(String email) => launch("mailto:$email");

  bool isInternetLost = false;

  Future<void> fetchProfileData() async {
    SharedPreferences prefAdmin = await SharedPreferences.getInstance();
    GlobalObjects.adminusername = prefAdmin.getString('admin_username');
    GlobalObjects.adminCorpId = prefAdmin.getString('admin_corporateId');
    final repository = AdminProfileRepository();
    final employeeData = await repository
        .fetchAdminProfile(prefAdmin.getString('admin_username').toString());

    setState(() {
      GlobalObjects.adminMail = employeeData!.email;
      GlobalObjects.adminusername = employeeData.userName;
      GlobalObjects.adminpassword = employeeData.userPassword;
      GlobalObjects.adminphonenumber = employeeData.mobile;
      GlobalObjects.adminJoinedDate = employeeData.onDate;
    });
    print(GlobalObjects.adminMail);
    print(GlobalObjects.adminusername);
  }

  @override
  Widget build(BuildContext context) {
    return GlobalObjects.adminusername == null ||
            GlobalObjects.adminphonenumber == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
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
                                  AssetImage('assets/icons/userrr.png'),
                              radius: 70,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  GlobalObjects.adminusername ?? "---",
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      // Increase font size
                                      color: Colors.black,
                                    ),
                                  ),
                                  softWrap: true,
                                ),
                                Text(
                                  GlobalObjects.adminMail ?? "---",
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16,
                                      // Increase font size
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Join Date: ${formatDate(GlobalObjects.adminJoinedDate.toString())}",
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                const EdgeInsets.only(top: 20.0, bottom: 20.0),
                            // Add margin from the top and bottom
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors
                                        .blue, // Change the color as needed
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      icon: const Icon(FontAwesomeIcons.phone,
                                          color: Colors.white),
                                      onPressed: () {
                                        call(GlobalObjects.adminphonenumber ??
                                            "---");
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors
                                        .grey, // Change the color as needed
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      icon: const Icon(
                                          FontAwesomeIcons.envelope,
                                          color: Colors.white),
                                      onPressed: () {
                                        sendEmail(
                                            GlobalObjects.adminMail ?? "---");
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors
                                        .green, // Change the color as needed
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      icon: const Icon(FontAwesomeIcons.message,
                                          color: Colors.white),
                                      onPressed: () {
                                        sendSms(
                                            GlobalObjects.adminphonenumber ??
                                                "---");
                                        // Add your call functionality here
                                      },
                                    ),
                                  ),
                                ),
                              ],
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
                        style: const TextStyle(
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
