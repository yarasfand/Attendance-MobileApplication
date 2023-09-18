import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:project/bloc_internet/internet_bloc.dart';
import 'package:project/bloc_internet/internet_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminMapDisplay extends StatefulWidget {
  final VoidCallback openDrawer;
  const AdminMapDisplay({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<AdminMapDisplay> createState() => _MapDisplayState();
}

class _MapDisplayState extends State<AdminMapDisplay> {
  double? currentLat;
  double? currentLong;
  double? sendLat;
  double? sendLong;
  String address = "";

  bool locationError = false;

  @override
  void initState() {
    super.initState();
    checkLocationPermissionAndFetchLocation();
  }

  Future<void> saveLocationToSharedPreferences(double lat, double long) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', lat);
    await prefs.setDouble('longitude', long);
  }

  Future<void> checkLocationPermissionAndFetchLocation() async {
    final permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        final data = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        if (mounted) {
          currentLat = data.latitude;
          currentLong = data.longitude;
          address = getAddress(currentLat, currentLong);
          locationError = false;
        }
      } catch (e) {
        print('Error getting location: $e');
      }
    } else {
      if (mounted) {
        locationError = true;
      }
    }
  }

  Future<void> checkSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final latitude = prefs.getDouble('latitude');
    final longitude = prefs.getDouble('longitude');

    print('Latitude: $latitude');
    print('Longitude: $longitude');
  }

  getAddress(double? lat, double? long) async {
    if (lat != null && long != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      if (mounted) {
        setState(() {
          address =
              "${placemarks[0].street!}, ${placemarks[4].street!} , ${placemarks[0].country!}";
        });
      }
    } else {}
  }

  Future<void> showSnackbar(BuildContext context, String message) async {
    await SharedPreferences.getInstance();

    if (sendLat != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green, // Set the background color to green
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetBloc, InternetStates>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is InternetGainedState) {
            if (currentLat != null && currentLong != null && !locationError) {
              return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const FaIcon(FontAwesomeIcons.bars),
                    color: Colors.white,
                    onPressed: widget.openDrawer,
                  ),
                  backgroundColor: const Color(0xFFE26142),
                  elevation: 0,
                  title: const Center(
                    child: Padding(
                      padding:
                          EdgeInsets.only(right: 55.0), // Add right padding
                      child: Text(
                        "GEOFENCING",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                body: Stack(
                  children: [
                    OpenStreetMapSearchAndPick(
                      center: LatLong(currentLat!, currentLong!),
                      buttonColor: const Color(0xFFE26142),
                      buttonText: 'Get This Point',
                      onPicked: (pickedData) {
                        getAddress(pickedData.latLong.latitude,
                            pickedData.latLong.longitude);
                        setState(() {
                          sendLat = pickedData.latLong.latitude;
                          sendLong = pickedData.latLong.longitude;
                          saveLocationToSharedPreferences(sendLat!, sendLong!);
                        });
                        showSnackbar(context, "Cordinates Are Saved");
                      },
                      locationPinIconColor: const Color(0xFFE26142),
                      locationPinText: "${address}",
                    ),
                    Positioned(
                      top: (MediaQuery.of(context).size.height / 2) -
                          90 -
                          10, // Adjust position as needed
                      left: (MediaQuery.of(context).size.width / 2) -
                          30 -
                          20,
                      child: Container(
                        width: 100, // Adjust the radius as needed
                        height: 100, // Adjust the radius as needed
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFE26142).withOpacity(0.25),
                          border: Border.all(
                            color: const Color(0xFFE26142),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              checkLocationPermissionAndFetchLocation();
              return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const FaIcon(FontAwesomeIcons.bars),
                    color: Colors.white,
                    onPressed: widget.openDrawer,
                  ),
                  backgroundColor: const Color(0xFFE26142),
                  elevation: 0,
                  title: const Center(
                    child: Padding(
                      padding:
                          EdgeInsets.only(right: 55.0), // Add right padding
                      child: Text(
                        "GEOFENCING",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                body: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text("Fetching Location..."),
                      SizedBox(height: 16),
                      Text("Turn On Location..."),
                    ],
                  ),
                ),
              );
            }
          } else if (state is InternetLostState) {
            return Expanded(
              child: Scaffold(
                body: Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "No Internet Connection!",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Lottie.asset('assets/no_wifi.json'),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            checkLocationPermissionAndFetchLocation();
            return Scaffold(
              appBar: AppBar(
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
                      "GEOFENCING",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              body: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Fetching Location..."),
                    SizedBox(height: 16),
                    Text("Turn On Location..."),
                  ],
                ),
              ),
            );
          }
        });
  }
}
