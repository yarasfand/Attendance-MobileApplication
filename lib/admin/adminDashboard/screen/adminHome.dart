import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../No_internet/no_internet.dart';
import '../../../introduction/bloc/bloc_internet/internet_bloc.dart';
import '../../../introduction/bloc/bloc_internet/internet_state.dart';
import 'admin_page.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetBloc, InternetStates>(builder: (context, state) {
      if (state is InternetGainedState) {
        return  Scaffold(
          backgroundColor: Colors.transparent,
          body: AdminPage(),
        );
      } else if (state is InternetLostState) {
        return FutureBuilder<void>(
          future: Future.delayed(const Duration(seconds: 5), () => true),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return NoInternet(); // Replace with the actual NoInternet widget
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
            }
            // You can return a loading indicator or something else while waiting for the delay.
            return CircularProgressIndicator();
          },
        );
      } else {
        return FutureBuilder<void>(
          future: Future.delayed(const Duration(seconds: 5), () => true),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return NoInternet(); // Replace with the actual NoInternet widget
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
            }
            // You can return a loading indicator or something else while waiting for the delay.
            return CircularProgressIndicator();
          },
        );
      }
    });
  }
}
