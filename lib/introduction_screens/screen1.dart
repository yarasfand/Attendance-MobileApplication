import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../bloc_internet/internet_checking.dart';


class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> with SingleTickerProviderStateMixin{
  bool allPointsDisplayed = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Your company logo
              Image.asset('assets/images/pioneer_logo_app.png',
                  height: 150, width: 150),
              const SizedBox(height: 20),
              // Lottie animation with a fixed size
              Container(
                height: 200,
                width: 200,
                child: Lottie.asset(
                  "assets/images/security.json",
                  repeat: false,
                  onLoaded: (_) {
                    // Animation has loaded, set the flag to true
                    setState(() {
                      allPointsDisplayed = true;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Text description
              const Text(
                'Welcome to Pioneer Times',
                style: TextStyle(
                  fontSize: 25, // Increase the font size
                  fontWeight: FontWeight.bold,
                  color: Colors.orange, // Change the text color
                  letterSpacing: 1.5, // Add letter spacing for emphasis
                  shadows: [
                    Shadow(
                      blurRadius: 2.0,
                      color: Colors.grey, // Add a subtle shadow
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              // List of features
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  FadingCircle(delay: 0, text: 'Cloud Based Attendance System'),
                  const SizedBox(
                    height: 4,
                  ),
                  FadingCircle(delay: 1, text: 'Face Recognition System'),
                  const SizedBox(
                    height: 4,
                  ),
                  FadingCircle(
                      delay: 2, text: 'FingerPrint Authentication System'),
                  const SizedBox(
                    height: 4,
                  ),
                  FadingCircle(delay: 3, text: 'Access Control'),
                  const SizedBox(
                    height: 4,
                  ),
                  FadingCircle(delay: 4, text: 'Mobile Application'),
                  const SizedBox(
                    height: 4,
                  ),
                  FadingCircle(delay: 5, text: 'Entrance Control'),
                  const SizedBox(
                    height: 4,
                  ),
                  FadingCircle(delay: 6, text: 'Card Entry'),
                  const SizedBox(
                    height: 4,
                  ),
                  FadingCircle(delay: 7, text: 'Cloud Software'),
                  const SizedBox(
                    height: 4,
                  ),
                  FadingCircle(delay: 8, text: 'Security'),
                ],
              ),
              const SizedBox(height: 20),
              // Next button (conditionally displayed)
              if (allPointsDisplayed)
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.orange)),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return const AfterIntro();
                      },
                    ));
                  },
                  child: const Text('Next'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class FadingCircle extends StatefulWidget {
  final int delay;
  final String text;

  FadingCircle({required this.delay, required this.text});

  @override
  _FadingCircleState createState() => _FadingCircleState();
}

class _FadingCircleState extends State<FadingCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _opacity = 0.0; // Initial opacity

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // Use the ticker provided by SingleTickerProviderStateMixin
      duration: const Duration(seconds: 1), // Adjust the duration as needed
    );

    // Add a delay before starting the fade animation
    Future.delayed(Duration(seconds: widget.delay), () {
      if (mounted) {
        _controller.forward(from: 0.0); // Start the animation from the beginning
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the animation controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 1), // Adjust the duration as needed
          child: Container(
            width: 10, // Adjust the size of the circle as needed
            height: 10,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange,
            ),
          ),
        ),
        const SizedBox(width: 10.0), // Adjust the spacing between the circle and text
        AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 1), // Adjust the duration as needed
          child: Text(widget.text),
        ),
      ],
    );
  }
}


