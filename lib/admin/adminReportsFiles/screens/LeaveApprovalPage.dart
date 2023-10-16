import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/constants/AppColor_constants.dart';
import '../bloc/leaveRequestApiFiles/leave_request_bloc.dart';
import '../bloc/unApprovedLeaveRequestApiFiles/un_approved_leave_request_bloc.dart';
import '../bloc/unApprovedLeaveRequestApiFiles/un_approved_leave_request_event.dart';
import '../bloc/unApprovedLeaveRequestApiFiles/un_approved_leave_request_state.dart';

class LeaveApprovalPage extends StatefulWidget {
  const LeaveApprovalPage({Key? key});

  @override
  State<LeaveApprovalPage> createState() => _LeaveApprovalPageState();
}

class _LeaveApprovalPageState extends State<LeaveApprovalPage> {
  bool showApprovedList = false; // Initially, show the unapproved list.
  double unapprovedButtonScale = 1.0;
  double approvedButtonScale = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200.0), // Set the desired height of the app bar
        child: AppBar(
          title: Text(
            'Leave Submission Page',
            style: TextStyle(color: AppColors.brightWhite),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          iconTheme: IconThemeData(color: AppColors.brightWhite),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    width: double.infinity, // Set to take up the full width
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showApprovedList = false;
                          unapprovedButtonScale = 1.2;
                          approvedButtonScale = 1.0;
                        });

                        // Trigger the fetch unapproved leave requests event.
                        context
                            .read<UnapprovedLeaveRequestBloc>()
                            .add(FetchUnapprovedLeaveRequests());
                      },
                      child: const Text('Unapproved'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: showApprovedList ? AppColors.offWhite : Colors.red[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Set the radius to 0 for sharp corners
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6,),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity, // Set to take up the full width
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showApprovedList = true;
                          approvedButtonScale = 1.2;
                          unapprovedButtonScale = 1.0;
                        });

                        // Trigger the fetch approved leave requests event.
                        context
                            .read<LeaveRequestBloc>()
                            .add(FetchLeaveRequests());
                      },
                      child: const Text('Approved'),
                      style: ElevatedButton.styleFrom(
                        primary: showApprovedList ? Colors.green : AppColors.offWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Set the radius to 0 for sharp corners
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: showApprovedList
                ? BlocBuilder<LeaveRequestBloc, LeaveRequestState>(
                    // Handle approved leave requests
                    builder: (context, state) {
                      // ... (existing code for approved requests)
                      if (state is LeaveRequestInitial) {
                        // Initial state: Display a loading indicator or message.
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is LeaveRequestLoading) {
                        // Loading state: Display a loading indicator or message.
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is LeaveRequestLoaded) {
                        // Loaded state: Display the list of leave requests.
                        final leaveRequests = state.leaveRequests;
                        final filteredList = showApprovedList
                            ? leaveRequests
                                .where((request) =>
                                    request.approvedStatus == 'Approved')
                                .toList()
                            : leaveRequests
                                .where((request) =>
                                    request.approvedStatus != 'Approved')
                                .toList();
                        return ListView.builder(
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final leaveRequest = filteredList[index];
                            return LeaveRequestCard(
                              reason: leaveRequest.reason,
                              fromDate: leaveRequest.fromdate,
                              status: leaveRequest.approvedStatus,
                              applicationDate: leaveRequest.applicationDate,
                            );
                          },
                        );
                      } else if (state is LeaveRequestError) {
                        // Error state: Display an error message.
                        return Center(
                          child: Text('Error: ${state.error}'),
                        );
                      } else {
                        // Handle other states as needed.
                        return const Center(
                          child: Text('Unknown state'),
                        );
                      }
                    },
                  )
                : BlocBuilder<UnapprovedLeaveRequestBloc,
                    UnapprovedLeaveRequestState>(
                    // Handle unapproved leave requests
                    builder: (context, state) {
                      if (state is UnapprovedLeaveRequestInitial) {
                        // Initial state: Display a loading indicator or message.
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is UnapprovedLeaveRequestLoading) {
                        // Loading state: Display a loading indicator or message.
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is UnapprovedLeaveRequestLoaded) {
                        // Loaded state: Display the list of unapproved leave requests.
                        final unapprovedLeaveRequests =
                            state.unapprovedLeaveRequests;
                        return ListView.builder(
                          itemCount: unapprovedLeaveRequests.length,
                          itemBuilder: (context, index) {
                            final leaveRequest = unapprovedLeaveRequests[index];

                            return LeaveRequestCard(
                              reason: leaveRequest.reason,
                              fromDate: leaveRequest.fromdate,
                              status: leaveRequest.approvedStatus,
                              applicationDate: leaveRequest.applicationDate,
                            );
                          },
                        );
                      } else if (state is UnapprovedLeaveRequestError) {
                        // Error state: Display an error message.
                        return Center(
                          child: Text('Error: ${state.error}'),
                        );
                      } else {
                        // Handle other states as needed.
                        return const Center(
                          child: Text('Unknown state'),
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ... Previous code ...

class LeaveRequestCard extends StatelessWidget {
  final String reason;
  final DateTime fromDate;
  final String status;
  final DateTime applicationDate;

  LeaveRequestCard({
    required this.reason,
    required this.fromDate,
    required this.status,
    required this.applicationDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reason,
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'From: ${fromDate.toString()}',
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: $status',
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Application Date: ${applicationDate.toString()}',
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ... The rest of your code ...

