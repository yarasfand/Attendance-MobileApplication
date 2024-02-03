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
    with TickerProviderStateMixin {
  bool _isMounted = true; // Add this flag

  bool isInternetLost = false;
  late TabController _tabController;
  List<LeaveRequest> leaveRequests = [];
  List<UnApprovedLeaveRequest> unapprovedLeaveRequests = [];

  bool isFirstTimeLoading = true;

  bool isRefreshing = false;

  Future<void> fetchData() async {
    // Set the refreshing flag to true
    setState(() {
      isRefreshing = true;
    });

    // Fetch both unapproved and approved leave requests
    context
        .read<UnapprovedLeaveRequestBloc>()
        .add(FetchUnapprovedLeaveRequests());
    context.read<LeaveRequestBloc>().add(FetchLeaveRequests());

    // Set the refreshing flag to false
    setState(() {
      isRefreshing = false;
    });
  }

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

    // Add a 2-second delay before fetching data
    Future.delayed(Duration(seconds: 2), fetchData);

    // Fetch and save unapproved leave requests
    context
        .read<UnapprovedLeaveRequestBloc>()
        .add(FetchUnapprovedLeaveRequests());
    context.read<UnapprovedLeaveRequestBloc>().stream.listen((state) {
      if (state is UnapprovedLeaveRequestLoaded) {
        setState(() {
          unapprovedLeaveRequests = state.unapprovedLeaveRequests;
          isFirstTimeLoading = false;
        });
      }
    });

    // Fetch and save approved leave requests
    context.read<LeaveRequestBloc>().add(FetchLeaveRequests());
    context.read<LeaveRequestBloc>().stream.listen((state) {
      if (state is LeaveRequestLoaded) {
        setState(() {
          leaveRequests = state.leaveRequests;
          isFirstTimeLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _isMounted = false; // Set the flag to false when the widget is disposed
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
                      RefreshIndicator(
                        onRefresh: () async {
                          fetchData();
                        },
                        child: isFirstTimeLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : unapprovedLeaveRequests.isEmpty
                                ? Center(
                                    child: Text('No Data Available'),
                                  )
                                : ListView.builder(
                                    itemCount: unapprovedLeaveRequests.length,
                                    itemBuilder: (context, index) {
                                      final leaveRequest =
                                          unapprovedLeaveRequests[index];
                                      return LeaveRequestCard(
                                        id: leaveRequest.rwId,
                                        name: leaveRequest.empName,
                                        departmentName: leaveRequest.department,
                                        reason: leaveRequest.reason,
                                        fromDate: leaveRequest.fromdate,
                                        status: "Pending",
                                        applicationDate:
                                            leaveRequest.applicationDate,
                                        empId: leaveRequest.empId.toString(),
                                        toDate: leaveRequest.todate,
                                        customLeaveRequestBloc: context
                                            .read<CustomLeaveRequestBloc>(),
                                      );
                                    },
                                  ),
                      ),
                      RefreshIndicator(
                        onRefresh: () async {
                          await fetchData();
                        },
                        child: isFirstTimeLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : isRefreshing
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : leaveRequests.isEmpty
                                    ? Center(
                                        child: Text('No Data Available'),
                                      )
                                    : ListView.builder(
                                        itemCount: leaveRequests.length,
                                        itemBuilder: (context, index) {
                                          final leaveRequest =
                                              leaveRequests[index];
                                          return LeaveRequestApproveCard(
                                            reason: leaveRequest.reason,
                                            empName: leaveRequest.empName,
                                            department: leaveRequest.department,
                                            fromDate: leaveRequest.fromdate,
                                            status: leaveRequest.approvedStatus,
                                            applicationDate:
                                                leaveRequest.applicationDate,
                                            toDate: leaveRequest.todate,
                                          );
                                        },
                                      ),
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
  final int id;
  final String name;
  final String departmentName;
  final String reason;
  final DateTime fromDate;
  final String status;
  final DateTime applicationDate;
  final CustomLeaveRequestBloc? customLeaveRequestBloc;
  final String empId;
  final DateTime toDate;

  LeaveRequestCard({
    required this.id,
    required this.name,
    required this.departmentName,
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

class _LeaveRequestCardState extends State<LeaveRequestCard>
    with TickerProviderStateMixin {
  late AnimationController addToCartPopUpAnimationController;
  bool _isDisposed = false; // Flag to check if the widget is disposed

  @override
  void initState() {
    addToCartPopUpAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    super.initState();
  }

  @override
  void dispose() {
    addToCartPopUpAnimationController.dispose();
    _isDisposed = true; // Set the flag to true when the widget is disposed
    super.dispose();
  }

  String formatDate(DateTime date) {
    return DateFormat.yMd().format(date); // Formats the date (year, month, day)
  }

  Future<void> _approveLeave(BuildContext context) async {
    try {
      final String formattedFromDate =
          DateFormat('yyyy-MM-dd').format(widget.fromDate);
      final String formattedToDate =
          DateFormat('yyyy-MM-dd').format(widget.toDate);
      final String formattedApplicationDate =
          DateFormat('yyyy-MM-dd').format(widget.applicationDate);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String corporateId = prefs.getString('corporate_id') ?? "";
      final leaveRequest = CustomLeaveRequestModel(
        employeeId: widget.empId,
        fromDate: formattedFromDate,
        toDate: formattedToDate,
        reason: widget.reason,
        leaveId: 0,
        leaveDuration: null,
        approvedBy: corporateId,
        status: "Approved",
        applicationDate: formattedApplicationDate,
        remark: null,
        id: widget.id,
      );

      // Use the BLoC to post the leave request
      widget.customLeaveRequestBloc!
          .add(PostCustomLeaveRequest(leaveRequest: leaveRequest));

      // Wait for the approval process to complete
      // You can await the response or use a callback, depending on your implementation
      await _waitForApprovalCompletion();

      // Fetch unapproved leave requests after approval
      context
          .read<UnapprovedLeaveRequestBloc>()
          .add(FetchUnapprovedLeaveRequests());
    } catch (e) {
      print('Error approving leave: $e');
    }
  }

  Future<void> _waitForApprovalCompletion() async {
    // You can implement logic to wait for the approval process to complete
    // For example, await the response from the server or use a callback
    // Adjust this method based on your implementation
    await Future.delayed(Duration(seconds: 2)); // Adjust as needed
  }

  void showPopupWithMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addToCartPopUpSuccess(
          addToCartPopUpAnimationController,
          message,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top:3.0,left: 16,right: 16,bottom: 3),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Reason: ${widget.reason}',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.name,style: GoogleFonts.lato(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),),
                Text(widget.departmentName,style: GoogleFonts.lato(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'From: ${formatDate(widget.fromDate)}',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'To: ${formatDate(widget.toDate)}',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Application Date: ${formatDate(widget.applicationDate)}',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
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
                  icon: const Icon(
                    Icons.check_circle,
                    size: 30.0,
                    color: Colors.blue,
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

class LeaveRequestApproveCard extends StatelessWidget {
  final String reason;
  final String empName;
  final String department;
  final DateTime fromDate;
  final DateTime toDate;
  final String status;
  final DateTime applicationDate;

  LeaveRequestApproveCard({
    required this.reason,
    required this.empName,
    required this.department,
    required this.fromDate,
    required this.toDate,
    required this.status,
    required this.applicationDate,
  });

  String formatDate(DateTime date) {
    return DateFormat.yMd().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  reason,
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${empName}',
                  style:  GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.height > 720 ? 20 : 15),
                Text(
                  '${department}',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'From: ${formatDate(fromDate)}',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.height > 720 ? 20 : 15),
                Text(
                  'To: ${formatDate(toDate)}',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Application Date: ${formatDate(applicationDate)}',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      status,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                        width: 5), // Add some spacing between the icon and text
                    Icon(
                      Icons.check_circle,
                      size: 20.0,
                      color: Colors.blue,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
