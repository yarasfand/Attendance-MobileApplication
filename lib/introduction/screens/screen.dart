import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/bloc_internet/internet_checking.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> with SingleTickerProviderStateMixin {
  bool allPointsDisplayed = false;

  // Function to set the shared preference value
  Future<void> setIntroScreenVisited(bool visited) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('intro_screen_visited', visited);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Your company logo
              SizedBox(
                width: 250,
                height: 250,
                child: Image.asset(
                  'assets/images/pioneer_logo_app.png',
                ),
              ),

              // Lottie animation with a fixed size
              Expanded(
                child: Container(
                  child: Lottie.asset(
                    "assets/animations/clock3.json",
                    repeat: true,
                    onLoaded: (_) {
                      // Animation has loaded, set the flag to true
                      setState(() {
                        allPointsDisplayed = true;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Text description
              const Text(
                'Welcome to Pioneer Times Biometric',
                style: TextStyle(
                  fontSize: 25, // Increase the font size
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor, // Change the text color
                  letterSpacing: 1.5, // Add letter spacing for emphasis

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
                    backgroundColor: MaterialStatePropertyAll(
                      AppColors.primaryColor,
                    ),
                  ),
                  onPressed: () async{
                    await setIntroScreenVisited(true);
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

class _FadingCircleState extends State<FadingCircle> {
  double _opacity = 0.0; // Initial opacity

  @override
  void initState() {
    super.initState();
    // Add a delay before starting the fade animation
    Future.delayed(Duration(seconds: widget.delay), () {
      setState(() {
        _opacity = 1.0; // Set opacity to 1 to fade in
      });
    });
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
              color: AppColors.darkGrey,
            ),
          ),
        ),
        const SizedBox(
            width: 10.0), // Adjust the spacing between the circle and text
        AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 1), // Adjust the duration as needed
          child: Text(widget.text),
        ),
      ],
    );
  }
}
