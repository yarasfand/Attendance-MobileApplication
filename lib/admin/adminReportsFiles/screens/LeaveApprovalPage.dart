import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Submission Page'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showApprovedList = false;
                  });

                  // Trigger the fetch unapproved leave requests event.
                  context
                      .read<UnapprovedLeaveRequestBloc>()
                      .add(FetchUnapprovedLeaveRequests());
                },
                child: Text('Unapproved'),
                style: ElevatedButton.styleFrom(
                  primary: showApprovedList ? Colors.grey : Colors.blue,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showApprovedList = true;
                  });

                  // Trigger the fetch approved leave requests event.
                  context.read<LeaveRequestBloc>().add(FetchLeaveRequests());
                },
                child: Text('Approved'),
                style: ElevatedButton.styleFrom(
                  primary: showApprovedList ? Colors.blue : Colors.grey,
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
                        return Center(child: CircularProgressIndicator());
                      } else if (state is LeaveRequestLoading) {
                        // Loading state: Display a loading indicator or message.
                        return Center(child: CircularProgressIndicator());
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
                            return ListTile(
                              title: Text(leaveRequest.reason),
                              subtitle: Text(leaveRequest.fromdate.toString()),
                              // Add more details here as needed.
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
                        return Center(
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
                        return Center(child: CircularProgressIndicator());
                      } else if (state is UnapprovedLeaveRequestLoading) {
                        // Loading state: Display a loading indicator or message.
                        return Center(child: CircularProgressIndicator());
                      } else if (state is UnapprovedLeaveRequestLoaded) {
                        // Loaded state: Display the list of unapproved leave requests.
                        final unapprovedLeaveRequests =
                            state.unapprovedLeaveRequests;
                        return ListView.builder(
                          itemCount: unapprovedLeaveRequests.length,
                          itemBuilder: (context, index) {
                            final leaveRequest = unapprovedLeaveRequests[index];
                            return ListTile(
                              title: Text(leaveRequest.reason),
                              subtitle: Text(leaveRequest.fromdate.toString()),
                              // Add more details here as needed.
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
                        return Center(
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
