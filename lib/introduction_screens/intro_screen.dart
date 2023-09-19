  import 'package:flutter/material.dart';
  import 'package:project/introduction_screens/screen1.dart';

  class IntroScreen extends StatefulWidget {
    const IntroScreen({Key? key}) : super(key: key);

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
              children:  [
                Screen1(),
              ],
            ),

          ],
        ),
      );
    }
  }
