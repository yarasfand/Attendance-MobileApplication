import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../login/bloc/loginBloc/loginbloc.dart';
import '../../../login/screens/loginPage.dart';
import '../bloc/emProfileApiFiles/emp_profile_api_bloc.dart';
import '../models/empProfileModel.dart';
import '../models/empProfileRepository.dart';
import 'EditProfile_page.dart';

class EmpProfilePage extends StatefulWidget {
  EmpProfilePage({
    super.key,
  });

  @override
  State<EmpProfilePage> createState() => _EmpProfilePageState();
}

class _EmpProfilePageState extends State<EmpProfilePage> {
  late EmpProfileApiBloc _profileApiBloc;
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
          ); // Navigate back to LoginPage
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize the BlocProvider when the page is created
    _initProfileBloc();
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
  }

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
            Widget _buildRefreshButton() {
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: refreshUserData,
              );
            }

            List<EmpProfileModel> userList = state.users;
            final employeeProfile = userList[0];
            return Scaffold(
              backgroundColor: AppColors.offWhite,
              body: SingleChildScrollView(
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
                      margin: const EdgeInsets.all(20.0),
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
                                  radius:
                                      70.0, // Increase the radius to make it larger
                                  backgroundImage: employeeProfile.profilePic !=
                                              null &&
                                          employeeProfile.profilePic.isNotEmpty
                                      ? Image.memory(
                                          Uint8List.fromList(base64Decode(
                                              employeeProfile.profilePic)),
                                        ).image
                                      : const AssetImage(
                                          'assets/icons/userr.png'),
                                ),
                                const SizedBox(
                                    width:
                                        20), // Add spacing between the picture and text
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      employeeProfile.empName,
                                      style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20, // Increase font size
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
                                          fontSize: 16, // Increase font size
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Join Date: ${DateFormat('dd MMM yy').format(employeeProfile.dateofJoin)}",
                                      style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16, // Increase font size
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
                                    20.0), // Add margin from the top and bottom
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
                                        // Add your call functionality here
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
                                        // Add your call functionality here
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

                    const Divider(
                      color: Colors.grey,
                      height: 2,
                      thickness: 1,
                    ),
                    // Menu
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
                        refreshUserData();
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    _buildTileWidget(
                      title: 'Logout',
                      icon: Icons.logout,
                      onTap: () => _logout(context),
                    ),
                  ],
                ),
              ),
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
          child: Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.red,
                ),
                const SizedBox(width: 20),
                Text(
                  title,
                  style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0, // Increase the font size
                      color: Colors.black, // Change the text color
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
