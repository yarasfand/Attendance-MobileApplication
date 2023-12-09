import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    if (widget.onRefreshData != null) {
      widget.onRefreshData!();
    }
    SharedPreferences prefAdmin = await SharedPreferences.getInstance();
    GlobalObjects.adminusername = prefAdmin.getString('admin_username');
    GlobalObjects.adminCorpId = prefAdmin.getString('admin_corporateId');
    adminProfileBloc.add(FetchAdminProfile(
      corporateId: GlobalObjects.adminCorpId ?? 'ptsoffice',
      employeeId: GlobalObjects.adminusername ?? 'ptsadmin',
    ));
    print(GlobalObjects.adminMail);
    print(GlobalObjects.adminusername);
  }

  @override
  Widget build(BuildContext context) {
    adminProfileBloc = AdminProfileBloc(AdminProfileRepository());
    adminProfileBloc.add(FetchAdminProfile(
      corporateId: GlobalObjects.adminCorpId ?? 'ptsoffice',
      employeeId: GlobalObjects.adminusername ?? "ptsadmin",
    ));

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

            GlobalObjects.adminphonenumber = adminProfile.mobile;
            GlobalObjects.adminpassword = adminProfile.userPassword;
            GlobalObjects.adminusername = adminProfile.userName;
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
                                    AssetImage('assets/icons/userrr.png'),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                                    BorderRadius.circular(50),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: IconButton(
                                                  icon: const Icon(Icons.call,
                                                      color: Colors.white),
                                                  onPressed: () {
                                                    call(
                                                        adminProfile.mobile);
                                                  },
                                                ),
                                              ),
                                            ),
                                            Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: IconButton(
                                                  icon: const Icon(
                                                      Icons.message,
                                                      color: Colors.white),
                                                  onPressed: () {
                                                    sendSms(
                                                        adminProfile.mobile);
                                                  },
                                                ),
                                              ),
                                            ),
                                            Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: IconButton(
                                                  icon: const Icon(Icons.mail,
                                                      color: Colors.white),
                                                  onPressed: () {
                                                    sendEmail(
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
          } else {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                strokeWidth: 5.0,
              ),
            );
          }
        },
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
