import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../Backend/EmployeeApi/EmployeeModels/EmployeeProfileModel.dart';
import '../../../Backend/EmployeeApi/EmployeeProfileApiFiles/EmployeeProfileApiBloc.dart';
import '../../../Backend/EmployeeApi/EmployeeRespository/EmployeeProfileRepository.dart';
import '../../../Controller/EmployeepProfileBloc/EmployeeProfileBloc.dart';


class EmpProfilePage extends StatefulWidget {
  final VoidCallback openDrawer;

  EmpProfilePage({super.key, required this.openDrawer,});

  @override
  State<EmpProfilePage> createState() => _EmpProfilePageState();
}

class _EmpProfilePageState extends State<EmpProfilePage> {

  final EmpProfileBloc homeBloc = EmpProfileBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return EmpProfileApiBloc(
          RepositoryProvider.of<EmpProfileRepository>(context),
        )
          ..add(EmpProfileLoadingEvent());
      },
      child: BlocBuilder<EmpProfileApiBloc, EmpProfileApiState>(
        builder: (context, state) {

          if (state is EmpProfileLoadingState)
            {
              return const Center(child: CircularProgressIndicator());

            }
          else if(state is EmpProfileLoadedState)
            {
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
                  title:  Text(
                    "ATTENDANCE",
                    style: TextStyle(color: Colors.white),
                  ),
                  centerTitle: true,
                ),
                body:SingleChildScrollView(
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
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(10), // Adjust the padding for the grid
                            child: GridView(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10.0, // Reduce the spacing horizontally
                                mainAxisSpacing: 10.0, // Reduce the spacing vertically
                              ),
                              shrinkWrap: true, // Make it scrollable
                              children: [
                                _buildField("Name", employeeProfile.empName),
                                _buildField("Email", employeeProfile.emailAddress),
                                _buildField("Shift Code", employeeProfile.shiftCode),
                                _buildField("Date of Join", employeeProfile.dateofJoin.toString()), // You may need to format this date
                                _buildField("Employee Code", employeeProfile.empCode),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Divider(
                          color: Colors.grey,
                          height: 2,
                          thickness: 1,
                        ),
                        // Menu
                        const tileWidget(title: 'Settings', icon: Icons.settings),
                        const tileWidget(
                          title: 'User Management',
                          icon: Icons.supervised_user_circle_sharp,
                        ),
                        const Divider(
                          color: Colors.grey,
                          height: 30,
                          thickness: 1,
                        ),
                        const tileWidget(title: 'Information', icon: Icons.info_outline),
                        const tileWidget(title: 'Logout', icon: Icons.logout),
                      ],
                    ),
                  ),
                )

              );
            }
          else if(state is EmpProfileErrorState)
            {
              return Center(
                child: Text("Error: ${state.message}"),
              );
            }
          else
          {
            return const Center(child: CircularProgressIndicator());
          }

        },
      ),
    );
  }
}

Widget _buildField(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 15,
        ),
      ),
      Text(
      value.isNotEmpty ? value : "---",
        style: GoogleFonts.montserrat(
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Colors.blue,
            fontFamily: 'Cabin',
          ),
        ),
      ),
    ],
  );
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
