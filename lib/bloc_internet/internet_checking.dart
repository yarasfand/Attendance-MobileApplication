
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project/bloc_internet/internet_state.dart';
import 'package:project/Login%20Page/login_page.dart';
import '../Login Page/login_bloc/loginbloc.dart';
import 'internet_bloc.dart';

class AfterIntro extends StatelessWidget {
  const AfterIntro({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: BlocConsumer<InternetBloc, InternetStates>(
        builder: (context, state) {
          // can show UI data accordingly
          if (state is InternetGainedState) {
            return Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Internet Connected!"),
                    SizedBox(
                      height: 20,
                    ),
                    Lottie.asset('assets/yes_wifi.json'),
                  ],
                ),
              ),
            );
          } else if (state is InternetLostState) {
            return Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("No Internet Connection!"),
                    SizedBox(
                      height: 20,
                    ),
                    Lottie.asset('assets/no_wifi.json'),
                  ],
                ),
              ),
            );
          }
          else {
            return Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("No Internet Connection!"),
                    SizedBox(
                      height: 20,
                    ),
                    Lottie.asset('assets/no_wifi.json'),
                  ],
                ),
              ),
            );
          }
        },
        listener: (context, state) async {
          // can not show the UI changing just used to move to next screen or snack bars

          if (state is InternetGainedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Internet connected!"),
                backgroundColor: Colors.green,
              ),
            );

            await Future.delayed(Duration(milliseconds: 4500));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Builder(
                    builder: (context) => BlocProvider(
                      create: (context) => SignInBloc(),
                      child: LoginPage(),
                    ),
                  );
                },
              ),
            );
          } else if (state is InternetLostState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("No internet connection!"),
                backgroundColor: Colors.red,
              ),
            );
          }

        },
      )),
    );
  }
}
