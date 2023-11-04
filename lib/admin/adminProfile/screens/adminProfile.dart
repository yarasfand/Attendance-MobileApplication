import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:project/constants/AppBar_constant.dart';
import '../../../constants/constants.dart';
import '../../../introduction/bloc/bloc_internet/internet_bloc.dart';
import '../../../introduction/bloc/bloc_internet/internet_state.dart';
import '../../adminDashboard/bloc/admin_api_bloc.dart';
import '../../adminDashboard/models/adminModel.dart';
import '../../adminDashboard/models/adminRepository.dart';

class AdminViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetBloc, InternetStates>(
      listener: (context, state) {
        // TODO: Implement listener for InternetBloc if needed
      },
      builder: (context, internetState) {
        return BlocProvider(
          create: (context) {
            return AdminApiBloc(
              RepositoryProvider.of<AdminRepository>(context),
            )..add(AdminApiLoadingEvent());
          },
          child: BlocBuilder<AdminApiBloc, AdminApiState>(
            builder: (context, adminState) {
              if (internetState is InternetGainedState) {
                if (adminState is AdminApiLoadedState) {
                  List<AdminModel> userList = adminState.users;
                  final employee = userList[0];
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: AdminkbackgrounColorAppBar,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      title: const Text(
                        "My Profile",
                        style: AppBarStyles.appBarTextStyle,
                      ),
                      centerTitle: true,
                      iconTheme: const IconThemeData(
                        color: Colors.white,
                      ),
                    ),
                    body: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          const Center(
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage:
                                  AssetImage('assets/icons/man.png'),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "${employee.userName}",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE26142),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: const Text(
                              "Software Engineer",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Joined: August 21, 2023",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: 300,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding:
                                const EdgeInsets.all(10), // Reduced padding
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                  50), // Larger radius for the card
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  radius:
                                      20, // Smaller radius for the circle avatars
                                  backgroundColor: Colors.blue,
                                  child: Icon(Icons.mail,
                                      size: 25, color: Colors.white),
                                ),
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.green,
                                  child: Icon(Icons.call,
                                      size: 25, color: Colors.white),
                                ),
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.orange,
                                  child: Icon(Icons.message,
                                      size: 25, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Pioneer Times",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Attendance Status",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Divider(),
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Date"),
                                      Text("Present"),
                                      Text("Absent"),
                                    ],
                                  ),
                                  const Divider(),
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("1"),
                                      Text("15"),
                                      Text("2"),
                                    ],
                                  ),
                                  const Divider(),
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("2"),
                                      Text("18"),
                                      Text("0"),
                                    ],
                                  ),
                                  // Add more rows with attendance details here
                                  const SizedBox(height: 20),
                                  CircularPercentIndicator(
                                    radius: 70,
                                    lineWidth: 8,
                                    percent:
                                        0.85, // Example value, replace with actual attendance percentage
                                    center: const Text(
                                      "85%", // Example value, replace with actual attendance percentage
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    progressColor: Colors.blue,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Attendance Percentage",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (adminState is AdminApiErrorState) {
                  // Handle error state for AdminApiBloc if needed
                  return Text("Admin API Error: ${adminState.message}");
                }
              }
              else if (internetState is InternetLostState) {
                // Handle InternetLostState if needed
                return Scaffold(
                  body: Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "No Internet Connection!",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Lottie.asset('assets/no_wifi.json'),
                        ],
                      ),
                    ),
                  ),
                );
              }
              // Default state when no data is loaded yet
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
