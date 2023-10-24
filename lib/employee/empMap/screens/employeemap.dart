import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';

import '../models/attendanceGeoFencingModel.dart';
import '../models/attendanceGeoFencingRepository.dart';
import '../models/geofenceGetLatLongRepository.dart';
import '../models/geofenceGetlatLongmodel.dart';

class EmployeeMap extends StatefulWidget {
  EmployeeMap({Key? key}) : super(key: key);

  @override
  _EmployeeMapState createState() => _EmployeeMapState();
}

class _EmployeeMapState extends State<EmployeeMap> {
  double? getLat;
  double? getLong;
  double? geofenceRadius = 100;

  double? currentLat;
  double? currentLong;
  bool locationError = false;
  String Street = "";
  String fullAddress = "";
  String countryName = "";

  File? selectedImage;
  String base64Image = "";
  late String sublocaity;

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    _initializelatLong();
    display();
    checkLocationPermissionAndFetchLocation();
  }

  Future<void> _initializelatLong() async {
    final getLatLongRepo = GetLatLongRepo();
    getLatLong? locationData;
    locationData = await getLatLongRepo.fetchData();

    if (locationData?.lat != null &&
        locationData?.lon != null &&
        locationData?.radius != null) {
      getLat = double.parse(locationData!.lat!);
      getLong = double.parse(locationData!.lon!);
      geofenceRadius = double.parse(locationData!.radius!);
    }

    print("This are ${getLat} ${getLong} ${geofenceRadius} ");
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

      print("This is the distanceeeeeeeee! ${distance} ");

      if (distance <= geofenceRadius!) {
        print(
            "${geofenceLatitude} ${geofenceLongitude} ${currentLat} ${currentLong} ${distance}");
        //inRadius();

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String cardNo = prefs.getString('cardNo') ?? " ";
        String imei = "fake imei";
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo? androidInfo;
        Future<AndroidDeviceInfo> getInfo() async {
          return await deviceInfo.androidInfo;
        }

        print(getInfo());
        if (selectedImage == null) {
          _imageError();
        } else {
          final base64Image = base64Encode(selectedImage!.readAsBytesSync());
          final geoFenceModel = GeofenceModel(
            cardno: cardNo.toString(),
            location: fullAddress,
            lan: currentLat.toString(),
            long: currentLong.toString(),
            imageData: base64Image,
            imeiNo: imei,
            temp1: '',
            temp2: '',
            attendanceType: null,
            remark1: remarks,
            imagepath: '',
            punchDatetime: DateTime.now(),
          );
          final geoFenceRepository = GeoFenceRepository("Office");

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
      } else if (distance >= geofenceRadius!) {
        Fluttertoast.showToast(
          msg: 'Failed to mark attendance. Please check your Location.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } else if (geofenceLatitude == null || geofenceLongitude == null) {
      Fluttertoast.showToast(
        msg:
        'Oops...Geofence Not Started by office.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } else {
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

  void _imageError() {
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
        });
  }

  Future<void> _markAttendance() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String cardNo = prefs.getString('cardNo') ?? " ";
    String imei = "fake imei";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo? androidInfo;
    Future<AndroidDeviceInfo> getInfo() async {
      return await deviceInfo.androidInfo;
    }

    print(getInfo());
    if (selectedImage == null) {
      _imageError();
    } else {
      final base64Image = base64Encode(selectedImage!.readAsBytesSync());
      final geoFenceModel = GeofenceModel(
        cardno: cardNo.toString(),
        location: fullAddress,
        lan: currentLat.toString(),
        long: currentLong.toString(),
        imageData: base64Image,
        imeiNo: imei,
        temp1: '',
        temp2: '',
        attendanceType: null,
        remark1: remarks,
        imagepath: '',
        punchDatetime: DateTime.now(),
      );
      final geoFenceRepository = GeoFenceRepository("Location");

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
          desiredAccuracy: LocationAccuracy.best,
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

  /*
  void _geoFenceNotStart() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Oops..'),
          content: const Text('Geofence Not Started by office'),
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
*/

  void CheckOfficeOrLocation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Attendance'),
          content: const Text('Mark Attendance From Office/Location'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _startGeoFencingUpdate();
                Navigator.pop(context);
              },
              child: const Text('Office'),
            ),
            TextButton(
              onPressed: () {
                _markAttendance();
                Navigator.pop(context);
              },
              child: const Text('Location'),
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
          if (placemarks[3].street != null) {
            Street = placemarks[2].street!;
          }
          if (placemarks[3].subLocality != null) {
            sublocaity = placemarks[3].subLocality!;
          }
          final List<String> countryNameParts = [];
          if (placemarks[4].locality != null) {
            countryNameParts.add(placemarks[4].locality!);
          }
          if (placemarks[0].country != null) {
            countryNameParts.add(placemarks[0].country!);
          }
          countryName = countryNameParts.join(', ');
        });
        fullAddress = "${Street} ${sublocaity} ${countryName}";
        print("${fullAddress}");
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
          backgroundColor: AppColors.primaryColor,
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
          padding: EdgeInsets.fromLTRB(
              15, MediaQuery.of(context).size.height / 8.5, 15, 15),
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

                  ClipOval(
                    child: selectedImage != null
                        ? Image.file(
                            selectedImage!,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.height / 4.5,
                            height: MediaQuery.of(context).size.height / 4.5,
                          )
                        : Image.asset(
                            "assets/icons/userr.png",
                            width: MediaQuery.of(context).size.height / 5,
                            height: MediaQuery.of(context).size.height / 5,
                          ),
                  ),
                ],
              ),
              if (Street.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    // Use LinearGradient for a gradient background

                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Street: $Street",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          if (sublocaity.isNotEmpty)
                            Text(
                              "Sublocality: $sublocaity",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          Text(
                            "Country: $countryName",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Container(
                            padding: const EdgeInsets.all(
                                2.0), // Adjust padding as needed
                            decoration: BoxDecoration(
                              // Background color for the date capsule
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              "$currentDateTime",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Text color for the date
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
                    primary: AppColors
                        .primaryColor, // Change to your desired background color
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
                    if (selectedImage != null) {
                      CheckOfficeOrLocation();
                    } else {
                      _imageError();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AppColors
                        .primaryColor, // Change to your desired background color
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
