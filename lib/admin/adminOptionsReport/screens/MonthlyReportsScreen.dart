import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/constants/AppBar_constant.dart';
import 'package:project/introduction/bloc/bloc_internet/internet_bloc.dart';
import 'package:project/introduction/bloc/bloc_internet/internet_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../No_internet/no_internet.dart';
import '../adminOptions_bloc/admin_monthly_reports_bloc.dart';
import '../adminOptions_bloc/admin_monthly_reports_event.dart';
import '../adminOptions_bloc/admin_monthly_reports_state.dart';

class MonthlyReportsScreen extends StatefulWidget {
  final List<int> selectedEmployeeIds;

  MonthlyReportsScreen({required this.selectedEmployeeIds});

  @override
  State<MonthlyReportsScreen> createState() => _MonthlyReportsScreenState();
}

class _MonthlyReportsScreenState extends State<MonthlyReportsScreen> {
  int? selectedMonth; // Store the selected month
  String corporateId="ptsoffice";

  @override
  void initState() {
    super.initState();
    fetchCorporateIdFromSharedPrefs();
    // Fetch the reports when this screen is initialized
    fetchMonthlyReports();
  }
  void fetchCorporateIdFromSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    corporateId = prefs.getString('corporate_id') ?? "ptsoffice";
  }
  void fetchMonthlyReports() {
    // Get the adminMonthlyReportsBloc from the context
    final adminMonthlyReportsBloc =
        BlocProvider.of<AdminMonthlyReportsBloc>(context);

    if (selectedMonth != null && corporateId != null) {
      // Dispatch the FetchAdminMonthlyReports event with the selectedEmployeeIds
      adminMonthlyReportsBloc.add(FetchAdminMonthlyReports(
        employeeIds: widget.selectedEmployeeIds,
        corporateId: corporateId,
        employeeId: 1,
        selectedMonth: selectedMonth ?? 1, // Directly use the local variable
      ));
    } else {
      const Center(
        child: Text(
          "No Data Available",
          style: TextStyle(color: Colors.black),
        ),
      );
    }
  }
  bool isInternetLost = false;

  @override
  Widget build(BuildContext context) {
    final adminMonthlyReportsBloc =
        BlocProvider.of<AdminMonthlyReportsBloc>(context);

    return BlocConsumer<InternetBloc, InternetStates>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is InternetLostState) {
          // Set the flag to true when internet is lost
          isInternetLost = true;
          Future.delayed(Duration(seconds: 2), () {
            Navigator.push(
              context,
              PageTransition(
                child: NoInternet(),
                type: PageTransitionType.rightToLeft,
              ),
            );
          });
        } else if (state is InternetGainedState) {
          // Check if internet was previously lost
          if (isInternetLost) {
            // Navigate back to the original page when internet is regained
            Navigator.pop(context);
          }
          isInternetLost = false; // Reset the flag
        }
      },
      builder: (context, state) {
        if(state is InternetGainedState)
          {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Monthly Reports',style: AppBarStyles.appBarTextStyle,),
                centerTitle: true,
                iconTheme: IconThemeData(color: AppBarStyles.appBarIconColor),
                backgroundColor: AppBarStyles.appBarBackgroundColor,
              ),
              body: Column(
                children: [
                  DropdownButton<int>(
                    hint: const Text('Select Month'),
                    value: selectedMonth,
                    items: List.generate(12, (index) {
                      return DropdownMenuItem<int>(
                        value: index + 1, // Months are typically 1-based
                        child: Text('Month ${index + 1}'),
                      );
                    }),
                    onChanged: (int? value) {
                      setState(() {
                        selectedMonth = value; // Update the selected month
                        fetchMonthlyReports(); // Trigger data fetching on month change
                      });
                    },
                  ),
                  Expanded(
                    child: BlocBuilder<AdminMonthlyReportsBloc,
                        AdminMonthlyReportsState>(
                      builder: (context, state) {
                        if (state is AdminMonthlyReportsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is AdminMonthlyReportsLoaded) {
                          final reports = state.reports;

                          if (reports.isEmpty) {
                            // No data available
                            return const Center(
                              child: Text('No data available.'),
                            );
                          }

                          return ListView.builder(
                            itemCount: reports.length,
                            itemBuilder: (context, index) {
                              final report = reports[index];
                              return Card(
                                margin: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text(
                                    'Employee ID: ${report.empId}',
                                    style: GoogleFonts.openSans(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    children: [
                                      Text(
                                          'Shift Start Time: ${report.shiftStartTime}',
                                          style:
                                          GoogleFonts.openSans(fontSize: 16)),
                                      Text('Shift End Time: ${report.shiftEndTime}',
                                          style:
                                          GoogleFonts.openSans(fontSize: 16)),
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        alignment: Alignment.bottomRight,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors
                                                .blue, // Status capsule background color
                                            borderRadius: BorderRadius.circular(
                                                12.0), // Rounded corners
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 6.0),
                                          child: Text(
                                            'Status: ${report.status}',
                                            style: GoogleFonts.openSans(
                                                fontSize: 16, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (state is AdminMonthlyReportsError) {
                          return Center(
                            child: Text('Error: ${state.errorMessage}'),
                          );
                        } else {
                          // You can add a default view here
                          return const Center(
                            child: Text('No data available.'),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        else {
          return Scaffold(
            body: Center(
                child: CircularProgressIndicator()),
          );
        }

      },
    );
  }
}
