import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class MyDashBody extends StatefulWidget {
  const MyDashBody({Key? key});

  @override
  State<MyDashBody> createState() => _MyDashBodyState();
}

class _MyDashBodyState extends State<MyDashBody> {

  String? userData = 'Data not available'; // Initialize with a default value

  @override
  void initState() {
    super.initState();
     _loadUserDataFromPrefs(); // Load user data when the widget is initialized
  }
  Future<String?> _loadUserDataFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? corporateID = prefs.getString('corporateID');
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    String loadedUserData = 'Corporate ID: $corporateID, Username: $username, Password: $password';
    return loadedUserData;

    setState(() {
      userData = loadedUserData; // Update the state with the loaded data
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance:',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: ItemDashboard(
                    title: 'CheckIn',
                    iconData: Icons.check,
                    background: Colors.deepPurple,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: ItemDashboard(
                    title: 'Checkout',
                    iconData: Icons.logout,
                    background: Colors.teal,
                  ),
                ),
              ],
            ),
            FutureBuilder<String?>(
              future: _loadUserDataFromPrefs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Data is still being loaded
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // Error occurred while loading data
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Data loaded successfully
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    // ... Rest of your widget's content

                    // Display the retrieved data
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Data:',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          snapshot.data ??
                              'Data not available',
                          style: TextStyle(fontSize: 18),
                        ),

                        // ... Rest of your widget's content
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ItemDashboard extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color background;

  const ItemDashboard({
    required this.title,
    required this.iconData,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            color: background.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              color: background,
              size: 40,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
