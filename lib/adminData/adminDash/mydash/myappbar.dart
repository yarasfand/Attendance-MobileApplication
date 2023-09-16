import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/adminData/adminDash/adminMap/adminMapdisplay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppBar extends StatefulWidget {
  final VoidCallback openDrawer;

  const MyAppBar({
    Key? key,
    required this.openDrawer,
  }) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {


  late bool locationError = true;
  double? lat;
  double? long;
  String? corporateID;
  String? username;
  String? password;

  @override
  void initState() {
    super.initState();
    // fetchUserData();
  }

  // Future<void> fetchUserData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setDouble('longitude', long ?? 0.0); // Replace 0.0 with your default value if 'long' is null
  //   await prefs.setDouble('latitude', lat ?? 0.0);   // Replace 0.0 with your default value if 'lat' is null
  //   await prefs.setString('radius', '250.0');
  //   _showSnackBar('Data saved successfully');
  // }

  // Future<void> checkSharedPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final longitude = prefs.getDouble('longitude');
  //   final latitude = prefs.getDouble('latitude');
  //   final radius = prefs.getString('radius');
  //
  //   print('Longitude: $longitude');
  //   print('Latitude: $latitude');
  //   print('Radius: $radius');
  // }


/*

  void onTapMaps() {
    if (locationError) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Turn On Location'),
            content:
            const Text('Please turn on your location to use this feature.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminMapDisplay(),
        ),
      );
    }
  }
*/

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(message),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const FaIcon(FontAwesomeIcons.bars),
        color: Colors.white,
        onPressed: widget.openDrawer,
      ),
      backgroundColor: const Color(0xFFE26142),
      elevation: 0,
      title: const Center(
        child: Padding(
          padding: EdgeInsets.only(right: 55.0), // Add right padding
          child: Text(
            "       ADMIN",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      actions: [
        IconButton(onPressed: () async{
          Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => AdminMapDisplay()));
        }, icon: Icon(Icons.map,color: Colors.white,),),
      ],
    );
  }
}
