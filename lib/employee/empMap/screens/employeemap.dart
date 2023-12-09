import 'dart:async';
import 'package:cool_alert/cool_alert.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project/constants/AppBar_constant.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';
import '../../../constants/AnimatedTextPopUp.dart';
import '../models/attendanceGeoFencingModel.dart';
import '../models/attendanceGeoFencingRepository.dart';
import '../models/geofenceGetLatLongRepository.dart';
import '../models/geofenceGetlatLongmodel.dart';

class EmployeeMap extends StatefulWidget {
  EmployeeMap({Key? key}) : super(key: key);

  @override
  _EmployeeMapState createState() => _EmployeeMapState();
}

class _EmployeeMapState extends State<EmployeeMap> with TickerProviderStateMixin {
  double? getLat;
  double? getLong;
  double? geofenceRadius = 100;
  late AnimationController addToCartPopUpAnimationController;
  double? currentLat;
  double? currentLong;
  bool locationError = false;
  String Street = "";
  String fullAddress = "";
  String countryName = "";
  File? selectedImage;
  String base64Image = "";
  late String sublocaity;

  void showPopupWithSuccessMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addToCartPopUpSuccess(
            addToCartPopUpAnimationController,
            message
        );
      },
    );
  }

  void showPopupWithFailedMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addToCartPopUpFailed(
            addToCartPopUpAnimationController,
            message
        );
      },
    );
  }

  @override
  void initState() {
    addToCartPopUpAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    super.initState();
    checkLocationPermission();
    _initializelatLong();
    display();
    checkLocationPermissionAndFetchLocation();
  }

  @override
  void dispose() {
    addToCartPopUpAnimationController.dispose();
    super.dispose();
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
    print("hi1");
    if (geofenceLatitude != null &&
        geofenceLongitude != null &&
        currentLat != null &&
        currentLong != null) {
      print("hi3");

      double distance = Geolocator.distanceBetween(
        geofenceLatitude,
        geofenceLongitude,
        currentLat!,
        currentLong!,
      );
      print("hi2");

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
            addToCartPopUpAnimationController.forward();
            // Delay for a few seconds and then reverse the animation
            Timer(const Duration(seconds: 3), () {
              addToCartPopUpAnimationController.reverse();
              Navigator.pop(context);
            });
            showPopupWithSuccessMessage("Attendance marked successfully!");
          } catch (e) {
            addToCartPopUpAnimationController.forward();
            // Delay for a few seconds and then reverse the animation
            Timer(const Duration(seconds: 3), () {
              addToCartPopUpAnimationController.reverse();
              Navigator.pop(context);
            });
            showPopupWithFailedMessage("Failed to mark.Check your internet!");
          }
        }
      } else if (distance >= geofenceRadius!) {
        addToCartPopUpAnimationController.forward();
        // Delay for a few seconds and then reverse the animation
        Timer(const Duration(seconds: 3), () {
          addToCartPopUpAnimationController.reverse();
          Navigator.pop(context);
        });
        showPopupWithFailedMessage("GeoPunch not allowed at this location!");
      }
    }
    else if (geofenceLatitude == null || geofenceLongitude == null) {
      print("hi4");
      print(geofenceLatitude);
      print(geofenceLongitude);
      Navigator.pop(context);
      showCustomWarningAlert(context, "Geofence not started by office");
    }
    else {
      print("hi5");

      addToCartPopUpAnimationController.forward();
      // Delay for a few seconds and then reverse the animation
      Timer(const Duration(seconds: 3), () {
        addToCartPopUpAnimationController.reverse();
        Navigator.pop(context);
      });
      showPopupWithFailedMessage("Failed to mark.Check your internet!");
    }
  }

  void _imageError() {
    showCustomWarningAlert(context, "Please take photo before proceeding");
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
      final originalImageBytes = await selectedImage!.readAsBytes();
      final resizedImageBytes = await resizeImage(originalImageBytes, 256, 256);

      final base64Image = base64Encode(resizedImageBytes);

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
        Navigator.pop(context);
        await geoFenceRepository.postData(geoFenceModel);
        addToCartPopUpAnimationController.forward();
        // Delay for a few seconds and then reverse the animation
        Timer(const Duration(seconds: 3), () {
          addToCartPopUpAnimationController.reverse();
          Navigator.pop(context);
        });
        showPopupWithSuccessMessage("Attendance successfully marked!");
      } catch (e) {
        addToCartPopUpAnimationController.forward();
        // Delay for a few seconds and then reverse the animation
        Timer(const Duration(seconds: 3), () {
          addToCartPopUpAnimationController.reverse();
          Navigator.pop(context);
        });
        showPopupWithFailedMessage("Failed to mark. Check your internet!");
      }
    }
  }

  Future<List<int>> resizeImage(Uint8List imageBytes, int targetWidth, int targetHeight) async {
    img.Image image = img.decodeImage(imageBytes)!;

    img.Image resizedImage = img.copyResize(image, width: targetWidth, height: targetHeight);

    return img.encodePng(resizedImage);
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



  void CheckOfficeOrLocation() {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      title: 'Attendance',
      text: 'Mark Attendance From Office/Location',
      confirmBtnText: 'Office',
      cancelBtnText: 'Location',
      onConfirmBtnTap: () {
        _startGeoFencingUpdate();

      },
      onCancelBtnTap: () {
        _markAttendance();

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
    var image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 10);

    if (image != null) {
      // Read image bytes
      final imageBytes = await image.readAsBytes();
      final resizedImage = await resizeImage(imageBytes, 256, 256);
      final originalDimensions = await getImageDimensions(imageBytes);
      final resizedDimensions = await getImageDimensions(resizedImage);


      print('Original Image Dimensions: $originalDimensions');
      print('Resized Image Dimensions: $resizedDimensions');


      setState(() {
        selectedImage = File(image.path);
        base64Image = base64Encode(resizedImage);
      });
    }
  }



  Future<List<int>> getImageDimensions(List<int> imageBytes) async {
    final image = await decodeImageFromList(Uint8List.fromList(imageBytes));
    return [image.width, image.height];
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
            style: AppBarStyles.appBarTextStyle
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
                      width: 256,
                      height: 256,
                    )
                        : Image.asset(
                      "assets/icons/userr.png",
                      width: 256,
                      height: 256,
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "Street: $Street",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center, // Align text in the center
                            ),
                          ),
                          if (sublocaity.isNotEmpty)
                            Center(
                              child: Text(
                                "Sublocality: $sublocaity",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center, // Align text in the center
                              ),
                            ),
                          Center(
                            child: Text(
                              "Country: $countryName",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center, // Align text in the center
                            ),
                          ),
                          const SizedBox(height: 7),
                          Container(
                            padding: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              currentDateTime,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
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
