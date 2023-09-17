import 'package:flutter/material.dart';
import 'package:project/bloc_internet/internet_checking.dart';
import 'package:project/introduction_screens/screen1.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              setState(() {
                // return true if index is 2 or last page
              });
            },
            controller: _controller,
            children: const [
              Screen1(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return const AfterIntro();
                      },
                    ));
                  },
                  child: const Text("Done"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
