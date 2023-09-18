import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:project/bloc_internet/internet_bloc.dart';
import 'package:project/bloc_internet/internet_state.dart';

class AdminGpsTrackerReport extends StatefulWidget {
  const AdminGpsTrackerReport({Key? key}) : super(key: key);

  @override
  State<AdminGpsTrackerReport> createState() => _AdminGpsTrackerReportState();
}

class _AdminGpsTrackerReportState extends State<AdminGpsTrackerReport> {
  final String employeeName = 'User\'s Name';
  final String currentDate = 'September 15, 2023';

  bool? locationError;
  double? currentLat;
  double? currentLong;
  String address = "";

  @override
  void initState() {
    super.initState();
    checkLocationPermissionAndFetchLocation();
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
          address = await getAddress(currentLat, currentLong);
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

  Future<void> _currentLocation(BuildContext context) async {
    if (currentLat != null && currentLong != null) {
      _buildLocationPopup(context);
    } else {
      _buildLocationErrorDialog(context);
    }
  }

  void _buildLocationErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Oh No!'),
          content: Text('Please Turn On Your Location'),
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
  }

  Future<void> _buildLocationPopup(BuildContext context) async {
    address = await getAddress(currentLat, currentLong);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Your Current Location Is'),
          content: Text('$address'),
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetBloc, InternetStates>(
        listener: (context, state) {
      // TODO: implement listener
    }, builder: (context, state) {
      if (state is InternetGainedState) {
        return Scaffold(
          appBar: AppBar(
            title: Text('GPS Tracker Report'),
            backgroundColor: Color(0xFFE26142),
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
                        onPressed: () {
                          _currentLocation(context); // Call the method here
                        },
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
      } else if (state is InternetLostState) {
        return Expanded(
          child: Scaffold(
            body: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No Internet Connection!",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
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
        return Expanded(
          child: Scaffold(
            body: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No Internet Connection!",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Lottie.asset('assets/no_wifi.json'),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    });
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
