import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/constants/AppColor_constants.dart';
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

  @override
  void initState() {
    super.initState();
    // Initialize the BlocProvider when the page is created
    _initProfileBloc();
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
                    const SizedBox(
                      height: 30,
                    ),
                    Card(
                      color: AppColors.lightBlue,
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
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius:
                                      70.0, // Increase the radius to make it larger
                                  backgroundImage:
                                      AssetImage('assets/icons/man.png'),
                                ),
                                const SizedBox(
                                    width:
                                        20), // Add spacing between the picture and text
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width:150,
                                      child: Text(
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
                                    ),
                                    Text(
                                      "Code: ${employeeProfile.empCode}",
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
                                IconButton(
                                  icon: const Icon(FontAwesomeIcons.phone,
                                      color: Colors.white),
                                  onPressed: () {
                                    // Add your call functionality here
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(FontAwesomeIcons.envelope,
                                      color: Colors.white),
                                  onPressed: () {
                                    // Add your mail functionality here
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    FontAwesomeIcons.comment,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    // Add your message functionality here
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          // Use a gradient background for more colors
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.lightBlue,
                            AppColors.secondaryColor
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildField("Name", employeeProfile.empName),
                          _buildField("Email", employeeProfile.emailAddress),
                          _buildField("Shift Code", employeeProfile.shiftCode),
                          _buildField(
                            "Join Date",
                            DateFormat('MMMM d, y')
                                .format(employeeProfile.dateofJoin),
                          ),
                          _buildField("Emp Code", employeeProfile.empCode),
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
                      icon: Icons.supervised_user_circle_sharp,
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

                    _buildTileWidget(
                      title: 'Information',
                      icon: Icons.info_outline,
                    ),
                    _buildTileWidget(
                      title: 'Logout',
                      icon: Icons.logout,
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
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.navyBlue,
        ),
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(
        title,
        style: GoogleFonts.raleway(
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ),
      trailing: const Icon(Icons.navigate_next),
    );
  }
}
