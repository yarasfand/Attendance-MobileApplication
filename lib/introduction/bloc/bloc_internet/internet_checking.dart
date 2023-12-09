import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import '../../../login/bloc/loginBloc/loginbloc.dart';
import '../../../login/screens/loginPage.dart';
import 'internet_bloc.dart';
import 'internet_state.dart';

class AfterIntro extends StatelessWidget {
  const AfterIntro({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: BlocConsumer<InternetBloc, InternetStates>(
          builder: (context, state) {
            if (state is InternetLostState) {
              return _buildNoInternetWidget();
            } else if (state is InternetGainedState) {
              return Container();
            } else {
              return _buildNoInternetWidget();
            }
          },
          listener: (context, state) async {
            if (state is InternetGainedState) {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  duration: const Duration(seconds: 1),
                  type: PageTransitionType
                      .rightToLeft, // Choose your desired transition type
                  child: Builder(
                    builder: (context) => BlocProvider(
                      create: (context) => SignInBloc(),
                      child: LoginPage(),
                    ),
                  ),
                ),
              );
            } else if (state is InternetLostState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("No internet connection!"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildNoInternetWidget() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "No Internet Connection!",
              style: TextStyle(
                color: Colors.red,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Lottie.asset('assets/no_wifi.json'),
          ],
        ),
      ),
    );
  }
}
