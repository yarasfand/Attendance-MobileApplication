import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../constants.dart';


class AdminGpsTrackerReport extends StatefulWidget {
  const AdminGpsTrackerReport({Key? key}) : super(key: key);

  @override
  State<AdminGpsTrackerReport> createState() => _AdminGpsTrackerReportState();
}

class _AdminGpsTrackerReportState extends State<AdminGpsTrackerReport> {
  final String employeeName = 'User\'s Name';
  final String currentDate = 'September 15, 2023';

  bool locationError = false;
  double? currentLat;
  double? currentLong;
  String address = "";

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    checkLocationPermissionAndFetchLocation();
  }

  Future<void> checkLocationPermission() async {
    Geolocator.getServiceStatusStream().listen((status) {
      if (mounted) {
        setState(() {
          locationError = status != ServiceStatus.enabled;
        });
      }
    });
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

  getAddress(lat, long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    if (mounted) {
      setState(() {
        address =
        "${placemarks[0].street!}, ${placemarks[4].street!} , ${placemarks[0].country!}";
      });
    }
  }


  Future<void> _showSnackbar(BuildContext context, String message)   async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green, // Set the background color to green
      ),
    );
  }
  void getInfoOnAdd() {
    if (address.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Location'),
            content: Text(' $address '),
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
      // _showSnackbar(context, "Address Fetch Successfully.");
    } else {
      _showSnackbar(context, "Address not available yet");
    }
  }


  @override
  Widget build(BuildContext context) {
    if (currentLat != null && currentLong != null && !locationError) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Reports Page", style: AdminkAppBarTextTheme),
          backgroundColor: Color(0xFFE26142),
          iconTheme: const IconThemeData(
            color: Colors.white, // Set the icon color to white
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xFFE26142)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInfoRow('Employee:', employeeName),
                    _buildInfoRow('Current Date:', currentDate),
                    const SizedBox(height: 16),
                    _buildElevatedButton(
                      text: 'Get Current Location',
                      icon: Icons.location_on,
                      onPressed: getInfoOnAdd, // Call the function here
                    ),
                    const SizedBox(height: 16),
                    _buildElevatedButton(
                      text: 'Get Route Direction',
                      icon: Icons.directions,
                      onPressed: _handleRouteDirection,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else if (address.isEmpty) {
      checkLocationPermissionAndFetchLocation();
      return  Scaffold(
        appBar: AppBar(
          title: Text(
            'GPS Tracker Report',
          style: AdminkAppBarTextTheme,),
          iconTheme: const IconThemeData(
            color: Colors.white, // Set the icon color to white
          ),
          backgroundColor: Color(0xFFE26142),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Fetching Address..."),
              SizedBox(height: 16),
              Text("Go Back And Turn On Location..."),
            ],
          ),
        ),
      );
    } else {
      checkLocationPermissionAndFetchLocation();
      return  Scaffold(
        appBar: AppBar(
          title:  Text(
            'GPS Tracker Report',
            style: AdminkAppBarTextTheme,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white, // Set the icon color to white
          ),
          backgroundColor: const Color(0xFFE26142),
        ),
        body: Center(
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
  }

  Widget _buildInfoRow(String label, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              info,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElevatedButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        backgroundColor: Color(0xFFE26142),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: Icon(
        icon,
        size: 24,
      ),
      label: Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  void _handleCurrentLocation() {
    // Handle current location button press
  }

  void _handleRouteDirection() {
    // Handle route direction button press
  }
}
