import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Backend/ApiIntegrationFiles/ApiIntegrationBloc.dart';
import '../../../Backend/EmployeeApi/EmployeeModels/EmployeeUserModel.dart';
import '../../../Backend/EmployeeApi/EmployeeRespository/EmployeeUserRepository.dart';

class EmpViewPage extends StatefulWidget {
  @override
  _EmpViewPageState createState() => _EmpViewPageState();
}

class _EmpViewPageState extends State<EmpViewPage> {
  late String username;
  late String corporateId;
  late String password;

  @override
  void initState() {
    super.initState();
    // Fetch data from shared preferences when the widget is initialized
    getShared();
  }

  Future<void> getShared() async {
    final sharedPrefEmp = await SharedPreferences.getInstance();
    setState(() {
      corporateId = sharedPrefEmp.getString('corporate_id')!;
      username = sharedPrefEmp.getString('user_name')!;
      password = sharedPrefEmp.getString('password')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ApiIntigrationBloc(
          RepositoryProvider.of<UserRepository>(context),
        )..add(ApiLoadingEvent(
            corporateId: corporateId, username: username, password: password));
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "My Profile",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<ApiIntigrationBloc, ApiIntigrationState>(
          builder: (context, state) {
            if (state is ApiLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ApiLoadedState) {
              List<Employee> userList = state.users;
              final employee = userList[0];
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Center(
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage('assets/icons/man.png'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${employee.empName}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      padding: const EdgeInsets.all(10),
                      // Reduced padding
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        // Larger radius for the card
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
                            radius: 20, // Smaller radius for the circle avatars
                            backgroundColor: Colors.blue,
                            child:
                            Icon(Icons.mail, size: 25, color: Colors.white),
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.green,
                            child:
                            Icon(Icons.call, size: 25, color: Colors.white),
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
                      "Company Name",
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Date"),
                                Text("Present"),
                                Text("Absent"),
                              ],
                            ),
                            const Divider(),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("1"),
                                Text("15"),
                                Text("2"),
                              ],
                            ),
                            const Divider(),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              percent: 0.85,
                              // Example value, replace with actual attendance percentage
                              center: const Text(
                                "85%",
                                // Example value, replace with actual attendance percentage
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              progressColor: Colors.blue,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Attendance Percentage",
                              style:
                              TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            if (state is ApiErrorState) {
              // Handle the error state
              return Center(
                child: Text("Error: ${state.message}"),
              );
            }
            // Add an additional return for other states if needed
            return const Center(child: Text("Empty"));
          },
        ),
      ),
    );
  }
}
