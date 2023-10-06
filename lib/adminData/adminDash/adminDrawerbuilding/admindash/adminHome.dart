import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project/bloc_internet/internet_bloc.dart';
import 'package:project/bloc_internet/internet_state.dart';
import 'adminAppbar.dart';
import 'adminScreens/admin_page.dart';

class AdminDashboard extends StatelessWidget {
  final VoidCallback openDrawer;

  const AdminDashboard({
    super.key, required this.openDrawer
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetBloc, InternetStates>(
      builder: (context, state) {
        if(state is InternetGainedState)
          {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: AppBar().preferredSize,
            child: AdminAppBar(
              openDrawer: openDrawer,
            ),
          ),
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