import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/AdminDailyReportsModel.dart';
import '../models/AdminDailyReportsRepository.dart';

class DailyReportsScreen extends StatefulWidget {
  final List<int> selectedEmployeeIds;

  const DailyReportsScreen({Key? key, required this.selectedEmployeeIds});

  @override
  State<DailyReportsScreen> createState() => _DailyReportsScreenState();
}

class _DailyReportsScreenState extends State<DailyReportsScreen> {
  final String baseUrl = 'http://62.171.184.216:9595';

  DateTime selectedDate = DateTime.now();
  List<AdminDailyReportsModel> dailyReports = [];

  AdminReportsRepository repository =
  AdminReportsRepository('http://62.171.184.216:9595');

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI(selectedDate, widget.selectedEmployeeIds);
  }

  void fetchDataFromAPI(DateTime date, List<int> employeeIds) async {
    final formattedDate = date
        .toLocal()
        .toString()
        .split(' ')[0]; // Format the date to yyyy-MM-dd

    try {
      final reports =
      await repository.fetchDailyReports(employeeIds, formattedDate);
      setState(() {
        dailyReports = reports;
      });
    } catch (error) {
      print('Error fetching data: $error');
      // Handle the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Reports"),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text("Select Date"),
          ),
          Center(
            child: Text("Selected Date: ${selectedDate.toLocal()}"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dailyReports.length,
              itemBuilder: (context, index) {
                final report = dailyReports[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("Employee ID: ${report.empId}",
                        style: GoogleFonts.openSans(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      children: [
                        Text(
                            "Shift Start Time: ${report.shiftStartTime ?? 'N/A'}",
                            style: GoogleFonts.openSans(fontSize: 16)),
                        Text(
                            "Shift End Time: ${report.shiftEndTime ?? 'N/A'}",
                            style: GoogleFonts.openSans(fontSize: 16)),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.bottomRight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue, // Status capsule background color
                              borderRadius: BorderRadius.circular(12.0), // Rounded corners
                            ),
                            padding:
                            EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                            child: Text(
                              "Status: ${report.status}",
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
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2024),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });

      fetchDataFromAPI(selectedDate, widget.selectedEmployeeIds);
    }
  }
}
