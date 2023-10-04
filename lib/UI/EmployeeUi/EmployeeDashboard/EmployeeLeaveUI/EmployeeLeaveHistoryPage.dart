import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../Backend/EmployeeApi/EmployeeModels/EmployeeLeaveHistoryModel.dart';
import '../../../../Backend/EmployeeApi/EmployeeRespository/EmployeeLeaveHistoryRepository.dart';
import '../../../../Backend/EmployeeApi/EmployeeRespository/EmployeeLeaveRequestRepository.dart';
class LeavesHistoryPage extends StatefulWidget {
  @override
  _LeavesHistoryPageState createState() => _LeavesHistoryPageState();
}

class _LeavesHistoryPageState extends State<LeavesHistoryPage> {
  final LeaveHistoryRepository _repository = LeaveHistoryRepository();
  final EmpLeaveRepository _leaveTypeRepository = EmpLeaveRepository();
  List<LeaveHistoryModel> leaveDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final leaveHistory = await _repository.getLeaveHistory();
      setState(() {
        leaveDetails = leaveHistory;
        isLoading = false;
      });
    } catch (e) {
      // Handle any errors here
      print("Error loading leave history: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Leave Details',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : leaveDetails.isEmpty
                      ? const Center(
                          child: Text("No leave history data available."),
                        )
                      : _buildLeaveCards(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveCards() {
    return ListView.builder(
      itemCount: leaveDetails.length,
      itemBuilder: (BuildContext context, int index) {
        final leave = leaveDetails[index];
        final fromDate = leave.fromDate;
        final toDate = leave.toDate;
        final reason = leave.reason;
        final leaveId = leave.leaveId;
        final approvedStatus = leave.approvedStatus;
        final applicationDate = leave.applicationDate;

        // Determine if this is the top card
        final isTopCard = index == 0;
        return FutureBuilder<String>(
          future: _leaveTypeRepository.getLeaveTypeName(leaveId),
          builder: (BuildContext context,
              AsyncSnapshot<String> leaveTypeNameSnapshot) {
            if (leaveTypeNameSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const SizedBox(); // Return an empty container while waiting
            } else if (leaveTypeNameSnapshot.hasError) {
              return Text("Error: ${leaveTypeNameSnapshot.error}");
            } else {
              final leaveTypeName =
                  leaveTypeNameSnapshot.data ?? "Unknown Leave Type";
              return isTopCard
                  ? _buildDarkTopCard(leaveTypeName, fromDate, reason, toDate,
                      approvedStatus, applicationDate)
                  : LeaveCard(
                      fromDate: fromDate,
                      toDate: toDate,
                      reason: reason,
                      leaveId: leaveId,
                      approvedStatus: approvedStatus,
                      applicationDate: applicationDate,
                      leaveTypeName: leaveTypeName,
                    );
            }
          },
        );
      },
    );
  }
}

String formatDate(DateTime dateTime) {
  final formatter = DateFormat('d MMM, y'); // Format date as '3 Jul, 2023'
  return formatter.format(dateTime);
}

Widget getApprovalWidget(String status) {
  Color backgroundColor;
  if (status == "Approved") {
    backgroundColor = Colors.green;
  } else {
    backgroundColor = Colors.red;
  }
  return Container(
    padding: const EdgeInsets.symmetric(
        horizontal: 6, vertical: 3), // Smaller padding
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12), // Smaller radius
    ),
    child: Text(
      status,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 12, // Smaller font size
      ),
    ),
  );
}

class LeaveCard extends StatelessWidget {
  final DateTime fromDate;
  final DateTime toDate;
  final String reason;
  final int leaveId;
  final String approvedStatus;
  final DateTime applicationDate;
  final String leaveTypeName;

  LeaveCard({
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.leaveId,
    required this.approvedStatus,
    required this.applicationDate,
    required this.leaveTypeName,
  });

  String formatDate(DateTime dateTime) {
    final formatter = DateFormat('d MMM, y'); // Format date as '3 Jul, 2023'
    return formatter.format(dateTime);
  }

  Widget getApprovalWidget(String status) {
    Color backgroundColor;
    if (status == "Approved") {
      backgroundColor = Colors.green;
    } else {
      backgroundColor = Colors.red;
    }
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 6, vertical: 3), // Smaller padding
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12), // Smaller radius
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12, // Smaller font size
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Smaller padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Type- $leaveTypeName',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                getApprovalWidget(approvedStatus),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'From: ${formatDate(fromDate)}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12, // Smaller font size
                  ),
                ),
                Text(
                  'To: ${formatDate(toDate)}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12, // Smaller font size
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Application Date: ${formatDate(applicationDate)}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12, // Smaller font size
                  ),
                ),
                Spacer(), // Add a Spacer widget to occupy the space
                Text(
                  reason, // Reason text
                  style: const TextStyle(
                    color: Colors.grey, // Light color for the reason text
                    fontSize: 12, // Smaller font size
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );


  }
}

Widget _buildDarkTopCard(String leaveTypeName, DateTime fromDate, String reason,
    DateTime toDate, String approvedStatus, DateTime applicationDate) {
  return Card(
    elevation: 4.0,
    margin: const EdgeInsets.all(8.0),
    color: Colors.deepPurple, // Change the background color
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0), // Smaller padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Type: $leaveTypeName',
                style: const TextStyle(
                  color: Colors.white, // Change text color to white
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              getApprovalWidget(approvedStatus),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'From: ${formatDate(fromDate)}',
                style: const TextStyle(
                  color: Colors.white, // Change text color to white
                  fontSize: 12, // Smaller font size
                ),
              ),
              Text(
                'To: ${formatDate(toDate)}',
                style: const TextStyle(
                  color: Colors.white, // Change text color to white
                  fontSize: 12, // Smaller font size
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Application Date: ${formatDate(applicationDate)}',
                style: const TextStyle(
                  color: Colors.grey, // Keep application date text color
                  fontSize: 12, // Smaller font size
                ),
              ),
              Spacer(), // Add a Spacer widget to occupy the space
              Text(
                reason, // Reason text
                style: const TextStyle(
                  color: Colors.grey, // Keep reason text color
                  fontSize: 12, // Smaller font size
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );


}
