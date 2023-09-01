import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/bloc_internet/internet_checking.dart';
import 'package:project/introduction_screens/screen1.dart';
import 'package:project/introduction_screens/screen2.dart';
import 'package:project/introduction_screens/screen3.dart';
import 'package:project/login_bloc/loginbloc.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../login_page.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  bool lastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              setState(() {
                lastPage =
                    (index == 2); // return true if index is 2 or last page
              });
            },
            controller: _controller,
            children: const [
              Screen1(),
              Screen2(),
              Screen3(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(2);
                  },
                  child: const Text("Skip"),
                ),
                SmoothPageIndicator(controller: _controller, count: 3),
                lastPage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return AfterIntro();
                            },
                          ));
                        },
                        child: const Text("Done"),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.linear);
                        },
                        child: const Text("Next"),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
