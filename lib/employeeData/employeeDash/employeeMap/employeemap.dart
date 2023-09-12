import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';


class EmployeeMap extends StatefulWidget {
  EmployeeMap({Key? key}) : super(key: key);

  @override
  _EmployeeMapState createState() => _EmployeeMapState();
}

class _EmployeeMapState extends State<EmployeeMap> {
  double? getLat;
  double? getLong;

  double? currentLat;
  double? currentLong;
  bool locationError = false;
  final Geolocator geolocator = Geolocator();
  String address = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkLocationPermission();
    checkLocationPermissionAndFetchLocation();

    display();
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

  void _startGeoFencingUpdate() {
    final double? geofenceLatitude = getLat;
    final double? geofenceLongitude = getLong;
    const double geofenceRadius = 250.0;

    double distance = Geolocator.distanceBetween(
        geofenceLatitude!, geofenceLongitude!, currentLat!, currentLong!);

    if (distance <= geofenceRadius) {
      inRadius();
    } else if (distance >= geofenceRadius) {
      outRadius();
    }
  }

  void display() {
    print("${getLat} ${getLong}");
  }

  Future<void> checkLocationPermissionAndFetchLocation() async {
    final permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      try {
        final data = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          currentLat = data.latitude;
          currentLong = data.longitude;
          locationError = false;
        });
        getAddress(currentLat, currentLong);
      } catch (e) {
        print('Error getting location: $e');
      }
    } else {
      setState(() {
        locationError = true;
      });
    }
  }

  void inRadius() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congrats'),
          content: const Text('Your Attendance Is MARKED'),
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

  void outRadius() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Oh No'),
          content: const Text('Your Attendance did"nt MARKED'),
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
    setState(() {
      address =
          "${placemarks[0].street!}, ${placemarks[4].street!} , ${placemarks[0].country!}";
    });
/*
    for (int i = 0; i < placemarks.length; i++) {
      print("INDEX $i ${placemarks[i]}");
    }

 */
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    if (locationError) {
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
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFE26142),
          elevation: 0,
          title: Row(
            children: [
              const Text("Employee"),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _startGeoFencingUpdate,
                child: const Icon(Icons.check, color: Colors.teal),
              ),
            ],
          ),
        ),
        body: (currentLat != null && currentLong != null)
            ? OpenStreetMapSearchAndPick(
                center: LatLong(currentLat!, currentLong!),
                onPicked: (pickedData) {
                  getAddress(pickedData.latLong.latitude,
                      pickedData.latLong.longitude);
                },
                locationPinIconColor: const Color(0xFFE26142),
                locationPinText: "${address}",
              )
            :  const Center(
                child: CircularProgressIndicator(),
              ),
      );
    }
  }
}
