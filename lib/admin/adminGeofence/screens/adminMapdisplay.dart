import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
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
  double? sendRadius = 100.0;
  String address = "";

  bool locationError = false;
  final adminGeoFenceRepository = AdminGeoFenceRepository();

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

  Future<void> _submitGeofenceDataForSelectedEmployees() async {
    final adminGeofenceBloc = BlocProvider.of<AdminGeoFenceBloc>(context);

    final List<GetActiveEmpModel> selectedEmployees = widget.selectedEmployees;
    final List<AdminGeoFenceModel> geofenceDataList = [];

    for (int i = 0; i < selectedEmployees.length; i++) {
      final employee = selectedEmployees[i];

      // Use the employee data to create the geofence model
      final geofenceModel = AdminGeoFenceModel(
        empId: employee.empId ?? 0,
        empName: employee.empName,
        lat: currentLat.toString(),
        lon: currentLong.toString(),
        radius: sendRadius.toString(),
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

  @override
  Widget build(BuildContext context) {
    final adminGeofenceBloc = BlocProvider.of<AdminGeoFenceBloc>(context);
    return BlocConsumer<InternetBloc, InternetStates>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is InternetGainedState) {
            if (currentLat != null && currentLong != null && !locationError) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: AppColors.primaryColor,
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
                  iconTheme: IconThemeData(color: Colors.white),
                ),
                body: Stack(
                  children: [
                    OpenStreetMapSearchAndPick(
                      center: LatLong(currentLat!, currentLong!),
                      buttonColor: AppColors.primaryColor,
                      buttonText: 'Get This Point',
                      onPicked: (pickedData) {
                        getAddress(pickedData.latLong.latitude,
                            pickedData.latLong.longitude);
                        setState(() {
                          sendLat = pickedData.latLong.latitude;
                          sendLong = pickedData.latLong.longitude;
                          _submitGeofenceDataForSelectedEmployees();
                          saveLocationToSharedPreferences(sendLat!, sendLong!);
                        });
                        showSnackbar(context, "Cordinates Are Saved");
                      },
                      locationPinIconColor: AppColors.secondaryColor,
                      locationPinText: "${address}",
                    ),
                    Positioned(
                      top: (MediaQuery.of(context).size.height / 2) -
                          90 -
                          10, // Adjust position as needed
                      left: (MediaQuery.of(context).size.width / 2) - 30 - 20,
                      child: Container(
                        width: 100, // Adjust the radius as needed
                        height: 100, // Adjust the radius as needed
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor.withOpacity(0.25),
                          border: Border.all(
                            color: AppColors.secondaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: (MediaQuery.of(context).size.height / 2.5) ,// Adjust position as needed
                      left: (MediaQuery.of(context).size.width / 1.24),
                      child: Container(
                        child: SfSlider.vertical(
                          min: 100.0,
                          max: 300.0,
                          value: sendRadius,
                          interval: 50,
                          showTicks: true,
                          showLabels: true,
                          inactiveColor: AppColors.darkGrey,
                          activeColor: AppColors.primaryColor,
                          enableTooltip: true,
                          minorTicksPerInterval: 1,
                          onChanged: (dynamic value) {
                            setState(() {
                              sendRadius = value;
                              print(sendRadius);
                            });
                          },
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
                  backgroundColor: AppColors.primaryColor,
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
                backgroundColor: AppColors.primaryColor,
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
