import 'package:flutter/material.dart';
import 'package:project/introduction/screens/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  int currentPageIndex = 0; // Initialize with the first page index

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        currentPageIndex = _controller.page?.round() ?? 0;
      });
    });
  }

  Future<void> setIntroScreenVisited() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('intro_screen_visited', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            controller: _controller,
            children: const [
              Screen1(),
              // Add more pages if needed
            ],
          ),
          // Example of conditional rendering based on the current page index
          if (currentPageIndex == 2)
            Positioned(
              bottom: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: () async {
                  // Do something when on the last page
                  await setIntroScreenVisited();
                },
                child: const Text('Next'),
              ),
            ),
        ],
      ),
    );
  }
}

