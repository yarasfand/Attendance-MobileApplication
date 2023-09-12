import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../profileBloc/profile_bloc.dart';
import '../viewProfile/viewProfile.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback openDrawer;
  ProfilePage({super.key, required this.openDrawer,});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final ProfileBloc homeBloc = ProfileBloc();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is NavigateToViewPageState,
      buildWhen: (previous, current) => current is! NavigateToViewPageState,
      listener: (context, state) {
        // TODO: implement listener

        if (state is NavigateToViewPageState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewPage(),
              ));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const FaIcon(FontAwesomeIcons.bars),
              color: Colors.white,
              onPressed: widget.openDrawer,
            ),
            backgroundColor: const Color(0xFFE26142),
            elevation: 0,
            title: const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 55.0), // Add right padding
                child: Text(
                  "ATTENDANCE",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(
                    width: 150,
                    height: 150,
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/icons/man.png'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "@Your Name",
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Cabin'),
                    ),
                  ),
                  Text(
                    "@Your Email/Username",
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Colors.amberAccent),
                    ),
                    onPressed: () {
                      homeBloc.add(NavigateToViewPageEvent());
                    },
                    child: const Text(
                      "View Profile",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 30,
                    thickness: 1,
                  ),
                  const SizedBox(height: 10),

                  // Menu
                  const tileWidget(title: 'Settings', icon: Icons.settings),
                  const tileWidget(
                      title: 'Billing Details', icon: Icons.payment),
                  const tileWidget(
                      title: 'User Management',
                      icon: Icons.supervised_user_circle_sharp),
                  const Divider(
                    color: Colors.grey,
                    height: 30,
                    thickness: 1,
                  ),
                  const tileWidget(
                      title: 'Information', icon: Icons.info_outline),
                  const tileWidget(title: 'Logout', icon: Icons.logout),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class tileWidget extends StatelessWidget {
  final String title;
  final IconData icon;

  const tileWidget({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(Icons.navigate_next),
    );
  }
}
