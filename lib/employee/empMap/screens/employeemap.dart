import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';

import '../models/attendanceGeoFencingModel.dart';
import '../models/attendanceGeoFencingRepository.dart';

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
  String fullAddress = "";
  String countryName = "";

  File? selectedImage;
  String base64Image = "";
  late String sublocaity;

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    display();
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

  Future<void> _startGeoFencingUpdate() async {
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

  Future<void> _markAttendance() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String cardNo = prefs.getString('cardNo') ?? " ";
    String imei="fake imei";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo? androidInfo;
    Future<AndroidDeviceInfo> getInfo() async {
      return await deviceInfo.androidInfo;
    }

    print(getInfo());
    if (selectedImage == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please take a photo before proceeding.'),
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
      final base64Image = base64Encode(selectedImage!.readAsBytesSync());
      final geoFenceModel = GeoFenceModel(
        cardNo: cardNo,
        location: fullAddress,
        lan: currentLat.toString(),
        long: currentLong.toString(),
        imageData: base64Image,
        imeiNo: imei ,
        temp1: '',
        temp2: '',
        attendanceType: null,
        remark1: remarks,
        imagePath: '',
        punchDatetime: DateTime.now(),
      );
      final geoFenceRepository = GeoFenceRepository();

      try {
        await geoFenceRepository.postData(geoFenceModel);
        Fluttertoast.showToast(
          msg: 'Attendance marked successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } catch (e) {
        print('Error making API request: $e');
        Fluttertoast.showToast(
          msg:
              'Failed to mark attendance. Please check your internet connection.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  Future<void> display() async {
    await checkLocationPermissionAndFetchLocation();
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
          await getAddress(currentLat!, currentLong!);
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

  Future<void> getAddress(double lat, double long) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, long);
      if (mounted && placemarks.isNotEmpty) {
        setState(() {
          if (placemarks[0].street != null) {
            fullAddress = placemarks[0].street!;
          }
          if (placemarks[0].subLocality != null) {
            sublocaity = placemarks[0].subLocality!;
          }
          final List<String> countryNameParts = [];
          if (placemarks[0].locality != null) {
            countryNameParts.add(placemarks[0].locality!);
          }
          if (placemarks[0].country != null) {
            countryNameParts.add(placemarks[0].country!);
          }
          countryName = countryNameParts.join(', ');
        });
      }
    } catch (e) {
      print('Error getting address: $e');
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

  String remarks = "";

  @override
  Widget build(BuildContext context) {
    final currentDateTime =
        DateFormat('MMM dd, yyyy hh:mm a').format(DateTime.now());

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
    } else if (currentLat != null && currentLong != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFE26142),
          elevation: 0,
          title: const Text(
            "Attendance Portal",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Square image frame with rounded corners (Placeholder)
                  Container(
                    width: MediaQuery.of(context).size.height / 5,
                    height: MediaQuery.of(context).size.height / 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.transparent,
                    ),
                  ),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: selectedImage != null
                        ? Image.file(
                            selectedImage!,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.height / 5,
                            height: MediaQuery.of(context).size.height / 5,
                          )
                        : Image.asset(
                            "assets/icons/man.png",
                            width: MediaQuery.of(context).size.height / 5,
                            height: MediaQuery.of(context).size.height / 5,
                          ),
                  ),
                ],
              ),
              if (fullAddress.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Card(
                    elevation: 4, // Add elevation for a raised appearance
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    // Use LinearGradient for a gradient background
                    color: Colors
                        .transparent, // Set the card background to transparent
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.deepOrange,
                            Colors.orange
                          ], // Define your two colors here
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Street: $fullAddress",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          if (sublocaity.isNotEmpty)
                            Text(
                              "Sublocality: $sublocaity",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          Text(
                            "Country: $countryName",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 7),
                          const SizedBox(height: 7),
                          Container(
                            padding: const EdgeInsets.all(
                                5.0), // Adjust padding as needed
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Background color for the date capsule
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              "$currentDateTime",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors
                                    .deepOrange, // Text color for the date
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Add Remarks TextField
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Remarks',
                    hintText: 'Enter your remarks...',
                  ),
                  onChanged: (value) {
                    setState(() {
                      remarks = value;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: ElevatedButton(
                  onPressed: chooseImage,
                  style: ElevatedButton.styleFrom(
                    primary: Colors
                        .orange, // Change to your desired background color
                    padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24), // Adjust padding as needed
                  ),
                  child: Text(
                    "Click Your Photo",
                    style: GoogleFonts.lato(
                      // Replace with your desired Google Fonts style
                      textStyle: const TextStyle(
                        fontSize: 16, // Adjust the font size as needed
                        fontWeight:
                            FontWeight.bold, // Adjust the font weight as needed
                        color: Colors.white, // Change text color as needed
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: ElevatedButton(
                  onPressed: () async {
                    _markAttendance();
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        Colors.blue, // Change to your desired background color
                    padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24), // Adjust padding as needed
                  ),
                  child: const Text(
                    "Mark Your Attendance",
                    style: TextStyle(
                      fontSize: 16, // Adjust the font size as needed
                      fontWeight:
                          FontWeight.bold, // Adjust the font weight as needed
                      color: Colors.white, // Change text color as needed
                    ),
                  ),
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
