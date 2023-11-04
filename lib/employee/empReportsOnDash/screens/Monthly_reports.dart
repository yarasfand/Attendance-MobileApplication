import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project/constants/AppBar_constant.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/MonthlyReports_repository.dart';

class MonthlyReportsPage extends StatefulWidget {
  @override
  State<MonthlyReportsPage> createState() => _MonthlyReportsPageState();
}

class _MonthlyReportsPageState extends State<MonthlyReportsPage> {
  int selectedMonth = DateTime.now().month; // Default to current month

  // Declare monthNames here
  List<String> monthNames = [
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
  @override
  void initState() {
    super.initState();
    loadSelectedMonth(); // Load the selected month from shared preferences
  }

  Future<void> loadSelectedMonth() async {
    final prefs = await SharedPreferences.getInstance();
    final storedMonth = prefs.getInt('selectedMonth');

    if (storedMonth != null) {
      setState(() {
        selectedMonth = storedMonth;
      });
    }
  }

  Future<void> _onMonthSelected(int month) async {
    // Save the selected month to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedMonth', month);

    // Trigger API call with the new selected month
    setState(() {
      selectedMonth = month;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> monthNames = [
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
    return Scaffold(
      backgroundColor: AppColors.brightWhite,
      appBar: AppBar(
        title: const Text(
          'Monthly Reports',
          style: AppBarStyles.appBarTextStyle,
        ),
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: monthNames[selectedMonth - 1], // Adjust for 0-based index
            onChanged: (String? newValue) {
              if (newValue != null) {
                int monthIndex = monthNames.indexOf(newValue) + 1;
                _onMonthSelected(monthIndex);
              }
            },
            items: monthNames.map((String month) {
              return DropdownMenuItem<String>(
                value: month,
                child: Text(month),
              );
            }).toList(),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              // Replace with your API call using the MonthlyReportsRepository
              future: fetchMonthlyReportsData(selectedMonth: selectedMonth),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CustomLoadingIndicator();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error.toString()}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No monthly reports available.'));
                } else {
                  // If data has been successfully fetched, display it
                  final monthlyReports = snapshot.data!;
                  return MonthlyReportsListView(
                    monthlyReports: monthlyReports,
                    selectedMonth: selectedMonth, // Pass selectedMonth here
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Replace this function with your actual API call using the MonthlyReportsRepository
  Future<List<Map<String, dynamic>>> fetchMonthlyReportsData({
    required int selectedMonth,
  }) async {
    final repository = MonthlyReportsRepository();

    try {
      // Retrieve corporateId and employeeId from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final corporateId = prefs.getString('corporate_id') ?? '';
      final employeeId = prefs.getInt('employee_id') ?? 0;

      final reportsData = await repository.getMonthlyReports(
        corporateId: corporateId,
        employeeId: employeeId,
        month: selectedMonth,
      );

      // Map MonthlyReportsModel objects to the desired format
      final mappedReports = reportsData
          .map((report) => {
                'shiftstarttime': report.shiftStartTime,
                'shiftendtime': report.shiftEndTime,
                'status': report.status,
                'hoursworked': report.hoursWorked,
                'in1': report.in1,
                'out2': report.out2,
                // Add other fields as needed
              })
          .toList();

      return mappedReports;
    } catch (e) {
      throw e; // You can handle errors as needed
    }
  }
}

// monthly_reports_list_view.dart

class MonthlyReportsListView extends StatelessWidget {
  final List<Map<String, dynamic>> monthlyReports;
  final int selectedMonth;

  // Declare monthNames here
  List<String> monthNames = [
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

  MonthlyReportsListView({
    required this.monthlyReports,
    required this.selectedMonth,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: monthlyReports.length,
      itemBuilder: (context, index) {
        final report = monthlyReports[index];
        final shiftStartTime = report['shiftstarttime'];
        final shiftEndTime = report['shiftendtime'];
        final status = report['status'];
        final hoursWorked = report['hoursworked'];
        final inTime = report['in1'];
        final outTime = report['out2'];

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
                      padding: const EdgeInsets.only(left: 16.0),
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
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        "${shiftStartTime != null ? DateFormat('hh:mm dd/MM/yyyy').format(DateTime.parse(shiftStartTime)) : '---'}",

                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "${inTime != null ? DateFormat('hh:mm').format(DateTime.parse(inTime)) : '---'}",
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
                      padding: const EdgeInsets.only(left: 16.0),
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
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        "${shiftEndTime != null ? DateFormat('hh:mm dd/MM/yyyy').format(DateTime.parse(shiftEndTime)) : '---'}",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "${outTime != null ? DateFormat('hh:mm').format(DateTime.parse(outTime)) : '---'}",
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
                        "Worked: ${hoursWorked}",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Row(
                      children: [
                        SizedBox(width: 60,),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green, // Status color
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "Status: ${status != null ? (status.length > 15 ? status.substring(0, 15) + '...' : status) : '---'}",
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
  }
}

class CustomLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 30.0, // Customize the size as needed
        height: 30.0, // Customize the size as needed
        child: CircularProgressIndicator(
          strokeWidth: 3.0, // Customize the thickness of the circle
          valueColor:
              AlwaysStoppedAnimation<Color>(Colors.blue), // Customize the color
        ),
      ),
    );
  }
}
