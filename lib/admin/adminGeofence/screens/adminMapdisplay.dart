import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/constants/AppBar_constant.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../../../No_internet/no_internet.dart';
import '../../../introduction/bloc/bloc_internet/internet_bloc.dart';
import '../../../introduction/bloc/bloc_internet/internet_state.dart';
import '../../adminReportsFiles/models/getActiveEmployeesModel.dart';
import '../bloc/admin_geofence_bloc.dart';
import '../bloc/admin_geofence_event.dart';
import '../models/adminGeofenceModel.dart';
import '../models/adminGeofencePostRepository.dart';

class AdminMapDisplay extends StatefulWidget {
  final List<GetActiveEmpModel> selectedEmployees;

  const AdminMapDisplay({Key? key, required this.selectedEmployees})
      : super(key: key);

  @override
  State<AdminMapDisplay> createState() => _AdminMapDisplayState();
}

class _AdminMapDisplayState extends State<AdminMapDisplay> {
  double? currentLat;
  double? currentLong;
  double? sendLat;
  double? sendLong;
  double? sendRadius = 1.0;
  String address = "";
  bool isKeyboardVisible = false;



  bool locationError = false;
  final adminGeoFenceRepository = AdminGeoFenceRepository();

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        isKeyboardVisible = visible;
      });
    });
    checkLocationPermissionAndFetchLocation();
  }

  Future<void> saveLocationToSharedPreferences(double lat, double long) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', lat);
    await prefs.setDouble('longitude', long);
  }

  Future<void> _submitGeofenceDataForSelectedEmployees() async {
    final adminGeofenceBloc = BlocProvider.of<AdminGeoFenceBloc>(context);

    final List<GetActiveEmpModel> selectedEmployees = widget.selectedEmployees;
    final List<AdminGeoFenceModel> geofenceDataList = [];

    for (int i = 0; i < selectedEmployees.length; i++) {
      final employee = selectedEmployees[i];

      // Use the employee data to create the geofence model
      final geofenceModel = AdminGeoFenceModel(
        empId: employee.empId  ?? 0,
        empName: employee.empName,
        lat: sendLat.toString(),
        lon: sendLong.toString(),
        radius: (sendRadius!*1000).toString(),
        emailAddress: null,
        fatherName: null,
        phoneNo: null,
        profilePic: null,
        pwd: null,
        // Add other required fields based on your model
      );

      geofenceDataList.add(geofenceModel);
    }

    // Post the geofence data for selected employees
    await adminGeoFenceRepository.postGeoFenceData(geofenceDataList);
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

  void popPage() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }

  bool isInternetLost = false;

  void _updateLocation(double latitude, double longitude, String addressName) {
    setState(() {
      sendLat = latitude;
      sendLong = longitude;
      address = addressName;
      _submitGeofenceDataForSelectedEmployees();
      saveLocationToSharedPreferences(sendLat!, sendLong!);
    });
  }
  @override
  Widget build(BuildContext context) {
    final adminGeofenceBloc = BlocProvider.of<AdminGeoFenceBloc>(context);
    return BlocConsumer<InternetBloc, InternetStates>(
        listener: (context, state) {
      if (state is InternetLostState) {
        // Set the flag to true when internet is lost
        isInternetLost = true;
        Future.delayed(Duration(seconds: 2), () {
          Navigator.push(
            context,
            PageTransition(
              child: NoInternet(),
              type: PageTransitionType.rightToLeft,
            ),
          );
        });
      } else if (state is InternetGainedState) {
        // Check if internet was previously lost
        if (isInternetLost) {
          // Navigate back to the original page when internet is regained
          Navigator.pop(context);
        }
        isInternetLost = false; // Reset the flag
      }
    }, builder: (context, state) {
      if (state is InternetGainedState) {
        if (currentLat != null && currentLong != null && !locationError) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppBarStyles.appBarBackgroundColor,
              elevation: 0,
              title: const Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 55.0), // Add right padding
                  child: Text(
                    "Maps",
                    style: AppBarStyles.appBarTextStyle,
                  ),
                ),
              ),
              iconTheme: IconThemeData(color: AppBarStyles.appBarIconColor),
            ),
            body: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height >700? 60 : 70),
                  child: OpenStreetMapSearchAndPick(
                    onPicked: (pickedData) {
                      setState(() {
                        // Update the state for locationPin and other relevant data
                        address = pickedData.addressName;
                        sendLat = pickedData.latLong.latitude;
                        sendLong = pickedData.latLong.longitude;
                        _submitGeofenceDataForSelectedEmployees();
                        saveLocationToSharedPreferences(sendLat!, sendLong!);
                      });
                      print("Picked data value $pickedData");
                      showSnackbar(context, "Coordinates Are Saved");
                      // popPage();
                    },


                    zoomOutIcon: Icons.zoom_out, // Change this as needed
                    zoomInIcon: Icons.zoom_in,   // Change this as needed
                    currentLocationIcon: Icons.my_location,
                    locationPinIcon: Icons.location_on,
                    buttonWidth: 50,
                    buttonColor: AppColors.primaryColor,
                    buttonTextColor: Colors.white, // Change this as needed
                    buttonText: 'Set Geofence',
                    locationPinIconColor: AppColors.secondaryColor,
                    locationPinText: "", // Use the state directly
                    locationPinTextStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    hintText: 'Search Location',
                    buttonTextStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (!isKeyboardVisible)
                Positioned(
                  top: MediaQuery.of(context).size.height > 700 ? (MediaQuery.of(context).size.height /
                      3.5): (MediaQuery.of(context).size.height /
                      8), // Adjust position as needed
                  left: (MediaQuery.of(context).size.width / 1.22),
                  child: Container(
                    child: SfSlider.vertical(
                      min: 1.0,
                      max: 5.0,
                      value: sendRadius,
                      interval: 1,
                      showTicks: true,
                      showLabels: true,
                      inactiveColor: AppColors.darkGrey,
                      activeColor: AppColors.primaryColor,
                      enableTooltip: true,
                      minorTicksPerInterval: 1,
                      onChanged: (dynamic value) {
                        setState(() {
                          sendRadius = value;
                          print("Radius is: $sendRadius");
                        });
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 220,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent, // Use your desired warning color
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info,
                            color: Colors.black,
                          ),
                          SizedBox(width: 8), // Adjust the spacing between icon and text
                          Text(
                            "Pick location and set geofence",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )

              ],
            ),
          );
        } else {
          checkLocationPermissionAndFetchLocation();
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primaryColor,
              elevation: 0,
              title: const Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 55.0), // Add right padding
                  child: Text(
                    "Maps",
                    style: AppBarStyles.appBarTextStyle,
                  ),
                ),
              ),
              iconTheme: IconThemeData(color: AppBarStyles.appBarIconColor),
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
      } else {
        checkLocationPermissionAndFetchLocation();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            elevation: 0,
            title: const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 55.0), // Add right padding
                child: Text(
                  "Maps",
                  style: AppBarStyles.appBarTextStyle,
                ),
              ),
            ),
            iconTheme: IconThemeData(color: AppBarStyles.appBarIconColor),
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




