import 'dart:convert';
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
import '../../../constants/globalObjects.dart';
import '../../../login/bloc/loginBloc/loginbloc.dart';
import '../../../login/screens/loginPage.dart';
import '../../empDashboard/screens/empHomePage.dart';
import '../bloc/emProfileApiFiles/emp_profile_api_bloc.dart';
import '../models/empProfileModel.dart';
import '../models/empProfileRepository.dart';
import 'EditProfile_page.dart';

typedef void RefreshDataCallback();

class EmpProfilePage extends StatefulWidget {
  final RefreshDataCallback? onRefreshData;

  EmpProfilePage({Key? key, this.onRefreshData}) : super(key: key);

  @override
  State<EmpProfilePage> createState() => EmpProfilePageState();
}

class EmpProfilePageState extends State<EmpProfilePage> {
  LoginPageState select = LoginPageState();
  Key _profileImageKey = UniqueKey(); // Add a unique key

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
      // Fetch profile data and get the profile image URL
      final profileData = await _profileRepository.getData();
      if (profileData.isNotEmpty) {
        EmpProfileModel? empProfile = profileData.first;
        final profileImage = empProfile.profilePic;
        if (profileImage != null && profileImage.isNotEmpty) {
          profileImageUrl = profileImage;
          await Future.delayed(Duration(seconds: 2)); // Simulate a delay, remove this in your actual code
          return MemoryImage(
            Uint8List.fromList(base64Decode(profileImage)),
          );
        }
      }
    } catch (e) {
      print("Error fetching profile image: $e");
    }

    // Return a placeholder image if no profile image is available
    return AssetImage('assets/icons/userrr.png');
  }
  late EmpProfileApiBloc _profileApiBloc;

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.setBool('isEmployee', false);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure?"),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
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
            ),
          ],
        );
      },
    );
  }

  EmpProfileRepository _profileRepository = EmpProfileRepository();
  String? profileImageUrl;
  @override
  void initState() {
    print("init in emp profile called");

    super.initState();
    // Initialize the BlocProvider when the page is created
    _initProfileBloc();
    fetchProfileData();
  }

  void updateProfileData() {
    initEmpMainPage.fetchProfileData();
  }

// Call updateProfileData whenever data changes in your profile.

  var initEmpMainPage = EmpMainPageState();

  Future<void> fetchProfileData() async {
    print("Now in fetch profile state");
    updateProfileData();
    try {
      final profileData = await _profileRepository.getData();
      if (profileData.isNotEmpty) {
        EmpProfileModel? empProfile = profileData.first;
        final profileImage = empProfile.profilePic;
        GlobalObjects.empId = empProfile.empId;
        if (profileImage != null && profileImage.isNotEmpty) {
          setState(() {
            EmpProfileModel? empProfile = profileData.first;
            profileImageUrl = profileImage;
            GlobalObjects.empProfilePic = empProfile.profilePic;
            GlobalObjects.empName = empProfile.empName;
            GlobalObjects.empMail = empProfile.emailAddress;
            GlobalObjects.empId = empProfile.empId;
            print(GlobalObjects.empId);
          });
        }
        if (profileImage == null && profileImage.isEmpty) {
          setState(() {
            GlobalObjects.empProfilePic = null;
          });
        }
        // Update your UI with other profile data here
      }
    } catch (e) {
      print("Error fetching profile data: $e");
    }
  }

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

  // Method to initialize the BlocProvider
  void _initProfileBloc() {
    _profileApiBloc = EmpProfileApiBloc(
      RepositoryProvider.of<EmpProfileRepository>(context),
    )..add(EmpProfileLoadingEvent());
  }

  void refreshUserData() {
    print("Now in state of refresh User data");
    // Dispatch an event to fetch new data from the API
    _profileApiBloc.add(EmpProfileLoadingEvent());
    if (widget.onRefreshData != null) {
      widget.onRefreshData!();
    }
  }
  void call(String number) => launch("tel:$number");
  void sendSms(String number) => launch("sms:$number");
  void sendEmail(String email) => launch("mailto:$email");

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return _profileApiBloc;
      },
      child: BlocBuilder<EmpProfileApiBloc, EmpProfileApiState>(
        builder: (context, state) {
          if (state is EmpProfileLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmpProfileLoadedState) {

            List<EmpProfileModel> userList = state.users;
            final employeeProfile = userList[0];
            return FutureBuilder(
              future: fetchProfileImage(),
              builder: (context,snapshot) {
                if(snapshot.connectionState ==ConnectionState.done) {
                  return Scaffold(
                    backgroundColor: Colors.white,
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            0, MediaQuery
                            .of(context)
                            .size
                            .height / 15, 0, 0),
                        child: Column(
                          children: [
                            //ASK WETHER TO EXIT APP OR NOT
                            WillPopScope(
                              onWillPop: () async {
                                return _onBackPressed(context)
                                    .then((value) => value ?? false);
                              },
                              child: const SizedBox(),
                            ),
                            const SizedBox(
                              height: 30,
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
                                          key: _profileImageKey, // Use the unique key
                                          radius: 70.0,
                                          backgroundImage: snapshot.data,
                                        ),
                                        const SizedBox(
                                            width:
                                            20),
                                        // Add spacing between the picture and text
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              employeeProfile.empName,
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
                                              "${employeeProfile.emailAddress}",
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
                                              "Join Date: ${DateFormat(
                                                  'dd MMM yy').format(
                                                  employeeProfile.dateofJoin)}",
                                              style: GoogleFonts.montserrat(
                                                textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 16,
                                                  // Increase font size
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
                                        top: 20.0,
                                        bottom:
                                        20.0),
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
                                              icon: const Icon(
                                                  FontAwesomeIcons.phone,
                                                  color: Colors.white),
                                              onPressed: () {
                                                call(employeeProfile.phoneNo);
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
                                                  sendEmail(employeeProfile.emailAddress);
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
                                                sendSms(employeeProfile.phoneNo);
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
                            const SizedBox(height: 20),

                            _buildTileWidget(
                              title: 'Edit Profile',
                              icon: FontAwesomeIcons.pencil,
                              onTap: () async {
                                // Navigate to EmpEditProfilePage and pass the refreshData callback
                                await Navigator.push(
                                  context,
                                  PageTransition(
                                    child: const EmpEditProfilePage(),
                                    type: PageTransitionType.rightToLeft,
                                  ),
                                );
                                fetchProfileData();
                                refreshUserData();
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
                    ),
                  );
                }
                else
                  {
                    return const Center(child: CircularProgressIndicator());
                  }
              }
            );
          } else if (state is EmpProfileErrorState) {
            return Center(
              child: Text(
                "Error: ${state.message}",
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 18.0,
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
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
