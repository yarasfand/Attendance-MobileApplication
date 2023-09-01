import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class Screen3 extends StatelessWidget {
  const Screen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/welcome.json'),
              ],

            ),
          ),
        )

    );
  }
}