import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:project/employee/empDashboard/screens/employeeMain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Sqlite/sqlite_helper.dart';
import '../../../constants/globalObjects.dart';
import '../../../login/bloc/loginBloc/loginbloc.dart';
import '../../../login/screens/loginPage.dart';
import '../bloc/emProfileApiFiles/emp_profile_api_bloc.dart';
import '../models/empProfileModel.dart';
import '../models/empProfileRepository.dart';
import 'EditProfile_page.dart';

typedef void RefreshDataCallback();

class EmpProfilePage extends StatefulWidget {
  final Function onProfileEdit;

  const EmpProfilePage({Key? key, required this.onProfileEdit}) : super(key: key);

  @override
  State<EmpProfilePage> createState() => EmpProfilePageState();
}

class EmpProfilePageState extends State<EmpProfilePage> {
  LoginPageState select = LoginPageState();
  Key _profileImageKey = UniqueKey();
  bool _didEditProfile = false; // Add this variable

  Widget _buildProfileImage() {
    return FutureBuilder(
      future: fetchProfileImage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CircleAvatar(
            key: _profileImageKey, // Use the unique key
            radius: 70.0,
            backgroundImage: snapshot.data,
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<ImageProvider<Object>> fetchProfileImage() async {
    try {
      final profileData = await _profileRepository.getData();
      if (profileData.isNotEmpty) {
        EmpProfileModel? empProfile = profileData.first;
        final profileImage = empProfile.profilePic;
        if (profileImage != null && profileImage.isNotEmpty) {
          profileImageUrl = profileImage;
          await Future.delayed(Duration(
              seconds: 2));
          return MemoryImage(
            Uint8List.fromList(base64Decode(profileImage)),
          );
        }
      }
    } catch (e) {
      print("Error fetching profile image: $e");
    }
    return AssetImage('assets/icons/userrr.png');
  }

  late EmpProfileApiBloc _profileApiBloc;



  Future<bool> _logout(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', false);
      prefs.setBool('isEmployee', false);

      // Get the employee ID from the SQLite table
      final dbHelper = EmployeeDatabaseHelper();
      int employeeId = await dbHelper.getLoggedInEmployeeId();

      // Show the confirmation dialog
      CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        title: 'Confirm Logout',
        text: 'Are you sure?',
        confirmBtnText: 'Logout',
        cancelBtnText: 'Cancel',

        onConfirmBtnTap: () async {
            await dbHelper.deleteAllEmployeeData();
            // Delete profile data
            await dbHelper.deleteProfileData();

          // Perform logout after confirmation
            Navigator.of(context).pop();
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
        onCancelBtnTap: () {

        },
      );

      return true;
    } catch (e) {
      print("Error during logout: $e");
      print("Logout failed: Data not deleted");
      return false;
    }
  }

  EmpProfileRepository _profileRepository = EmpProfileRepository();
  String? profileImageUrl;
  @override
  void initState() {
    print("init in emp profile called");
    super.initState();
    if(GlobalObjects.empMail == null || GlobalObjects.empPhone== null)
      {
        fetchProfileData();
      }
  }

  Future<void> fetchProfileData() async {
    try {
      final dbHelper = EmployeeDatabaseHelper.instance;
      int loggedInEmployeeId = await dbHelper.getLoggedInEmployeeId();

      if (loggedInEmployeeId > 0) {
        final profileRepository = EmpProfileRepository();
        final profileData = await profileRepository.getData();

        if (profileData.isNotEmpty) {
          EmpProfileModel? empProfile = profileData.first;
          final profileImage = empProfile.profilePic;

          // Insert or replace into employeeProfileData table
          await dbHelper.insertProfileData(
            empCode: empProfile.empCode,
            profilePic: profileImage,
            empName: empProfile.empName,
            emailAddress: empProfile.emailAddress,
          );

          // Insert or replace into profileTable
          await dbHelper.insertProfilePageData(
            empCode: empProfile.empCode,
            profilePic: profileImage,
            empName: empProfile.empName,
            emailAddress: empProfile.emailAddress,
            joinDate: empProfile.dateofJoin.toIso8601String() ?? '',
            phoneNumber: empProfile.phoneNo ?? '',
            password: empProfile.password ?? '',
            fatherName: empProfile.fatherName ?? '',
          );

          // Update global objects and UI state
          GlobalObjects.empCode = empProfile.empCode;
          GlobalObjects.empProfilePic = profileImage;
          GlobalObjects.empName = empProfile.empName;
          GlobalObjects.empMail = empProfile.emailAddress;
          GlobalObjects.empFatherName=empProfile.fatherName;
          GlobalObjects.empPassword=empProfile.password;
          GlobalObjects.empJoinDate=empProfile.dateofJoin;
          GlobalObjects.empPhone=empProfile.phoneNo;
          setState(() {
            profileImageUrl = profileImage;
            GlobalObjects.empCode = empProfile.empCode;
            GlobalObjects.empProfilePic = profileImage;
            GlobalObjects.empName = empProfile.empName;
            GlobalObjects.empMail = empProfile.emailAddress;
            GlobalObjects.empFatherName=empProfile.fatherName;
            GlobalObjects.empPassword=empProfile.password;
            GlobalObjects.empJoinDate=empProfile.dateofJoin;
            GlobalObjects.empPhone=empProfile.phoneNo;

          });
        }

        // Print profile data for debugging
        await dbHelper.printProfileData();
      }
    } catch (e) {
      print("Error fetching and saving profile data: $e");
    } finally {
      setState(() {});
    }
  }

  void updateProfileData() {
    // Fetch and update the profile data
    fetchProfileData();
    // Trigger a rebuild of the widget tree
    setState(() {});
  }

  var initEmpMainPage = EmpMainPageState();


  Future<bool?> _onBackPressed(BuildContext context) async {
    bool? exitConfirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Exit'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Yes'),
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


  void call(String number) => launch("tel:$number");
  void sendSms(String number) => launch("sms:$number");
  void sendEmail(String email) => launch("mailto:$email");

  @override
  Widget build(BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
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
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            top: 20.0), // Add margin from the top
                        child: Column(
                          children: [
                            CircleAvatar(
                              key: _profileImageKey,
                              radius: 70.0,
                              backgroundImage: (GlobalObjects
                                              .empProfilePic !=
                                          null &&
                                      GlobalObjects
                                          .empProfilePic!.isNotEmpty)
                                  ? MemoryImage(
                                      base64Decode(
                                          GlobalObjects.empProfilePic!),
                                    ) as ImageProvider<Object>
                                  : AssetImage('assets/icons/userrr.png'),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  GlobalObjects.empName ?? "---",
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
                                  GlobalObjects.empMail ?? "---",
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
                                  "Join Date: ${DateFormat('dd MMM yy').format(GlobalObjects.empJoinDate ?? DateTime.now())}",
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
                          ],
                        ),
                      ),
                      // Capsule structure for icons
                      Container(
                        margin: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0),
                        // Add margin from the top and bottom
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
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
                                    call(GlobalObjects.empPhone ?? "---");
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
                                        GlobalObjects.empMail ?? "---");
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
                                  icon: const Icon(
                                      FontAwesomeIcons.message,
                                      color: Colors.white),
                                  onPressed: () {
                                    sendSms(GlobalObjects.empPhone ?? "---");
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
                Column(
                  children: [
                    _buildTileWidget(
                      title: 'Edit Profile',
                      icon: FontAwesomeIcons.pencil,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          PageTransition(
                            child: EmpEditProfilePage(
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
                    SizedBox(height: 20,),
                    _buildTileWidget(
                      title: 'Logout',
                      icon: Icons.logout,
                      onTap: () => _logout(context),
                    ),
                  ],
                )

              ],
            ),
          );
  }

  Widget _buildField(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          value.isNotEmpty ? value : "---",
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      ],
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
