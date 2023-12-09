import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/constants/AppBar_constant.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:project/introduction/bloc/bloc_internet/internet_bloc.dart';
import 'package:project/introduction/bloc/bloc_internet/internet_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../No_internet/no_internet.dart';
import '../../../constants/AnimatedTextPopUp.dart';
import '../bloc/CustomLeaveRequestApiFiles/custom_leave_request_bloc.dart';
import '../bloc/leaveRequestApiFiles/leave_request_bloc.dart';
import '../bloc/unApprovedLeaveRequestApiFiles/un_approved_leave_request_bloc.dart';
import '../bloc/unApprovedLeaveRequestApiFiles/un_approved_leave_request_event.dart';
import '../bloc/unApprovedLeaveRequestApiFiles/un_approved_leave_request_state.dart';
import '../models/CustomLeaveRequestModel.dart';
import '../models/leaveRequestModel.dart';
import '../models/unApprovedLeaveRequestModel.dart';

class LeaveApprovalPage extends StatefulWidget {
  const LeaveApprovalPage({Key? key});

  @override
  State<LeaveApprovalPage> createState() => _LeaveApprovalPageState();
}

class _LeaveApprovalPageState extends State<LeaveApprovalPage>
    with TickerProviderStateMixin{
  bool isInternetLost = false;
  late TabController _tabController;
  List<UnApprovedLeaveRequest> unapprovedLeaveRequests = [];
  List<LeaveRequest> leaveRequests = [];

  @override
  void initState() {

    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        if (_tabController.index == 0) {
          // Fetch unapproved leave requests
          context
              .read<UnapprovedLeaveRequestBloc>()
              .add(FetchUnapprovedLeaveRequests());
        } else if (_tabController.index == 1) {
          // Fetch approved leave requests
          context.read<LeaveRequestBloc>().add(FetchLeaveRequests());
        }
      }
    });

    // Fetch all data initially
    context
        .read<UnapprovedLeaveRequestBloc>()
        .add(FetchUnapprovedLeaveRequests());
    context.read<LeaveRequestBloc>().add(FetchLeaveRequests());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetBloc, InternetStates>(
      listener: (context, state) {
        if (state is InternetLostState) {
          isInternetLost = true;
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.push(
              context,
              PageTransition(
                child: const NoInternet(),
                type: PageTransitionType.rightToLeft,
              ),
            );
          });
        } else if (state is InternetGainedState) {
          if (isInternetLost) {
            Navigator.pop(context);
          }
          isInternetLost = false;
        }
      },
      builder: (context, internetState) {
        if (internetState is InternetGainedState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Leave History',
                style: AppBarStyles.appBarTextStyle,
              ),
              centerTitle: true,
              backgroundColor: AppColors.primaryColor,
              iconTheme: IconThemeData(color: AppColors.brightWhite),

            ),
            body: Column(
              children: [
                TabBar(
                  labelColor: Colors.black,
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Pending'), // Tab for unapproved requests
                    Tab(text: 'Approved'), // Tab for approved requests
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      BlocBuilder<UnapprovedLeaveRequestBloc,
                          UnapprovedLeaveRequestState>(
                        builder: (context, state) {
                          if (state is UnapprovedLeaveRequestInitial) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is UnapprovedLeaveRequestLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is UnapprovedLeaveRequestLoaded) {
                            unapprovedLeaveRequests = state.unapprovedLeaveRequests;
                            return ListView.builder(
                              itemCount: unapprovedLeaveRequests.length,
                              itemBuilder: (context, index) {
                                final leaveRequest = unapprovedLeaveRequests[index];
                                return LeaveRequestCard(
                                  reason: leaveRequest.reason,
                                  fromDate: leaveRequest.fromdate,
                                  status: "Pending",
                                  applicationDate: leaveRequest.applicationDate,
                                  empId: leaveRequest.empId.toString(),
                                  toDate: leaveRequest.todate,
                                  customLeaveRequestBloc: context.read<CustomLeaveRequestBloc>(),
                                );
                              },
                            );
                          } else if (state is UnapprovedLeaveRequestError) {
                            return Center(
                              child: Text('Error: ${state.error}'),
                            );
                          } else {
                            return const Center(
                              child: Text('Unknown state'),
                            );
                          }
                        },
                      ),
                      BlocBuilder<LeaveRequestBloc, LeaveRequestState>(
                        builder: (context, state) {
                          if (state is LeaveRequestInitial) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is LeaveRequestLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is LeaveRequestLoaded) {
                            leaveRequests = state.leaveRequests;
                            return ListView.builder(
                              itemCount: leaveRequests.length,
                              itemBuilder: (context, index) {
                                final leaveRequest = leaveRequests[index];
                                return LeaveRequestApproveCard(
                                  reason: leaveRequest.reason,
                                  fromDate: leaveRequest.fromdate,
                                  status: leaveRequest.approvedStatus,
                                  applicationDate: leaveRequest.applicationDate,
                                );
                              },
                            );
                          } else if (state is LeaveRequestError) {
                            return Center(
                              child: Text('Error: ${state.error}'),
                            );
                          } else {
                            return const Center(
                              child: Text('Unknown state'),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}


class LeaveRequestCard extends StatefulWidget {
  final String reason;
  final DateTime fromDate;
  final String status;
  final DateTime applicationDate;
  final CustomLeaveRequestBloc? customLeaveRequestBloc;
  final String empId;
  final DateTime toDate;

  LeaveRequestCard({
    required this.reason,
    required this.fromDate,
    required this.status,
    required this.applicationDate,
    this.customLeaveRequestBloc,
    required this.empId,
    required this.toDate,
  });

  @override
  State<LeaveRequestCard> createState() => _LeaveRequestCardState();
}

class _LeaveRequestCardState extends State<LeaveRequestCard> with TickerProviderStateMixin{

  late AnimationController addToCartPopUpAnimationController;

  @override
  void initState() {
    addToCartPopUpAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    addToCartPopUpAnimationController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    return DateFormat.yMd().format(date); // Formats the date (year, month, day)
  }
  void showPopupWithMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addToCartPopUpSuccess(
            addToCartPopUpAnimationController,
            message
        );
      },
    );
  }

  void _approveLeave(BuildContext context) async{
    // Create the leave request model with empId, fromDate, toDate, and other parameters
    final String formattedFromDate = DateFormat('yyyy-MM-dd').format(widget.fromDate);
    final String formattedToDate = DateFormat('yyyy-MM-dd').format(widget.toDate);
    final String formattedApplicationDate = DateFormat('yyyy-MM-dd').format(widget.applicationDate);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String corporateId = prefs.getString('corporate_id') ?? "";
    final leaveRequest = CustomLeaveRequestModel(
      employeeId: widget.empId,
      fromDate: formattedFromDate, // Format the date
      toDate: formattedToDate, // Format the date
      reason: widget.reason,
      leaveId: 0,
      leaveDuration: null,
      approvedBy: corporateId,
      status: "Approved", // Change status to "Approved"
      applicationDate: formattedApplicationDate, // Format the date
      remark: null,
    );

    // Use the BLoC to post the leave request
    widget.customLeaveRequestBloc!.add(PostCustomLeaveRequest(leaveRequest: leaveRequest));
    // Fetch unapproved leave requests after approval
    context.read<UnapprovedLeaveRequestBloc>().add(FetchUnapprovedLeaveRequests());
  }

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.reason,
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'From: ${formatDate(widget.fromDate)}', // Format the date
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'To: ${formatDate(widget.toDate)}', // Format the date
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Application Date: ${formatDate(widget.applicationDate)}', // Format the date
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                SizedBox(height: 40,),
                ElevatedButton(
                  onPressed: () {
                    if (widget.customLeaveRequestBloc != null) {

                      addToCartPopUpAnimationController.forward();
                      Timer(const Duration(seconds: 2), () {
                        _approveLeave(context);
                        addToCartPopUpAnimationController.reverse();

                        Navigator.pop(context);

                      });
                      showPopupWithMessage("Leave approved!");

                    } else {
                      print("The values passed are null");
                    }
                  },
                  child: const Text('Approve'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LeaveRequestApproveCard extends StatelessWidget {
  final String reason;
  final DateTime fromDate;
  final String status;
  final DateTime applicationDate;

  LeaveRequestApproveCard({
    required this.reason,
    required this.fromDate,
    required this.status,
    required this.applicationDate,
  });

  String formatDate(DateTime date) {
    return DateFormat.yMd().format(date); // Formats the date (year, month, day)
  }

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(8.0),
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Icon(
                Icons.description,
                size: 36.0,
                color: Colors.white,
              ),
            ),
            Expanded(
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
                  Text(
                    'From: ${formatDate(fromDate)}', // Format the date
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 36.0,
                        color: Colors.blue,
                      ),
                      Text(
                        status,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Application Date: ${formatDate(applicationDate)}', // Format the date
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

