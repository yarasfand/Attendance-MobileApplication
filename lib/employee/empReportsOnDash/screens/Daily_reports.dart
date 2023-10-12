import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/DailyReport_repository.dart';
import '../models/DailyReports_model.dart';
class DailyReportsPage extends StatefulWidget {
  const DailyReportsPage({Key? key}) : super(key: key);

  @override
  State<DailyReportsPage> createState() => _DailyReportsPageState();
}

class _DailyReportsPageState extends State<DailyReportsPage> {
  DateTime _selectedDate = DateTime.now();
  final DailyReportsRepository _repository = DailyReportsRepository();
  List<DailyReportsModel> _dailyReports = []; // List to store fetched reports

  // Function to format DateTime to a string in "yyyy-MM-ddTHH:mm:ss" format
  String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    return formatter.format(dateTime);
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });

      // Call the API with the selected date (_selectedDate)
      _fetchAndDisplayReports(_selectedDate);
    }
  }

  void _fetchAndDisplayReports(DateTime selectedDate) async {
    try {
      final formattedDate = formatDateTime(selectedDate);

      final DateTime reportDateTime = DateTime.parse(formattedDate);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? corporateId = prefs.getString('corporate_id');
      final int? employeeId = prefs.getInt('employee_id');

      if (corporateId != null && employeeId != null) {
        final response = await _repository.getDailyReports(
          corporateId: corporateId,
          employeeId: employeeId,
          reportDate: reportDateTime,
        );

        if (response is List<DailyReportsModel>) {
          setState(() {
            _dailyReports = response; // Update the list of fetched reports
          });
        } else {
          print('API response is not a List of DailyReportsModel');
        }
      } else {
        print('Corporate ID or Employee ID is null');
      }
    } catch (e) {
      print('Error fetching reports: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daily Report',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFE26142),
      ),
      body: Column(
        children: [
          Card(
            color: const Color(0xFFE26142),
            elevation: 4,
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Selected Date: ${_selectedDate.toLocal()}'.split(' ')[0],
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _selectFromDate(context);
                    },
                    child: const Text('Select Date'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Call the API with the selected date (_selectedDate)
                      _fetchAndDisplayReports(_selectedDate);
                    },
                    child: const Text('Fetch Reports'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16), // Add spacing between card and list
          Expanded(
            child: Card(
              color: const Color(0xFFE26142),
              elevation: 2,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                itemCount: _dailyReports.length,
                itemBuilder: (context, index) {
                  final report = _dailyReports[index];
                  // Customize the ListTile to display report details with better alignment
                  return Padding(
                    padding:
                        const EdgeInsets.all(8.0), // Add padding for spacing
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Daily Info",
                          style: TextStyle(
                            color: Colors
                                .white, // Change the color to make it prominent
                            fontWeight: FontWeight.bold, // Add bold font weight
                            fontSize: 25, // Customize the font size as needed
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          '• Pay Code - ${report.payCode ?? "N/A"}',
                          style: const TextStyle(
                            color: Color(
                                0xFF9ADCD2), // Change the color to make it prominent
                            fontWeight: FontWeight.w500, // Add bold font weight
                            fontSize: 16, // Customize the font size as needed
                          ),
                        ),
                        Text(
                          '• Shift Start Time - ${report.shiftStartTime ?? "N/A"}',
                          style: const TextStyle(
                            color: Color(
                                0xFF9ADCD2), // Change the color to make it prominent
                            fontWeight: FontWeight.w500, // Add bold font weight
                            fontSize: 16, // Customize the font size as needed
                          ),
                        ),
                        Text(
                          '• Shift End Time - ${report.shiftEndTime ?? 'N/A'}',
                          style: const TextStyle(
                            color: Color(
                                0xFF9ADCD2), // Change the color to make it prominent
                            fontWeight: FontWeight.w500, // Add bold font weight
                            fontSize: 16, // Customize the font size as needed
                          ),
                        ),
                        Text(
                          '• Status - ${report.status ?? 'N/A'}',
                          style: const TextStyle(
                            color: Color(
                                0xFF9ADCD2), // Change the color to make it prominent
                            fontWeight: FontWeight.w500, // Add bold font weight
                            fontSize: 16, // Customize the font size as needed
                          ),
                        ),
                        Text(
                          '• Hours Worked - ${report.hoursWorked ?? 'N/A'}',
                          style: const TextStyle(
                            color: Color(
                                0xFF9ADCD2), // Change the color to make it prominent
                            fontWeight: FontWeight.w500, // Add bold font weight
                            fontSize: 16, // Customize the font size as needed
                          ),
                        ),
                        Text(
                          '• Lunch Start Time - ${report.lunchStartTime ?? 'N/A'}',
                          style: const TextStyle(
                            color: Color(
                                0xFF9ADCD2), // Change the color to make it prominent
                            fontWeight: FontWeight.w500, // Add bold font weight
                            fontSize: 16, // Customize the font size as needed
                          ),
                        ),
                        Text(
                          '• Lunch End Time - ${report.lunchEndTime ?? 'N/A'}',
                          style: const TextStyle(
                            color: Color(
                                0xFF9ADCD2), // Change the color to make it prominent
                            fontWeight: FontWeight.w500, // Add bold font weight
                            fontSize: 16, // Customize the font size as needed
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
