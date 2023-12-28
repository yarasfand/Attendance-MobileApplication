import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/constants/AppBar_constant.dart';
import '../../../constants/AppColor_constants.dart';
import '../models/LeaveHistory_repository.dart';
import '../models/empLeaveHistoryModel.dart';
import '../models/empLeaveRequestRepository.dart';

class LeavesHistoryPage extends StatefulWidget {
  @override
  _LeavesHistoryPageState createState() => _LeavesHistoryPageState();
}

class _LeavesHistoryPageState extends State<LeavesHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final LeaveHistoryRepository _repository = LeaveHistoryRepository();
  final EmpLeaveRepository _leaveTypeRepository = EmpLeaveRepository();
  List<LeaveHistoryModel> leaveDetails = [];
  bool isLoading = true;
  late String _currentTime = DateFormat.yMd().add_jm().format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadData();
    // Create a timer to update the time every second
  }

  Future<void> loadData() async {
    try {
      final leaveHistory = await _repository.getLeaveHistory();
      setState(() {
        leaveDetails = leaveHistory;
        leaveDetails.sort((a, b) => b.applicationDate.compareTo(
            a.applicationDate)); // Sort by application date, most recent first
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

  List<LeaveHistoryModel> getApprovedLeaves() {
    return leaveDetails
        .where((leave) => leave.approvedStatus == "Approved")
        .toList();
  }

  List<LeaveHistoryModel> getPendingLeaves() {
    return leaveDetails
        .where((leave) => leave.approvedStatus == "UnApproved")
        .toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leave Details",
          style: AppBarStyles.appBarTextStyle,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppBarStyles.appBarIconColor),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "Approved",),
              Tab(text: "Pending"),
            ],
            labelColor: Colors.black,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLeaveList(getApprovedLeaves()),
                _buildLeaveList(getPendingLeaves()),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildLeaveList(List<LeaveHistoryModel> leaves) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (leaves.isEmpty) {
      return Center(
        child: Text("No leaves to display."),
      );
    } else {
      return ListView.builder(
        itemCount: leaves.length,
        itemBuilder: (BuildContext context, int index) {
          final leave = leaves[index];
          return LeaveCard(
            fromDate: leave.fromDate,
            toDate: leave.toDate,
            reason: leave.reason,
            leaveId: leave.leaveId,
            approvedStatus: leave.approvedStatus,
            applicationDate: leave.applicationDate,
            leaveTypeName: "Sample Leave Type", // You need to provide the actual leave type name
          );
        },
      );
    }
  }

  Widget _buildLeaveCards() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: leaveDetails.length,
      itemBuilder: (BuildContext context, int index) {
        final leave = leaveDetails[index];
        final fromDate = leave.fromDate;
        final toDate = leave.toDate;
        final reason = leave.reason;
        final leaveId = leave.leaveId;
        print("Leave id is: $leaveId");

        final approvedStatus = leave.approvedStatus;
        final applicationDate = leave.applicationDate;

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
  String displayStatus =
      status; // Initialize displayStatus with the provided status

  if (status == "Approved") {
    backgroundColor = Colors.green;
  } else {
    backgroundColor = Colors.red;
    displayStatus =
        "Pending"; // Change the display status to "Pending" for "Unapproved"
  }
  return Container(
    padding: const EdgeInsets.symmetric(
        horizontal: 6, vertical: 3), // Smaller padding
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12), // Smaller radius
    ),
    child: Text(
      displayStatus,
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
    final formatter = DateFormat('d MMM, y');
    return formatter.format(dateTime);
  }

  Widget getApprovalWidget(String status) {
    Color backgroundColor;
    String displayStatus =
        status; // Initialize displayStatus with the provided status

    if (status == "Approved") {
      backgroundColor = Colors.green;
    } else {
      backgroundColor = Colors.red;
      displayStatus =
          "Pending"; // Change the display status to "Pending" for "Unapproved"
    }
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 6, vertical: 3), // Smaller padding
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12), // Smaller radius
      ),
      child: Text(
        displayStatus,
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
                  '$leaveTypeName',
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Duration: ${formatDate(fromDate)}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14, // Smaller font size
                      fontWeight: FontWeight.bold // Smaller font size

                      ),
                ),
                Text(
                  ' - ${formatDate(toDate)}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14, // Smaller font size
                      fontWeight: FontWeight.bold // Smaller font size

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
                const Spacer(), // Add a Spacer widget to occupy the space
                Text(
                  '$reason  ', // Reason text
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
                '$leaveTypeName',
                style: const TextStyle(
                  color: Colors.blue, // Change text color to white
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              getApprovalWidget(approvedStatus),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Duration: ${formatDate(fromDate)}',
                style: const TextStyle(
                    color: Colors.black, // Change text color to white
                    fontSize: 14, // Smaller font size
                    fontWeight: FontWeight.bold // Smaller font size

                    ),
              ),
              Text(
                ' - ${formatDate(toDate)}',
                style: const TextStyle(
                    color: Colors.black, // Change text color to white
                    fontSize: 14,
                    fontWeight: FontWeight.bold // Smaller font size
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
              const Spacer(), // Add a Spacer widget to occupy the space
              Text(
                '$reason  ', // Reason text
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
