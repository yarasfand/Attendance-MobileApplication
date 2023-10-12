import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import '../bloc/emProfileApiFiles/emp_profile_api_bloc.dart';
import '../models/empProfileModel.dart';
import '../models/empProfileRepository.dart';
import 'EditProfile_page.dart';


class EmpProfilePage extends StatefulWidget {
  final VoidCallback openDrawer;

  EmpProfilePage({
    super.key,
    required this.openDrawer,
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
                icon: Icon(Icons.refresh),
                onPressed: refreshUserData,
              );
            }
            List<EmpProfileModel> userList = state.users;
            final employeeProfile = userList[0];
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const FaIcon(FontAwesomeIcons.bars),
                  color: Colors.white,
                  onPressed: widget.openDrawer,
                ),
                backgroundColor: const Color(0xFFE26142),
                elevation: 0,
                title: Text(
                  "EMPLOYEE PROFILE",
                  style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                centerTitle: true,
                actions: [
                  _buildRefreshButton(),
                ],
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          const SizedBox(
                            width: 150,
                            height: 150,
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/icons/man.png'),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20), // Increased vertical padding
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            // Use a gradient background for more colors
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.purple, Colors.deepPurple],
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
                            _buildField(
                                "Shift Code", employeeProfile.shiftCode),
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
                              child: EmpEditProfilePage(),
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
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.amber,
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
