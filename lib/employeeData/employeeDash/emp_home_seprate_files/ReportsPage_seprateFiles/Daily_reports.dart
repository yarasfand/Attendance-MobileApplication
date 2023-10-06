import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api_intigration_files/models/DailyReports_model.dart';
import '../../../../api_intigration_files/repository/DailyReport_repository.dart';

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
        final reports = await _repository.getDailyReports(
          corporateId: corporateId,
          employeeId: employeeId,
          reportDate: reportDateTime,
        );

        setState(() {
          _dailyReports = reports; // Update the list of fetched reports
        });
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
        title: const Text('Daily Reports'),
      ),
      body: Column(
        children: [
          Text(
            'Selected Date: ${_selectedDate.toLocal()}'.split(' ')[0],
            style: const TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {
              _selectFromDate(context);
            },
            child: const Text('Select Date'),
          ),
          ElevatedButton(
            onPressed: () {
              // Call the API with the selected date (_selectedDate)
              _fetchAndDisplayReports(_selectedDate);
            },
            child: const Text('Fetch Reports'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _dailyReports.length,
              itemBuilder: (context, index) {
                final report = _dailyReports[index];
                // Customize the ListTile to display report details
                return ListTile(
                  title: Text('Pay Code: ${report.payCode ?? "N/A"}'),
                  subtitle: Text(
                      'Shift Start Time: ${report.shiftStartTime ?? "N/A"}'),
                  trailing:
                      Text("Shift End Time: ${report.shiftEndTime} ?? 'N/A'"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
