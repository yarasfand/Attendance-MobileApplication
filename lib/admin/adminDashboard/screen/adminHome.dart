import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../introduction/bloc/bloc_internet/internet_bloc.dart';
import '../../../introduction/bloc/bloc_internet/internet_state.dart';
import 'adminAppbar.dart';
import 'admin_page.dart';

class AdminDashboard extends StatelessWidget {


  const AdminDashboard({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetBloc, InternetStates>(
      builder: (context, state) {
        if(state is InternetGainedState)
          {
        return const Scaffold(
          backgroundColor: Colors.transparent,
          body: AdminPage(),
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
                            color: Color(0xFFE26142),
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