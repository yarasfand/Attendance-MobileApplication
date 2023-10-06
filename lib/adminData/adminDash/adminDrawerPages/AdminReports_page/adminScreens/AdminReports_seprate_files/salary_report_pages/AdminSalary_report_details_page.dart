import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project/bloc_internet/internet_bloc.dart';
import 'package:project/bloc_internet/internet_state.dart';

class AdminSalaryReportDetail extends StatefulWidget {
  const AdminSalaryReportDetail({super.key});

  @override
  State<AdminSalaryReportDetail> createState() =>
      _AdminSalaryReportDetailState();
}

class _AdminSalaryReportDetailState extends State<AdminSalaryReportDetail> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetBloc, InternetStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if(state is InternetGainedState){
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Salary Report',
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
          body: Center(child: Text("This is salary reports page")),
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
        else{
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
