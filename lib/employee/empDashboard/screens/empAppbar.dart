import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:project/employee/empDashboard/models/user_model.dart';
import 'package:project/employee/empDashboard/screens/generalAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../introduction/utilities/api_integration_files/api_intigration_bloc.dart';
import '../models/user_repository.dart';

class EmpAppBar extends StatelessWidget {

  final String pageHeading;
  const EmpAppBar({
    Key? key,
    required this.pageHeading,
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
          final role = sharedPrefEmp.getString('role') ?? 'employee';

          return BlocProvider(
            create: (context) {
              return ApiIntigrationBloc(
                RepositoryProvider.of<UserRepository>(context),
              )..add(ApiLoadingEvent(
                  corporateId: corporateId,
                  username: username,
                  password: password,
                  role: role));
            },
            child: BlocBuilder<ApiIntigrationBloc, ApiIntigrationState>(
              builder: (context, state) {
                if (state is ApiLoadedState) {
                  List<Employee> userList = state.users;
                  final employee = userList.isNotEmpty ? userList[0] : null;
                  return GenAppBar(pageHeading: pageHeading,);

                } else if (state is ApiLoadingState) {
                  // Loading state, display a loading indicator
                  return AppBar(
                    leading: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.bars),
                      color: Colors.white,
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    backgroundColor: AppColors.primaryColor,
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
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    backgroundColor: AppColors.primaryColor,
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
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    backgroundColor: AppColors.darkGrey,
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
          return const CircularProgressIndicator(); // Replace with your loading indicator widget
        }
      },
    );
  }

  Future<SharedPreferences> getShared() async {
    final sharedPrefEmp = await SharedPreferences.getInstance();
    return sharedPrefEmp;
  }
}
