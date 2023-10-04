import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../../Controller/AdminBlocInternet/AdminInternetBloc.dart';
import '../../../../Controller/AdminBlocInternet/AdminInternetState.dart';
import 'AdminAttendanceReportMonthly.dart';

class AdminMonthlyReportPage extends StatefulWidget {
  const AdminMonthlyReportPage({Key? key}) : super(key: key);

  @override
  State<AdminMonthlyReportPage> createState() => _AdminMonthlyReportPageState();
}

class _AdminMonthlyReportPageState extends State<AdminMonthlyReportPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetBloc, InternetStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if(state is InternetGainedState)
          {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Monthly Report',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
            backgroundColor:
            const Color(0xFFE26142), // Match the GPS Tracker Page's theme
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month),
                    Text(
                      DateFormat('MMMM dd, yyyy')
                          .format(DateTime.now()), // Format the current date
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Handle button tap here
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AdminAttendanceReportMonthly(),
                          ));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 24,
                            color: Color(
                                0xFFE26142), // Match the GPS Tracker Page's theme
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Attendance Report',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      else if(state is InternetLostState)
        {
          return Expanded(
            child: Scaffold(
              body: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No Internet Connection!",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Lottie.asset('assets/no_wifi.json'),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      else {
          return Expanded(
            child: Scaffold(
              body: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No Internet Connection!",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Lottie.asset('assets/no_wifi.json'),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      }
    );
  }
}
