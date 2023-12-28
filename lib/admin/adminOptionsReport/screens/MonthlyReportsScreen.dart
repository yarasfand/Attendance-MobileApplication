import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
  int? selectedMonth = 1; // Initialize with a default value
  String corporateId = "ptsoffice";


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
    final adminMonthlyReportsBloc =
        BlocProvider.of<AdminMonthlyReportsBloc>(context);

    if (corporateId != null) {
      final effectiveMonth = selectedMonth ?? 1;

      adminMonthlyReportsBloc.add(FetchAdminMonthlyReports(
        employeeIds: widget.selectedEmployeeIds,
        corporateId: corporateId,
        employeeId: 1,
        selectedMonth: effectiveMonth,
      ));
    }
  }

  final List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  bool isInternetLost = false;

  @override
  Widget build(BuildContext context) {
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
        if (state is InternetGainedState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Monthly Reports',
                style: AppBarStyles.appBarTextStyle,
              ),
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
                    final monthIndex = index + 1;
                    print(monthIndex);
                    final monthName = monthNames[monthIndex - 1];
                    return DropdownMenuItem<int>(
                      value: monthIndex,
                      child: Text(monthName),
                    );
                  }),
                  onChanged: (int? value) {
                    setState(() {
                      selectedMonth = value;
                      fetchMonthlyReports();
                    });
                  },
                ),
                Expanded(
                  child: BlocBuilder<AdminMonthlyReportsBloc,
                      AdminMonthlyReportsState>(
                    builder: (context, state) {
                      if (state is AdminMonthlyReportsLoading) {
                        print("In Loading state");
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
                              margin: EdgeInsets.all(16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              elevation: 5,
                              child: Table(
                                children: [
                                  TableRow(
                                    children: [
                                      TableCell(child: Padding(
                                        padding: const EdgeInsets.only(top:8.0,left: 16.0),
                                        child: Text("ID: ${report.empId}",style: GoogleFonts.poppins(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),),
                                      )),
                                      TableCell(child: SizedBox()),

                                    ]
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            "Shift",
                                            style: GoogleFonts.poppins(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 16.0,
                                          ),
                                          child: Text(
                                            "Punch Time",
                                            style: GoogleFonts.poppins(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Text(
                                            "Start",
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          "In",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Text(
                                            "${report.shiftStartTime != null ? DateFormat('hh:mm dd/MM/yyyy').format(report.shiftStartTime!) : '---'}",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          "${report.in1 != null ? DateFormat('hh:mm dd/MM/yyyy').format(report.in1!) : '---'}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Text(
                                            "End",
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          "Out",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Text(
                                            "${report.shiftEndTime != null ? DateFormat('hh:mm dd/MM/yyyy').format(report.shiftEndTime!) : '---'}",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          "${report.out2 != null ? DateFormat('hh:mm dd/MM/yyyy').format(report.out2!) : '---'}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            "Worked: ${report.hoursWorked}",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 60,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors
                                                    .green, // Status color
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              padding: EdgeInsets.all(8),
                                              child: Text(
                                                "Status: ${report.status != null ? (report.status.length > 15 ? report.status.substring(0, 15) + '...' : report.status) : '---'}",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
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
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
