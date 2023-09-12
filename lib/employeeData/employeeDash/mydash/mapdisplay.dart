import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';


class MapDisplay extends StatefulWidget {
  const MapDisplay({Key? key}) : super(key: key);

  @override
  State<MapDisplay> createState() => _MapDisplayState();
}

class _MapDisplayState extends State<MapDisplay> {
  double? currentLat;
  double? currentLong;
  double? sendLat;
  double? sendLong;
  String address = "";

  @override
  void initState() {
    super.initState();
    fetchLocation();
  }

  Future<void> fetchLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      try {
        final data = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          currentLat = data.latitude;
          currentLong = data.longitude;
        });
        getAddress(currentLat, currentLong);
      } catch (e) {
        print('Error getting location: $e');
      }
    } else {
      // Handle the case when the user denies location permission.
      // You might want to show a message or provide a way for the user to grant permission.
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE26142),
        elevation: 0,
        title: Row(
          children: [
            const Center(
              child: Text("Admin"),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
              },
              child: const Icon(Icons.check, color: Colors.teal),
            ),
          ],
        ),
      ),
      body: (currentLat != null && currentLong != null)
          ? Stack(
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
                    });
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
                      20, // Adjust position as needed
                  child: Container(
                    width: 100, // Adjust the radius as needed
                    height: 100, // Adjust the radius as needed
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE26142).withOpacity(0.25),
                      border: Border.all(
                        color: Color(0xFFE26142),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
