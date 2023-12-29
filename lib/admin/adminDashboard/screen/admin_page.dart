import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../introduction/bloc/bloc_internet/internet_bloc.dart';
import '../../../introduction/bloc/bloc_internet/internet_state.dart';
import '../models/AdminDashBoard_model.dart';
import '../models/AdminDashBoard_repository.dart';
import 'adminMyFiles.dart';
import 'adminOptions_detail.dart';
import 'adminResponsive.dart';
import 'admin_data.dart';
import 'adminconstants.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now(); // Initialize with the current date
  final adminDashboardRepository = AdminDashboardRepository(
      'http://62.171.184.216:9595'); // Replace with your API base URL
  AdminDashBoard? adminData;
  @override
  void initState() {
    super.initState();
    // Load API data when the page is first loaded
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final corporateId = prefs.getString('corporate_id') ?? '';
    try {
      final adminDashboardData = await adminDashboardRepository
          .fetchDashboardData(selectedDate);
      setState(() {
        adminData = adminDashboardData;
      });
    } catch (e) {
      // Handle errors here
      print('Error fetching data: $e');
    }
  }

  // Function to update the selected date and fetch data
  Future<void> _updateSelectedDate(DateTime newDate) async {
    setState(() {
      selectedDate = newDate;
    });
    // Fetch data based on the new selected date and corporate ID here
    final prefs = await SharedPreferences.getInstance();
    final corporateId = prefs.getString('corporate_id') ?? '';
    _fetchDataForSelectedDate(selectedDate, corporateId);
  }

  // Function to fetch data based on the selected date and corporate ID
  void _fetchDataForSelectedDate(DateTime date, String corporateId) async {
    try {
      final adminDashboardData =
          await adminDashboardRepository.fetchDashboardData(date);
      // Update the UI with the fetched data
      setState(() {
        adminData =
            adminDashboardData; // Assuming you have a variable adminData in your widget state
      });
    } catch (e) {
      // Handle errors here
      print('Error fetching data: $e');
    }
  }

  Future<void> _openDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      _updateSelectedDate(picked);
    }
  }

  Future<bool?> _onBackPressed(BuildContext context) async {
    bool? exitConfirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Exit'),
        content: Text('Are you sure you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Yes'),
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

  @override
  Widget build(BuildContext context) {
    List<AdminCloudStorageInfo> demoMyFiles = createDemoMyFiles(adminData);
    return BlocBuilder<InternetBloc, InternetStates>(
      builder: (context, state) {
        if (state is InternetGainedState) {
          return Scaffold(
            key: _scaffoldKey,
            body: SingleChildScrollView(
              primary: false,
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  // TO ASK WANT TO GO BACK OR NOT
                  WillPopScope(
                    onWillPop: () async {
                      return _onBackPressed(context)
                          .then((value) => value ?? false);
                    },
                    child: const SizedBox(),
                  ),
                  const SizedBox(height: defaultPadding),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    final newDate = selectedDate
                                        .subtract(const Duration(days: 1));
                                    _updateSelectedDate(newDate);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: AppColors.black,
                                  ),
                                ),
                                GestureDetector(
                                  onTap:
                                      _openDatePicker, // Open the date picker when tapped
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateFormat('d MMM yyyy').format(selectedDate),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        DateFormat(' (EEEE)').format(selectedDate),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16, // Adjust the font size for day name here
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),

                                ),
                                IconButton(
                                  onPressed: () {
                                    final newDate = selectedDate
                                        .add(const Duration(days: 1));
                                    _updateSelectedDate(newDate);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppColors.black,
                                  ),
                                ),
                              ],
                            ),

                            // Inside your build method
                            AdminData(
                              adminData: adminData ??
                                  AdminDashBoard(
                                    presentCount: 0,
                                    absentCount: 0,
                                    lateCount: 0,
                                    totalEmployeeCount: 0,
                                  ),
                              demoMyFiles: demoMyFiles, // Pass demoMyFiles here
                              totalEmployees:
                                  adminData?.totalEmployeeCount ?? 0,
                              presentEmployees: adminData?.presentCount ?? 0,
                              absentEmployees: adminData?.absentCount ?? 0,
                              lateEmployees: adminData?.lateCount ?? 0,
                            ),

                            const SizedBox(height: defaultPadding),
                            if (AdminResponsive.isMobile(context))
                              const AdminStorageDetails(),
                            const SizedBox(height: defaultPadding),
                            if (AdminResponsive.isMobile(context))
                               Column(
                                children: [
                                  // Text(
                                  //   "POWERED BY: PIONEER 2023",
                                  //   style: TextStyle(
                                  //       color: Colors.black, fontSize: 10),
                                  // ),
                                  SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Image.asset('assets/images/pioneer_logo_app.png')),
                                ],
                              ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        } else if (state is InternetLostState) {
          return Expanded(
            child: Scaffold(
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
            ),
          );
        }
        else {
          return Expanded(
            child: Scaffold(
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
            ),
          );
        }
      },
    );
  }
}
