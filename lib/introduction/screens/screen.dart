import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login/screens/loginPage.dart';
import '../bloc/bloc_internet/internet_checking.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> with SingleTickerProviderStateMixin {
  bool allPointsDisplayed = false;
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Add a listener to the animation controller
    _controller.addStatusListener((status) {

    });

    _controller.forward();
  }

  // Function to set the shared preference value
  Future<void> setIntroScreenVisited(bool visited) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('intro_screen_visited', visited);
  }

  double getHeightValue(double screenHeight) {
    if (screenHeight > 1000) {
      return 200.0;
    } else if (screenHeight > 720) {
      return 150.0;
    } else if (screenHeight > 500) {
      return 100.0;
    } else {
      return 80.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: getHeightValue(MediaQuery.of(context).size.height),
            horizontal: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Welcome text with a simpler font
              Text(
                'Welcome to Pioneer Cloud App',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor,
                    letterSpacing: 1.5,
                  ),
                ),
                textAlign: TextAlign.center,
              ),


              // Lottie animation with a fixed size
              Container(
                height: 150,
                child: Lottie.asset(
                  "assets/animations/animatedClock3.json",
                  repeat: false,
                  controller: _controller,
                  onLoaded: (_) {
                    // Animation has loaded, set the flag to true
                    setState(() {
                      allPointsDisplayed = true;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Lorem Ipsum text without fade-in animation
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildBulletPoint("Geo-Attendance Tracking"),
                  _buildBulletPoint("Summarised Attendance Details"),
                  _buildBulletPoint("Simplified Leave Requests"),
                ],
              ),

              // SizedBox(height: (MediaQuery.of(context).size.height) > 720 ? 40 : 20 ),

              // Next button (conditionally displayed)
              if (allPointsDisplayed)
                Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0), // Set the circular radius
                  ),
                  color: AppColors.primaryColor,
                  child: GestureDetector(
                    onTap: () async {
                      await setIntroScreenVisited(true);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginPage();
                          },
                        ),
                      );
                    },
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: const Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

Widget _buildBulletPoint(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
