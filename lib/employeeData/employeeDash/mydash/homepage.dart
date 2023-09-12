import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../employeeMap/employeemap.dart';
class DashHome extends StatefulWidget {
  const DashHome({Key? key}) : super(key: key);
  @override
  State<DashHome> createState() => _HomePageState();
}

class _HomePageState extends State<DashHome> {
  late bool locationError = true;
  double? lat;
  double? long;

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    checkLocationPermissionAndFetchLocation();
  }

  Future<void> checkLocationPermission() async {
    Geolocator.getServiceStatusStream().listen((status) {
      if (status == ServiceStatus.enabled) {
        setState(() {
          locationError = false;
        });
      } else {
        setState(() {
          locationError = true;
        });
      }
    });
  }

  Future<void> checkLocationPermissionAndFetchLocation() async {
    final permission = await Geolocator.checkPermission();
    final serviceStatus = await Geolocator.isLocationServiceEnabled();

    if (permission != LocationPermission.denied || serviceStatus) {
      try {
        setState(() {
          locationError = false;
        });
      } catch (e) {
        print('Error getting location: $e');
        setState(() {
          locationError = true;
        });
      }
    } else {
      locationError = true;
    }
  }


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
          builder: (context) => EmployeeMap(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());

    //FIRST APPROACH
    return  SingleChildScrollView(
        child: Column(
            children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          "assets/icons/man.png",
                          width: 120,
                          height: 80,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onTapMaps,
                      child: ItemDashboard(
                        showShadow: false,
                        title: 'Mark Attendance',
                        customIcon: Image.asset(
                          "assets/icons/locate.png",
                          width: 120,
                          height: 80,
                        ),
                        background: Color(0xFFE26142),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 80,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  width: 5,
                ),
                ProfileInfoCard(firstText: "IN", secondText: "00:00"),
                SizedBox(
                  width: 10,
                ),
                ProfileInfoCard(firstText: "Status", secondText: "A"),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 10,
                ),
                ProfileInfoCard(firstText: "OUT", secondText: "00:00"),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Welcome Asfand!",
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: Colors.black87),
          ),
          const SizedBox(height: 10),
          Text(
            formattedDate,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Table(
            children: [
              TableRow(
                children: [
                  ProfileInfoBigCard(
                    firstText: "20",
                    secondText: "Total Present",
                    icon: Image.asset(
                      "assets/icons/Attend.png",
                      width: 35,
                    ),
                  ),
                  ProfileInfoBigCard(
                    firstText: "8",
                    secondText: "Total Absent",
                    icon: Image.asset(
                      "assets/icons/absence.png",
                      width: 35,
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  ProfileInfoBigCard(
                    firstText: "0 - 4 ",
                    secondText: "Leaves/Holiday",
                    icon: Image.asset(
                      "assets/icons/holiday.png",
                      width: 35,
                    ),
                  ),
                  ProfileInfoBigCard(
                    firstText: "7",
                    secondText: "Working Days",
                    icon: Image.asset(
                      "assets/icons/business.png",
                      width: 35,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: [
                    GestureDetector(
                      child: ItemDashboard(
                        showShadow: false,
                        title: 'Leave Request',
                        customIcon: Image.asset(
                          "assets/icons/leave.png",
                          width: 120,
                          height: 80,
                        ),
                        background: const Color(0xFFE26142),
                      ),
                    ),
                    GestureDetector(
                      child: ItemDashboard(
                        showShadow: false,
                        title: 'Reports',
                        customIcon: Image.asset(
                          "assets/icons/report.png",
                          width: 120,
                          height: 80,
                        ),
                        background: const Color(0xFFE26142),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            color: Colors.grey,
            thickness: 1,
            indent: 60,
            endIndent: 60,
          ),

          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Column(
              children: [
                Text(
                  'Contact Us',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8), // Adjust the spacing between the lines
                Text(
                  'Powered by Pioneer',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 10,
          ),
        ])
    );


    //SECOND APPROACH ***************************
    /*
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Color(0xFFE26142),
        elevation: 0,
        title: Center(
          child: Text("E-ID 0097"),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              // Add your settings icon functionality here
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              "assets/icons/man.png",
                              width: 120,
                              height: 80,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: onTapMaps,
                          child: ItemDashboard(
                            showShadow: false,
                            title: 'Mark Attendance',
                            customIcon: Image.asset(
                              "assets/icons/locate.png",
                              width: 120,
                              height: 80,
                            ),
                            background: Color(0xFFE26142),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.only(top: 50),
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Welcome Asfand!",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 10), // Add some spacing
                      // Current day and date
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      Table(
                        children: [
                          TableRow(
                            children: [
                              ProfileInfoBigCard(
                                firstText: "20",
                                secondText: "Total Present",
                                icon: Image.asset(
                                  "assets/icons/Attend.png",
                                  width: 35,
                                ),
                              ),
                              ProfileInfoBigCard(
                                firstText: "8",
                                secondText: "Total Absent",
                                icon: Image.asset(
                                  "assets/icons/absence.png",
                                  width: 35,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              ProfileInfoBigCard(
                                firstText: "0 - 4 ",
                                secondText: "Leaves/Holiday",
                                icon: Image.asset(
                                  "assets/icons/holiday.png",
                                  width: 35,
                                ),
                              ),
                              ProfileInfoBigCard(
                                firstText: "7",
                                secondText: "Working Days",
                                icon: Image.asset(
                                  "assets/icons/business.png",
                                  width: 35,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              children: [
                                GestureDetector(
                                  onTap: onTapMaps,
                                  child: ItemDashboard(
                                    showShadow: false,
                                    title: 'Leave Request',
                                    customIcon: Image.asset(
                                      "assets/icons/leave.png",
                                      width: 120,
                                      height: 80,
                                    ),
                                    background: Color(0xFFE26142),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: onTapMaps,
                                  child: ItemDashboard(
                                    showShadow: false,
                                    title: 'Reports',
                                    customIcon: Image.asset(
                                      "assets/icons/report.png",
                                      width: 120,
                                      height: 80,
                                    ),
                                    background: Color(0xFFE26142),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 1, // Height of the spacing line
                        color: Colors.grey, // Make the line color transparent
                        thickness:
                            1, // Adjust the thickness (you can make it smaller)
                        indent: 60, // Left padding (optional)
                        endIndent: 60, // Right padding (optional)
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      const Center(
                        child: Column(
                          children: [
                            Text(
                              'Contact Us',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(
                                height:
                                    8), // Adjust the spacing between the lines
                            Text(
                              'Powered by Pioneer',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
          Positioned(
            top: screenHeight * (3 / 9) - 80 / 2,
            left: 16,
            right: 16,
            child: Container(
              height: 80,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  ProfileInfoCard(firstText: "IN", secondText: "00:00"),
                  SizedBox(
                    width: 10,
                  ),
                  ProfileInfoCard(firstText: "Status", secondText: "A"),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ProfileInfoCard(firstText: "OUT", secondText: "00:00"),
                ],
              ),
            ),
          ),
        ],
      ),
    );     */
  }
}

class ItemDashboard extends StatelessWidget {
  final String title;
  final Widget customIcon;
  final Color background;
  final bool showShadow;
  final double iconSize;

  const ItemDashboard({
    super.key,
    required this.title,
    required this.customIcon,
    required this.background,
    this.showShadow = true,
    this.iconSize = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  offset: const Offset(4, 10),
                  color: background.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: customIcon, // Use the custom icon widget here
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

class ProfileInfoCard extends StatelessWidget {
  final firstText, secondText, hasImage, imagePath;

  const ProfileInfoCard({
        super.key,
        this.firstText,
        this.secondText,
        this.hasImage = false,
        this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: hasImage
            ? Center(
                child: Image.asset(
                  imagePath,
                  width: 25,
                  height: 25,
                ),
              )
            : TwoLineItem(
                firstText: firstText,
                secondText: secondText,
              ),
      ),
    );
  }
}

class TwoLineItem extends StatelessWidget {
  final String firstText, secondText;

  const TwoLineItem({super.key, required this.firstText, required this.secondText});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          firstText,
          style: const TextStyle(
            fontSize: 22.0,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          secondText,
          style: const TextStyle(
            fontSize: 18.0,
            color: Color(0xFF8391A0),
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }
}

class ProfileInfoBigCard extends StatelessWidget {
  final String firstText, secondText;
  final Widget icon;

  const ProfileInfoBigCard(
      {super.key, required this.firstText, required this.secondText, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFE26142),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          top: 16,
          bottom: 18,
          right: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: icon,
            ),
            Text(
              firstText,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              secondText,
              style: const TextStyle(
                fontSize: 19.0,
                color: Colors.white70,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
