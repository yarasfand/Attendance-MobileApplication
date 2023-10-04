import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Backend/ApiIntegrationFiles/ApiIntegrationBloc.dart';
import '../../../Backend/EmployeeApi/EmployeeModels/EmployeeUserModel.dart';
import '../../../Backend/EmployeeApi/EmployeeRespository/EmployeeUserRepository.dart';

class EmpAppBar extends StatelessWidget {
  final VoidCallback openDrawer;

  const EmpAppBar({
    Key? key,
    required this.openDrawer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: getShared(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Data from shared preferences is available, create the bloc
          final sharedPrefEmp = snapshot.data as SharedPreferences;
          final corporateId = sharedPrefEmp.getString('corporate_id')!;
          final username = sharedPrefEmp.getString('user_name')!;
          final password = sharedPrefEmp.getString('password')!;

          return BlocProvider(
            create: (context) {
              return ApiIntigrationBloc(
                RepositoryProvider.of<UserRepository>(context),
              )..add(ApiLoadingEvent(
                  corporateId: corporateId,
                  username: username,
                  password: password));
            },
            child: BlocBuilder<ApiIntigrationBloc, ApiIntigrationState>(
              builder: (context, state) {
                if (state is ApiLoadedState) {
                  List<Employee> userList = state.users;
                  final employee = userList.isNotEmpty ? userList[0] : null;

                  return AppBar(
                    leading: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.bars),
                      color: Colors.white,
                      onPressed: openDrawer,
                    ),
                    backgroundColor: const Color(0xFFE26142),
                    elevation: 0,
                    title: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 55.0), // Add right padding
                        child: Text(
                          "EMP-ID: ${employee!.empCode.toString()}",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (state is ApiLoadingState) {
                  // Loading state, display a loading indicator
                  return AppBar(
                    leading: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.bars),
                      color: Colors.white,
                      onPressed: openDrawer,
                    ),
                    backgroundColor: const Color(0xFFE26142),
                    elevation: 0,
                    title: const Center(
                      child: Padding(
                        padding:
                            EdgeInsets.only(right: 55.0), // Add right padding
                        child: SizedBox(
                            height: 5,
                            width: 5,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                            )), // Loading indicator
                      ),
                    ),
                  );
                } else if (state is ApiErrorState) {
                  // Handle error state, display an error message
                  return AppBar(
                    leading: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.bars),
                      color: Colors.white,
                      onPressed: openDrawer,
                    ),
                    backgroundColor: const Color(0xFFE26142),
                    elevation: 0,
                    title: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 55.0), // Add right padding
                        child: Text(
                          "Error: ${state.message}",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return AppBar(
                    leading: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.bars),
                      color: Colors.white,
                      onPressed: openDrawer,
                    ),
                    backgroundColor: const Color(0xFFE26142),
                    elevation: 0,
                    title: const Center(
                      child: Padding(
                        padding:
                            EdgeInsets.only(right: 55.0), // Add right padding
                        child: Text(
                          "Default UI",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          );
        } else {
          // Data is still being fetched from shared preferences, you can show a loading indicator here
          return CircularProgressIndicator(); // Replace with your loading indicator widget
        }
      },
    );
  }

  Future<SharedPreferences> getShared() async {
    final sharedPrefEmp = await SharedPreferences.getInstance();
    return sharedPrefEmp;
  }
}
