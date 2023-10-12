import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/MonthlyReports_repository.dart';

class MonthlyReportsPage extends StatefulWidget {
  @override
  State<MonthlyReportsPage> createState() => _MonthlyReportsPageState();
}

class _MonthlyReportsPageState extends State<MonthlyReportsPage> {
  int selectedMonth = DateTime.now().month; // Default to current month

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Reports'),
      ),
      body: Column(
        children: [
          DropdownButton<int>(
            value: selectedMonth,
            onChanged: (int? newValue) {
              if (newValue != null) {
                _onMonthSelected(newValue);
              }
            },
            items: List<DropdownMenuItem<int>>.generate(12, (int index) {
              return DropdownMenuItem<int>(
                value: index + 1,
                child: Text('${index + 1}'),
              );
            }),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              // Replace with your API call using the MonthlyReportsRepository
              future: fetchMonthlyReportsData(selectedMonth: selectedMonth),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While data is being fetched, show a loading indicator
                  return CustomLoadingIndicator();
                } else if (snapshot.hasError) {
                  // If there's an error, display an error message
                  return Center(child: Text('Error: ${snapshot.error.toString()}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // Handle the case when there is no data to display
                  return Center(child: Text('No monthly reports available.'));
                } else {
                  // If data has been successfully fetched, display it
                  final monthlyReports = snapshot.data!;
                  return MonthlyReportsListView(monthlyReports: monthlyReports);
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
      final mappedReports = reportsData.map((report) =>
      {
        'shiftstarttime': report.shiftStartTime,
        'shiftendtime': report.shiftEndTime,
        // Add other fields as needed
      }).toList();

      return mappedReports;
    } catch (e) {
      throw e; // You can handle errors as needed
    }
  }
}

// monthly_reports_list_view.dart

class MonthlyReportsListView extends StatelessWidget {
  final List<Map<String, dynamic>> monthlyReports;

  MonthlyReportsListView({required this.monthlyReports});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: monthlyReports.length,
      itemBuilder: (context, index) {
        final report = monthlyReports[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            title: Text("Shift Start Time: ${report['shiftstarttime']}"),
            subtitle: Text("Shift End Time: ${report['shiftendtime']}"),
            // Add other fields you want to display
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
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Customize the color
        ),
      ),
    );
  }
}
