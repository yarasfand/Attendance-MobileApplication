import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api_intigration_files/MonthlyReports_apiFiles/monthly_reports_bloc.dart';

class MonthlyReportsPage extends StatefulWidget {
  const MonthlyReportsPage({Key? key}) : super(key: key);

  @override
  State<MonthlyReportsPage> createState() => _MonthlyReportsPageState();
}

class _MonthlyReportsPageState extends State<MonthlyReportsPage> {
  late int employeeId = 3;
  late String corporateId = "ptsoffice";
  int selectedMonth = DateTime.now().month; // Initialize with the current month

  @override
  void initState() {
    super.initState();
    loadSharedPrefs(); // Load shared preferences when the page initializes.
  }

  Future<void> loadSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      employeeId = prefs.getInt('employee_id') ?? 0;
      print(employeeId);
      corporateId = prefs.getString('corporate_id') ?? 'default_corporate_id';
      print(corporateId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthlyReportsBloc = BlocProvider.of<MonthlyReportsBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Reports'),
      ),
      body: Column(
        children: [
          DropdownButton<int>(
            value: selectedMonth,
            onChanged: (value) {
              setState(() {
                selectedMonth = value!;
                // Trigger data fetch with the selected month.
                monthlyReportsBloc.add(FetchMonthlyReports(
                  corporateId: corporateId,
                  employeeId: employeeId,
                  month: selectedMonth,
                ));
              });
            },
            items: List.generate(12, (index) {
              return DropdownMenuItem<int>(
                value: index + 1,
                child: Text('Month ${index + 1}'),
              );
            }),
          ),
          Expanded(
            child: BlocBuilder<MonthlyReportsBloc, MonthlyReportsState>(
              builder: (context, state) {
                if (state is MonthlyReportsInitial || state is MonthlyReportsLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is MonthlyReportsLoaded) {
                  final reports = state.reports;
                  if (reports.isNotEmpty) {
                    return ListView.builder(
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        final report = reports[index];
                        // Build your report item widget here.
                        return ListTile(
                          title: Text('Date: ${report.dateOffice}'),
                          // Add other report details.
                        );
                      },
                    );
                  } else {
                    return Text('No monthly reports available.');
                  }
                } else if (state is MonthlyReportsError) {
                  return Text('Error: ${state.error}');
                }
                return Container(); // Return an empty container by default.
              },
            ),
          ),
        ],
      ),
    );
  }
}
