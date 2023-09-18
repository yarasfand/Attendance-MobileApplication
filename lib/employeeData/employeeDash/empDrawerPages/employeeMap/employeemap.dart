import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeMap extends StatefulWidget {
  EmployeeMap({Key? key}) : super(key: key);

  @override
  _EmployeeMapState createState() => _EmployeeMapState();
}

class _EmployeeMapState extends State<EmployeeMap> {
  double? getLat;
  double? getLong;
  double? getRadius;

  double? currentLat;
  double? currentLong;
  bool locationError = false;
  String address = "";

  File? selectedImage;
  String base64Image = "";

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    loadCoordinatesFromSharedPreferences();
    display();
    checkLocationPermissionAndFetchLocation();
  }

  Future<void> loadCoordinatesFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final latitude = prefs.getDouble('latitude');
    final longitude = prefs.getDouble('longitude');

    if (latitude != null && longitude != null) {
      getLat = latitude;
      getLong = longitude;

      print("Latitude: $getLat");
      print("Longitude: $getLong");
    }  else {}
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

  void _startGeoFencingUpdate() {
    final double? geofenceLatitude = getLat;
    final double? geofenceLongitude = getLong;
    const double geofenceRadius = 250;

    if (geofenceLatitude != null &&
        geofenceLongitude != null &&
        currentLat != null &&
        currentLong != null) {
      double distance = Geolocator.distanceBetween(
        geofenceLatitude,
        geofenceLongitude,
        currentLat!,
        currentLong!,
      );

      if (distance <= geofenceRadius) {
        inRadius();
      } else if (distance >= geofenceRadius) {
        outRadius();
      }
    }
  }

  Future<void> display() async {
    await loadCoordinatesFromSharedPreferences();
    print("${getLat} ${getLong}");
    await checkLocationPermissionAndFetchLocation();
    print("${currentLat} ${currentLong}");
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
          content: const Text('Your Attendance did not get MARKED'),
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

  Future<void> chooseImage() async {
    var image;
    image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
        base64Image = base64Encode(selectedImage!.readAsBytesSync());
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTime = DateFormat('hh:mm a').format(DateTime.now());
    final currentDate = DateFormat('MMM dd, yyyy').format(DateTime.now());

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
    } else if ((currentLat != null && currentLong != null)) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFE26142),
          elevation: 0,
          title: const Center(
            child: Text(
              "Attendance Portal",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              CircleAvatar(
                radius: MediaQuery.of(context).size.height / 5,
                backgroundColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(8), // Border radius
                  child: ClipOval(
                      child: selectedImage != null
                          ? Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              "assets/icons/man.png",
                            )),
                ),
              ),
              if (address.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            "Your Location:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          "Address: $address",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 7),
                        Text(
                          "Date: $currentDate",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Time: $currentTime",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: ElevatedButton(
                  onPressed: chooseImage,
                  child: const Text("Click Your Photo"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedImage == null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                                'Please take a photo before proceeding.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      _startGeoFencingUpdate();
                    }
                  },
                  child: const Text("Mark Your Attendance"),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      checkLocationPermissionAndFetchLocation();
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Fetching Location..."),
              SizedBox(height: 16),
              Text("Go Back And Turn On Location..."),
            ],
          ),
        ),
      );
    }
  }
}
