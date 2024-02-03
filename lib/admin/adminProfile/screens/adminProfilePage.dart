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
import '../../../Sqlite/admin_sqliteHelper.dart';
import '../../../login/bloc/loginBloc/loginbloc.dart';
import '../../../login/screens/loginPage.dart';
import '../../adminDashboard/screen/adminMain.dart';
import '../bloc/admin_profile_bloc.dart';
import '../bloc/admin_profile_event.dart';
import '../bloc/admin_profile_state.dart';
import 'AdminEditProfilePage.dart';


class AdminProfilePage extends StatefulWidget {
  final Function onProfileEdit;

  const AdminProfilePage({Key? key, required this.onProfileEdit}) : super(key: key);

  @override
  AdminProfilePageState createState() => AdminProfilePageState();
}

class AdminProfilePageState extends State<AdminProfilePage> {
  late AdminProfileBloc adminProfileBloc;
  bool _didEditProfile = false; // Add this variable

  void updateProfileData() {
    // Fetch and update the profile data
    fetchProfileData();
    // Trigger a rebuild of the widget tree
    setState(() {});
  }

  Future<void> _logout(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', false);
      prefs.setBool('isEmployee', false);

      // Get the employee ID from the SQLite table
      final adminDbHelper = AdminDatabaseHelper();

      // Wait for the data deletion to complete
      CoolAlert.show(context: context, type: CoolAlertType.confirm,
          title: 'Confirm Logout',
          text: 'Are you sure?',
          confirmBtnText: 'Logout',
          cancelBtnText: 'Cancel',
          onConfirmBtnTap: () async{
            await adminDbHelper.deleteAllAdmins();
            Navigator.of(context).pop();

            // Perform logout after confirmation
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => SignInBloc(),
                  child: LoginPage(),
                ),
              ),
            );
          },
        onCancelBtnTap: ()  {

        }
      );
      // Show the custom confirmation dialog

    } catch (e) {
      print("Error during logout: $e");
      print("Logout failed: Data not deleted");
    }
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
  Future<bool> _confirmLogout(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm Logout',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            // Add any other styles you want
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure you want to logout?',
              style: TextStyle(
                fontSize: 16,
                // Add any other styles you want
              ),
            ),
            // Add any additional content here
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              'No',
              style: TextStyle(
                // Add any styles you want for the 'No' button
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(
              'Yes',
              style: TextStyle(
                // Add any styles you want for the 'Yes' button
                color: Colors.red, // For example, making the text red
              ),
            ),
          ),
        ],
      ),
    ) ?? false;
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
                  SizedBox(height: MediaQuery.of(context).size.height > 720 ? 20: 0),
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
                                  child:  AdminEditProfilePage(
                                    onSave: () {
                                      // Callback function triggered when data is saved in EditProfilePage
                                      updateProfileData();
                                    },
                                    onSaveSuccess: () {
                                      // Set the boolean value to true when the user comes back
                                      setState(() {
                                        _didEditProfile = true;
                                      });
                                    },
                                  ),
                                  type: PageTransitionType.rightToLeft,
                                ),
                              );
                              if (_didEditProfile) {
                                widget.onProfileEdit(); // Call the callback function here
                                updateProfileData();
                                setState(() {
                                  _didEditProfile = false; // Reset the boolean value
                                });
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          _buildTileWidget(
                            title: 'Logout',
                            icon: Icons.logout,
                            onTap: () async {
                                await _logout(context);
                            },
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
